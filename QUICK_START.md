# ⚡ QUICK START - Email/Password Registration (20 minutes)

**Skip the long docs? Start here!**

---

## 🎯 All You Need to Do (3 Steps)

### STEP 1️⃣: Copy SQL into Supabase (10 min)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click your project
3. Click **SQL Editor** (left sidebar)
4. Copy this entire block:

```sql
-- QUERY 1: Users Table
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

5. Click **Run** ✅
6. Copy this block:

```sql
-- QUERY 2: Patients Table
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

7. Click **Run** ✅
8. Copy this block:

```sql
-- QUERY 3: Auto Trigger
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

9. Click **Run** ✅

**Done with SQL!** ✨

---

### STEP 2️⃣: Get Your API Keys (3 min)

1. In Supabase, click **Settings** (bottom left)
2. Click **API**
3. Copy the **Project URL** (format: `https://xxxxx.supabase.co`)
4. Copy **anon public** key (the long string)
5. Keep these safe

---

### STEP 3️⃣: Update .env & Run (7 min)

1. Open your project's `.env` file
2. Delete any Google OAuth lines if they exist
3. Add these 2 lines:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

4. Paste the actual values from STEP 2
5. Save the file
6. Run your app:

```bash
flutter run
```

---

## ✅ Done!

Your backend is ready. To use it:

```dart
// After user signs up with email/password:
final notifier = ref.read(patientRegistrationProvider.notifier);

await notifier.registerPatient(
  userId: currentUser.id,
  dateOfBirth: '1990-05-15',
  gender: 'Male',
  bloodGroup: 'O+',
  allergies: [],
  chronicConditions: [],
  emergencyContactName: 'John Doe',
  emergencyContactPhone: '+1-555-0123',
);
```

---

## 📚 Need More Details?

- **Full Setup:** [EMAIL_PASSWORD_SETUP.md](EMAIL_PASSWORD_SETUP.md)
- **Database Schema:** [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)
- **Visual Guide:** [VISUAL_GUIDE.md](VISUAL_GUIDE.md)
- **Code Examples:** [PATIENT_REGISTRATION_GUIDE.md](PATIENT_REGISTRATION_GUIDE.md)

---

## 🆘 Troubleshooting

**"Query failed" error?**
→ Copy it exactly, one at a time

**"App won't start"?**
→ Check .env spelling and values

**"User not in database"?**
→ Make sure you signed up AFTER creating tables

**"SUPABASE_URL not found"?**
→ Check .env file is in project root

---

**That's it! 🎉 You're done in ~20 minutes!**
