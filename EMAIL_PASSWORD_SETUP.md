# Email & Password Registration - Supabase Setup Guide

## 🎯 Overview

This guide focuses on **email/password authentication only** - no Google OAuth. The backend code is already ready; you just need to set up the database.

---

## 📋 Step 1: Copy These SQL Queries to Supabase

Go to: **Supabase Dashboard → SQL Editor** and run these queries one by one.

### Query 1: Create Users Table

```sql
-- Create users table (stores user profiles)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'patient' CHECK (role IN ('patient', 'doctor', 'hospital', 'lab', 'pharmacy')),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- RLS Policy 1: Users can read their own data
CREATE POLICY IF NOT EXISTS "Users can read own data" ON public.users
  FOR SELECT USING (auth.uid() = id);

-- RLS Policy 2: Users can update their own data
CREATE POLICY IF NOT EXISTS "Users can update own data" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- RLS Policy 3: Anyone can insert during signup
CREATE POLICY IF NOT EXISTS "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

### Query 2: Create Patients Table

```sql
-- Create patients table (stores patient medical information)
CREATE TABLE IF NOT EXISTS public.patients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE REFERENCES public.users(id) ON DELETE CASCADE,
  date_of_birth DATE,
  gender TEXT CHECK (gender IN ('Male', 'Female', 'Other')),
  blood_group TEXT CHECK (blood_group IN ('O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-')),
  allergies TEXT[] DEFAULT ARRAY[]::TEXT[],
  chronic_conditions TEXT[] DEFAULT ARRAY[]::TEXT[],
  emergency_contact_name TEXT,
  emergency_contact_phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_patients_user_id ON public.patients(user_id);
CREATE INDEX IF NOT EXISTS idx_patients_created_at ON public.patients(created_at);

-- Enable Row Level Security
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;

-- RLS Policy 1: Patients can read their own data
CREATE POLICY IF NOT EXISTS "Patients can read own data" ON public.patients
  FOR SELECT USING (auth.uid() = user_id);

-- RLS Policy 2: Patients can insert their own data
CREATE POLICY IF NOT EXISTS "Patients can insert own data" ON public.patients
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- RLS Policy 3: Patients can update their own data
CREATE POLICY IF NOT EXISTS "Patients can update own data" ON public.patients
  FOR UPDATE USING (auth.uid() = user_id);
```

### Query 3: Create Trigger for Auto User Profile Creation

```sql
-- Create function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, role, created_at, updated_at)
  VALUES (NEW.id, NEW.email, 'patient', NOW(), NOW())
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger to run function on new signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

## ⚙️ Step 2: Enable Email/Password Authentication

1. Go to: **Supabase Dashboard → Authentication**
2. Go to **Email/Password** tab
3. Make sure **Email Provider** is **Enabled**
4. Default settings are fine:
   - ✅ Confirm email enabled
   - ✅ Secure password required
5. Click **Save** if you made any changes

---

## 📝 Step 3: Update Your `.env` File

Make sure your `.env` file has ONLY these variables (no Google OAuth keys):

```env
# ============================================
# SUPABASE CONFIGURATION (Email/Password Only)
# ============================================
# Get these from: https://supabase.com/dashboard

# Your Supabase project URL
# Format: https://xxxxx.supabase.co
SUPABASE_URL=https://your-project-id.supabase.co

# Supabase anonymous/public API key
# From: Supabase Dashboard → Settings → API
SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

**How to get these values:**
1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Click **Settings** → **API**
4. Copy `Project URL` → `SUPABASE_URL`
5. Copy `anon public` key → `SUPABASE_ANON_KEY`
6. Paste into `.env` file

---

## 🔐 Step 4: Update main.dart to Remove Google Sign-In

Update your `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const ProviderScope(child: UnifiedHealthAllianceApp()));
}

