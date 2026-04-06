# Email/Password Registration - Simple Visual Guide

---

## 🎯 What You Need to Do (3 Simple Steps)

### STEP 1️⃣: Run SQL Queries in Supabase (10 minutes)

```
┌──────────────────────────────────────────┐
│  Open Supabase Dashboard                 │
│  → SQL Editor                            │
│                                          │
│  Copy & Paste 3 Queries:                 │
│  ✅ QUERY 1: Users Table                 │
│  ✅ QUERY 2: Patients Table              │
│  ✅ QUERY 3: Auto Trigger                │
│                                          │
│  Click RUN for each query                │
└──────────────────────────────────────────┘

Find queries in: SQL_QUERIES_COPY_PASTE.md
```

### STEP 2️⃣: Enable Email Auth & Get Keys (5 minutes)

```
┌──────────────────────────────────────────┐
│  In Supabase Dashboard:                  │
│                                          │
│  Authentication → Email/Password         │
│  ✅ Make sure it shows ENABLED           │
│                                          │
│  Settings → API                          │
│  ✅ Copy Project URL                     │
│  ✅ Copy anon public key                 │
└──────────────────────────────────────────┘
```

### STEP 3️⃣: Update .env & Run App (5 minutes)

```
┌──────────────────────────────────────────┐
│  Edit .env file in your project:         │
│                                          │
│  SUPABASE_URL=https://xxxxx.supabase.co │
│  SUPABASE_ANON_KEY=your_key_here        │
│                                          │
│  Save file                               │
│                                          │
│  Run: flutter run                        │
│  ✅ Done!                                │
└──────────────────────────────────────────┘
```

---

## 📊 Database Flow

```
                    ┌────────────────────┐
                    │  User Signs Up     │
                    │ (Email/Password)   │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  Supabase Auth     │
                    │  Creates user_id   │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  Trigger Fires     │
                    │  Auto-creates row  │
                    │  in users table    │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  User fills form   │
                    │  (Date, Gender, etc)
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  registerPatient() │
                    │  Called            │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  Patient row       │
                    │  Created in        │
                    │  patients table    │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  Navigate to Home  │
                    │  ✅ Complete!      │
                    └────────────────────┘
```

---

## 📁 Files You Need to Read

```
1. SQL_QUERIES_COPY_PASTE.md
   ↓ (Copy 3 SQL queries)
   
2. SETUP_CHECKLIST.md
   ↓ (Follow step by step)
   
3. EMAIL_PASSWORD_SETUP.md
   ↓ (Extra details & code examples)
   
4. Your app is ready to use!
```

---

## 🔑 Key Information

### Tables Created:
```
users table:
├─ id (auto from auth)
├─ email
├─ name
├─ phone
├─ role (default: 'patient')
├─ avatar_url
└─ timestamps

patients table:
├─ id
├─ user_id (links to users.id)
├─ date_of_birth
├─ gender
├─ blood_group
├─ allergies (array)
├─ chronic_conditions (array)
├─ emergency_contact_name
├─ emergency_contact_phone
└─ timestamps
```

### What Happens Automatically:
```
✅ User signs up → Auth system validates
✅ User created in auth.users → Supabase handles
✅ Trigger fires → User profile created in users table
✅ User can now register as patient → Patient table updated
✅ Data is secure → RLS policies protect
✅ ✅ ✅ Everything ready!
```

---

## ❌ What You DON'T Need to Do

```
❌ Google OAuth setup
❌ Google Cloud Console
❌ Google Client IDs
❌ Custom auth code (Supabase handles it)
❌ Password hashing (Supabase handles it)
❌ Email verification setup (Supabase handles it)
```

---

## 🎁 What You GET for Free from Supabase

```
✅ Secure password hashing
✅ Email verification
✅ Password reset functionality
✅ Session management
✅ JWT tokens
✅ Admin dashboard
✅ All data encrypted
✅ Automatic SSL certificates
```

---

## 📞 When You're Done

### Your Backend Code is Already Ready:
- ✅ PatientRepository (database operations)
- ✅ PatientController (Riverpod providers)
- ✅ PatientService (high-level API)

### Just Integrate into UI:
```dart
// In your registration screen, after user signs up:
final notifier = ref.read(patientRegistrationProvider.notifier);
await notifier.registerPatient(
  userId: currentUser.id,
  dateOfBirth: '1990-05-15',
  gender: 'Male',
  bloodGroup: 'O+',
  allergies: [],
  chronicConditions: [],
  emergencyContactName: 'Contact',
  emergencyContactPhone: '+1-555-0123',
);
```

That's it! 🎉

---

## 📋 Exact Order to Follow

```
1. Open SQL_QUERIES_COPY_PASTE.md
   ↓
2. Go to Supabase SQL Editor
   ↓
3. Copy QUERY 1 → Run → Verify Success
   ↓
4. Copy QUERY 2 → Run → Verify Success
   ↓
5. Copy QUERY 3 → Run → Verify Success
   ↓
6. Go to Supabase Settings → API
   ↓
7. Copy URL & Key
   ↓
8. Edit your .env file
   ↓
9. Paste URL & Key
   ↓
10. Run: flutter run
    ↓
11. ✅ DONE!
```

---

## ⏱️ Timeline

| Task | Time | Status |
|------|------|--------|
| Read this file | 3 min | 👈 You are here |
| Run SQL queries | 10 min | Next |
| Get API keys | 2 min | Then |
| Update .env | 3 min | Then |
| Run app & test | 5 min | Finally |
| **TOTAL** | **23 min** | **Ready!** |

---

## 🆘 Common Issues & Quick Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| "Table already exists" | Query 1 ran twice | Try again, it's fine |
| "Permission denied" | RLS policy issue | Re-run Query 1 |
| "App won't start" | Wrong .env values | Copy again carefully |
| "User not in database" | Trigger didn't run | Check Query 3 ran |
| "Email not verified" | Not enabled in Supabase | Enable Email/Password provider |

---

**Quick Link to Start:** [SQL_QUERIES_COPY_PASTE.md](SQL_QUERIES_COPY_PASTE.md)

**You're 5 minutes away from working backend!** ✨
