# Step-by-Step Supabase Setup Checklist (Email/Password Only)

---

## 📋 Task Checklist

### STEP 1: Copy Database Queries (5 minutes)
- [ ] Open [SQL_QUERIES_COPY_PASTE.md](SQL_QUERIES_COPY_PASTE.md)
- [ ] Go to Supabase Dashboard → **SQL Editor**
- [ ] Copy **QUERY 1** (Users Table)
- [ ] Paste in SQL Editor
- [ ] Click **Run**
- [ ] Wait for success ✅

### STEP 2: Create Patients Table (2 minutes)
- [ ] Go back to Supabase Dashboard → **SQL Editor**
- [ ] Copy **QUERY 2** (Patients Table)
- [ ] Paste in SQL Editor
- [ ] Click **Run**
- [ ] Wait for success ✅

### STEP 3: Create Auto-Trigger (2 minutes)
- [ ] Go back to Supabase Dashboard → **SQL Editor**
- [ ] Copy **QUERY 3** (Trigger)
- [ ] Paste in SQL Editor
- [ ] Click **Run**
- [ ] Wait for success ✅

### STEP 4: Enable Email/Password Authentication (2 minutes)
- [ ] Go to Supabase Dashboard → **Authentication**
- [ ] Click **Email/Password** tab
- [ ] Make sure **Email Provider** shows **Enabled** ✅
- [ ] If disabled, click toggle to enable
- [ ] Click **Save**

### STEP 5: Get Your API Keys (2 minutes)
- [ ] Go to Supabase Dashboard → **Settings** → **API**
- [ ] Copy **Project URL** (format: `https://xxxxx.supabase.co`)
- [ ] Copy **anon public** key (long string starting with `eyJ...`)
- [ ] Save these safely

### STEP 6: Update .env File (2 minutes)
- [ ] Open your project's `.env` file
- [ ] Delete any Google OAuth lines (Google IOS, Google Server)
- [ ] Add these lines:
  ```
  SUPABASE_URL=https://your-project-id.supabase.co
  SUPABASE_ANON_KEY=your_key_here
  ```
- [ ] Paste the actual values from Step 5

### STEP 7: Update main.dart (2 minutes)
- [ ] Open `lib/main.dart`
- [ ] Remove any Google Sign-In initialization code
- [ ] Keep only Supabase initialization:
  ```dart
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  ```
- [ ] Save file

### STEP 8: Test Registration (5 minutes)
- [ ] Run your app: `flutter run`
- [ ] Create a test account with email/password
- [ ] Check Supabase Dashboard → **SQL Editor**
- [ ] Run: `SELECT * FROM public.users;`
- [ ] Verify your test user appears in the table ✅

### STEP 9: Integration (Optional - for later)
- [ ] Read [EMAIL_PASSWORD_SETUP.md](EMAIL_PASSWORD_SETUP.md) for full code examples
- [ ] Add login screen
- [ ] Add signup screen
- [ ] Add patient registration form integration

---

## ⏱️ Total Time: ~20 minutes

---

## 📊 What Gets Created

### Database Tables:
- **users** - Stores user profiles after they sign up
- **patients** - Stores patient medical information

### Automatic Features:
- ✅ Email/password authentication (Supabase handles)
- ✅ Auto user profile creation (trigger handles)
- ✅ Data security (RLS policies protect data)
- ✅ Email verification (Supabase sends emails)

---

## ✅ Success Indicators

After completing all steps, you should see:

1. ✅ No errors when running SQL queries
2. ✅ Email/Password provider shows "Enabled" in Authentication
3. ✅ Your app loads without errors
4. ✅ New database tables appear in Supabase → Tables section
5. ✅ New user appears in users table after signup

---

## 🔧 If Something Goes Wrong

### SQL Query Failed?
- Check spelling in the query
- Make sure you ran Query 1 before Query 2
- Try running queries one at a time

### App Won't Start?
- Check .env file is in project root
- Verify SUPABASE_URL and SUPABASE_ANON_KEY are correct
- Check spelling (they're case-sensitive)
- Restart the app

### User Not Created in Database?
- Check trigger was created successfully (Query 3)
- Verify users table exists in Supabase
- Check user signed up after trigger was created

### No Email Verification?
- Check which email provider is enabled in Supabase
- Make sure app has internet access
- Check spam folder for verification email

---

## 📚 Documentation Files

- **[SQL_QUERIES_COPY_PASTE.md](SQL_QUERIES_COPY_PASTE.md)** ← Start here to copy SQL
- **[EMAIL_PASSWORD_SETUP.md](EMAIL_PASSWORD_SETUP.md)** ← Read for full setup & code examples
- **[BACKEND_CONNECTION_SUMMARY.md](BACKEND_CONNECTION_SUMMARY.md)** ← Technical details
- **[PATIENT_REGISTRATION_GUIDE.md](PATIENT_REGISTRATION_GUIDE.md)** ← Integration examples

---

## 🎯 Quick Map

```
You Are Here            Next Step
       ↓                    ↓
This Checklist   →   SQL_QUERIES_COPY_PASTE.md
                 →   EMAIL_PASSWORD_SETUP.md
                 →   Done! Ready to code
```

---

## 💡 Pro Tips

1. **Keep it simple** - Just email/password for now
2. **Test early** - Create a test account right after setup
3. **Use .env** - Don't hardcode API keys
4. **Save progress** - Keep backups of your .env file
5. **Read errors** - Supabase errors are usually clear

---

**Ready? Start with Step 1 → [SQL_QUERIES_COPY_PASTE.md](SQL_QUERIES_COPY_PASTE.md)** ✅