class UnifiedHealthAllianceApp extends StatelessWidget {
  const UnifiedHealthAllianceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Unified Health Alliance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerDelegate: RoutemasterDelegate(routesBuilder: (_) => appRouter),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
```

---

## 📧 Step 5: Implement Email/Password Registration

Create this auth service file:

**Create: `lib/features/auth/services/auth_service.dart`**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient;

  AuthService({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Sign up user with email and password
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUpWithPassword(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      // Update user profile with display name
      if (response.user != null) {
        await _supabaseClient
            .from('users')
            .update({'name': displayName})
            .eq('id', response.user!.id);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in user with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _supabaseClient.auth.currentUser != null;
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## 📱 Step 6: Example Registration Screen

Create/Update: `lib/features/registration/email_password_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailPasswordSignupScreen extends ConsumerStatefulWidget {
  const EmailPasswordSignupScreen({super.key});

  @override
  ConsumerState<EmailPasswordSignupScreen> createState() =>
      _EmailPasswordSignupScreenState();
}

class _EmailPasswordSignupScreenState
    extends ConsumerState<EmailPasswordSignupScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill all fields');
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sign up with Supabase Auth
      final response = await Supabase.instance.client.auth
          .signUpWithPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (response.user != null) {
        // Update user profile with name
        await Supabase.instance.client
            .from('users')
            .update({'name': _nameController.text})
            .eq('id', response.user!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signup successful! Please verify your email.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to next screen (patient registration form)
          Navigator.pushReplacementNamed(context, '/patient-registration');
        }
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            const Text('Full Name'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            const Text('Email Address'),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            const Text('Password'),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password (min 6 characters)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Login Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔑 Step 7: Example Login Screen

Create: `lib/features/auth/screens/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/patient-home');
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email Address'),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Password'),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/signup'),
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ Complete SQL Copy-Paste Summary

Here's all 3 queries combined. Copy each one separately and run in Supabase SQL Editor:

**QUERY 1 - Create Users Table:**
```sql
CREATE TABLE IF NOT EXISTS public.users (
  id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'patient' CHECK (role IN ('patient', 'doctor', 'hospital', 'lab', 'pharmacy')),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "Users can read own data" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY IF NOT EXISTS "Users can update own data" ON public.users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY IF NOT EXISTS "Users can insert own profile" ON public.users FOR INSERT WITH CHECK (auth.uid() = id);
```

**QUERY 2 - Create Patients Table:**
```sql
CREATE TABLE IF NOT EXISTS public.patients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE REFERENCES public.users(id) ON DELETE CASCADE,
  date_of_birth DATE,
  gender TEXT CHECK (gender IN ('Male', 'Female', 'Other')),
  blood_group TEXT CHECK (blood_group IN ('O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-')),
  allergies TEXT[] DEFAULT ARRAY[]::TEXT[],
  chronic_conditions TEXT[] DEFAULT ARRAY[]::TEXT[],
  emergency_contact_name TEXT,
  emergency_contact_phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_patients_user_id ON public.patients(user_id);
CREATE INDEX IF NOT EXISTS idx_patients_created_at ON public.patients(created_at);
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "Patients can read own data" ON public.patients FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY IF NOT EXISTS "Patients can insert own data" ON public.patients FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY IF NOT EXISTS "Patients can update own data" ON public.patients FOR UPDATE USING (auth.uid() = user_id);
```

**QUERY 3 - Create Trigger:**
```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, role, created_at, updated_at)
  VALUES (NEW.id, NEW.email, 'patient', NOW(), NOW())
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

## 🔄 Registration Flow

```
User Signs Up (Email/Password)
         ↓
Supabase Auth creates user
         ↓
Trigger fires → Auto-creates profile in users table
         ↓
User fills patient details form
         ↓
patientRegistrationProvider.registerPatient()
         ↓
Patient record created in patients table
         ↓
Navigate to patient home
```

---

## ✨ What You Have Now

✅ Backend code already created (registration notifier, repository, service)
✅ 3 SQL queries ready to copy-paste
✅ Auth service for email/password
✅ Login screen example
✅ Signup screen example
✅ Automatic user profile creation on signup

**No Google OAuth needed!**

---

## 📌 Important Notes

1. **Users table is auto-created** when someone signs up (trigger handles it)
2. **Patients table** is empty until user completes patient registration form
3. **RLS is enabled** - users can only access their own data
4. **Passwords are hashed** by Supabase (you don't handle raw passwords)
5. **Email verification** happens automatically (Supabase sends email)

---

Done! Copy those 3 SQL queries into Supabase and you're ready to go! 🚀
