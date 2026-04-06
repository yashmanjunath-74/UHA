# Supabase Setup Guide for Patient Registration

This guide explains all the changes you need to make in Supabase to support patient registration.

---

## 1. Create the `users` Table

The `users` table stores authentication & basic user information.

### Steps:
1. Go to Supabase Dashboard → SQL Editor
2. Run the following SQL:

```sql
CREATE TABLE IF NOT EXISTS public.users (
  id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  phone TEXT,
  role TEXT NOT NULL CHECK (role IN ('patient', 'doctor', 'hospital', 'lab', 'pharmacy')),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_role ON public.users(role);

-- Enable RLS (Row Level Security)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create RLS policy: Users can read their own data
CREATE POLICY "Users can read own data" ON public.users
  FOR SELECT USING (auth.uid() = id);

-- Create RLS policy: Users can update their own data
CREATE POLICY "Users can update own data" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Create RLS policy: Anyone can insert (for authentication)
CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

---

## 2. Create the `patients` Table

The `patients` table stores patient-specific medical information.

### Steps:
1. Go to Supabase Dashboard → SQL Editor
2. Run the following SQL:

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

-- Create indexes for faster queries
CREATE INDEX idx_patients_user_id ON public.patients(user_id);
CREATE INDEX idx_patients_created_at ON public.patients(created_at);

-- Enable RLS
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Patients can read own data" ON public.patients
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Patients can insert own data" ON public.patients
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Patients can update own data" ON public.patients
  FOR UPDATE USING (auth.uid() = user_id);
```

---

## 3. Set Up Authentication with Google Sign-In

### Prerequisites:
- Google Cloud Project created
- OAuth 2.0 credentials configured

### Steps:

#### A. Configure Google OAuth in Google Cloud Console:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to **APIs & Services** → **Credentials**
4. Click **Create Credentials** → **OAuth 2.0 Client ID**

**For iOS:**
- Application type: **iOS**
- Bundle ID: `com.example.unifiedhealthalliance` (match your iOS bundle)
- Copy the generated **Client ID** → Add to `.env` as `GOOGLE_IOS_CLIENT_ID`

**For Web/Backend:**
- Application type: **Web application**
- Authorized redirect URIs: Add your Supabase redirect URI
  - Find it in: Supabase Dashboard → **Authentication** → **Providers** → **Google** → Copy "Redirect URL"
  - Format: `https://your-project.supabase.co/auth/v1/callback?provider=google`
- Copy the generated **Client ID** → Add to `.env` as `GOOGLE_SERVER_CLIENT_ID`

#### B. Enable Google Provider in Supabase:

1. Go to Supabase Dashboard
2. Navigate to **Authentication** → **Providers**
3. Find **Google** provider
4. Click **Enable**
5. Paste your Google OAuth credentials:
   - **Client ID**: (from Google Cloud Console)
   - **Client Secret**: (from Google Cloud Console)
6. Click **Save**

---

## 4. Enable Authentication in Supabase

### Steps:
1. Go to Supabase Dashboard → **Authentication**
2. Go to **Email** provider tab
3. Ensure **Email Provider** is enabled
4. Go to **Providers** → **Google** (as done above)
5. Configure JWT expiration time (recommended: 1 hour)

---

## 5. Create Database Triggers for User Creation

To automatically create a `users` profile when a user signs up, add a trigger:

### Steps:
1. Go to Supabase Dashboard → SQL Editor
2. Run the following SQL:

```sql
-- Create a function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, role, created_at, updated_at)
  VALUES (NEW.id, NEW.email, 'patient', NOW(), NOW())
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

This ensures that whenever a user signs up via Google or Email, a profile is automatically created in the `users` table.

---

## 6. Update `.env` File

Ensure your `.env` file has:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
GOOGLE_IOS_CLIENT_ID=your_google_ios_client_id
GOOGLE_SERVER_CLIENT_ID=your_google_server_client_id
```

Get these from:
- **SUPABASE_URL** & **SUPABASE_ANON_KEY**: Supabase Dashboard → Settings → API
- **Google credentials**: Google Cloud Console → APIs & Services → Credentials

---

## 7. How to Use Patient Registration in Your App

### Example: Registering a Patient

```dart
// In your registration completion screen
final patientNotifier = ref.read(patientRegistrationProvider.notifier);

await patientNotifier.registerPatient(
  userId: currentUser.id,
  dateOfBirth: '1990-05-15',
  gender: 'Male',
  bloodGroup: 'O+',
  allergies: ['Penicillin'],
  chronicConditions: ['Diabetes'],
  emergencyContactName: 'John Doe',
  emergencyContactPhone: '+1-555-0123',
);
```

### Example: Fetching Patient Profile

```dart
// Using the FutureProvider
const patientProfile = ref.watch(patientProfileProvider(userId));

patientProfile.when(
  data: (patient) => Text('Patient: ${patient.id}'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Example: Updating Patient Profile

```dart
final patientNotifier = ref.read(patientRegistrationProvider.notifier);

await patientNotifier.updatePatient(
  userId: currentUser.id,
  bloodGroup: 'A+',
  allergies: ['Penicillin', 'Sulfa'],
);
```

---

## 8. Database Schema Summary

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| `auth.users` | Supabase Auth (automatic) | id, email, encrypted_password |
| `users` | User profiles | id, email, name, phone, role, avatar_url |
| `patients` | Patient medical info | id, user_id, date_of_birth, gender, blood_group, allergies, chronic_conditions |

---

## 9. Row Level Security (RLS) Explanation

All tables have **RLS enabled**. This means:
- **Users can only access their own data**
- A patient can only access their own patient record
- Doctors/hospitals can be added later with specific policies

### To modify RLS policies:
1. Go to Supabase Dashboard → SQL Editor
2. Run modifications to `ALTER POLICY` commands

---

## 10. Testing the Setup

### Test Registration Flow:
1. Sign up a new user (via Google or Email)
2. Complete the patient registration form
3. Check Supabase → `users` table (new user should be there)
4. Check Supabase → `patients` table (patient profile should be there)

### Debug Database:
1. Supabase Dashboard → **SQL Editor**
2. Run: `SELECT * FROM public.users;`
3. Run: `SELECT * FROM public.patients;`

---

## 11. Next Steps

1. ✅ Create both tables in Supabase
2. ✅ Enable Google OAuth in Supabase
3. ✅ Create triggers for user creation
4. ✅ Update `.env` file
5. ✅ Test the registration flow
6. Add hospital, doctor, lab, pharmacy tables (similar pattern)
7. Add additional features (medical records, appointments, etc.)

---

## Troubleshooting

### "Patient not found" error
- Check if user was created in `users` table first
- Verify `user_id` in patient registration matches the auth user ID

### "Permission denied" error
- Ensure RLS policies are correctly set up
- Check that `auth.uid()` returns the correct user ID

### "Invalid credentials" error
- Verify Google OAuth credentials in Supabase match Google Cloud Console
- Check `.env` file has correct values
- Restart the app after updating `.env`

---

## References
- [Supabase Docs](https://supabase.com/docs)
- [Supabase Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Google OAuth](https://supabase.com/docs/guides/auth/social-login/auth-google)
