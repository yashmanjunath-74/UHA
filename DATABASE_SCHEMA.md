# Database Schema - Visual Reference

---

## 📊 Tables You'll Create

### TABLE 1: `public.users`

```
┌─────────────────────────────────────────────┐
│              users table                    │
├─────────────────────────────────────────────┤
│ Column Name         │ Type          │ Notes │
├─────────────┬───────┼───────────────┼───────┤
│ id          │ UUID  │ Foreign Key   │ Auth  │
│ email       │ TEXT  │ Unique        │ Auth  │
│ name        │ TEXT  │ Optional      │       │
│ phone       │ TEXT  │ Optional      │       │
│ role        │ TEXT  │ Default       │ patient
│ avatar_url  │ TEXT  │ Optional      │       │
│ created_at  │ TIME  │ Auto          │ Now() │
│ updated_at  │ TIME  │ Auto          │ Now() │
└─────────────┴───────┴───────────────┴───────┘

✅ Row Level Security: ENABLED
   - Users can only read/write their own row
   
✅ Indexes:
   - idx_users_email (fast lookups by email)
   - idx_users_role (find all patients, doctors, etc.)

✅ When data is added:
   - Automatically when user signs up
   - Via trigger (Query 3)
```

### TABLE 2: `public.patients`

```
┌──────────────────────────────────────────────────┐
│           patients table                         │
├──────────────────────────────────────────────────┤
│ Column Name           │ Type       │ Notes      │
├──────────────┬────────┼────────────┼────────────┤
│ id           │ UUID   │ Primary    │ Auto Gen   │
│ user_id      │ UUID   │ Foreign    │ → users.id │
│ date_of_birth│ DATE   │ Optional   │            │
│ gender       │ TEXT   │ Enum       │ M|F|Other  │
│ blood_group  │ TEXT   │ Enum       │ O+,O-,etc  │
│ allergies    │ TEXT[] │ Array      │ List       │
│ chronic_     │ TEXT[] │ Array      │ List       │
│  conditions  │        │            │            │
│ emergency_   │ TEXT   │ Optional   │            │
│  contact_    │        │            │            │
│  name        │        │            │            │
│ emergency_   │ TEXT   │ Optional   │            │
│  contact_    │        │            │            │
│  phone       │        │            │            │
│ created_at   │ TIME   │ Auto       │ Now()      │
│ updated_at   │ TIME   │ Auto       │ Now()      │
└──────────────┴────────┴────────────┴────────────┘

✅ Relationships:
   - One user → One patient
   - Linked by user_id

✅ Row Level Security: ENABLED
   - Users can only read/write their own patient record

✅ Indexes:
   - idx_patients_user_id (fast lookup by user_id)
   - idx_patients_created_at (fast sorting/filtering)

✅ When data is added:
   - After user completes patient registration form
   - Via patientRegistrationProvider.registerPatient()
```

---

## 🔗 Relationship Diagram

```
┌──────────────────┐
│  auth.users      │ (Supabase Auth)
│  (auto created)  │
│  - id            │
│  - email         │
│  - password hash │
└────────┬─────────┘
         │ Creates
         │ (via trigger)
         ↓
┌──────────────────┐
│  public.users    │ (User Profiles)
│  id ←→ auth.id   │
│  - email         │
│  - name          │
│  - phone         │
│  - role          │
│  - avatar_url    │
└────────┬─────────┘
         │ Has
         │ (1:1 relationship)
         ↓
┌──────────────────┐
│ public.patients  │ (Patient Data)
│ user_id          │
│ - date_of_birth  │
│ - gender         │
│ - blood_group    │
│ - allergies      │
│ - chronic_cond   │
│ - emergency_cont │
└──────────────────┘
```

---

## 📥 Data Flow

### User Signs Up (Email/Password)
```
User enters: email = "john@example.com", password = "secure123"
                          ↓
                    ┌─────────────────┐
                    │ Supabase Auth   │
                    │ Validates & hashes password
                    │ Creates new user
                    │ auth.users.id = "abc123xyz"
                    └────────┬────────┘
                             │
                             ↓
                    ┌────────────────────┐
                    │ Trigger Fires      │
                    │ (Query 3 result)   │
                    └────────┬───────────┘
                             │
                             ↓
                    ┌────────────────────┐
                    │ public.users       │
                    │ NEW ROW:           │
                    │ id: "abc123xyz"    │
                    │ email: "john@..."  │
                    │ role: "patient"    │
                    │ created_at: NOW()  │
                    └────────────────────┘
```

### Patient Completes Registration
```
User fills form:
- date_of_birth: "1990-05-15"
- gender: "Male"
- blood_group: "O+"
- allergies: ["Penicillin"]
- chronic_conditions: []
- emergency_contact_name: "Jane Doe"
- emergency_contact_phone: "+1-555-0123"
                          ↓
            patientRegistrationProvider
                 .registerPatient()
                          ↓
               PatientRepository.insert()
                          ↓
               Supabase Database
                          ↓
                    ┌────────────────────┐
                    │ public.patients    │
                    │ NEW ROW:           │
                    │ id: "xyz123abc"    │
                    │ user_id: "abc123"  │
                    │ date_of_birth: "..."
                    │ gender: "Male"     │
                    │ blood_group: "O+"  │
                    │ allergies: [...]   │
                    │ created_at: NOW()  │
                    └────────────────────┘
```

---

## ✅ What Gets Stored

### Example: User Signs Up

```
Email: john@example.com
Password: secure123

RESULT IN public.users TABLE:
┌──────────────────────────────────┐
│ id       │ abc123xyz              │
│ email    │ john@example.com       │
│ name     │ (null)                 │
│ phone    │ (null)                 │
│ role     │ patient                │
│ created_at│ 2026-04-06 10:30:00   │
└──────────────────────────────────┘

(Password is NEVER stored in users table - only in auth.users)
(Password is HASHED - you never see it)
```

### Example: Patient Completes Registration

```
After filling form with above data:

RESULT IN public.patients TABLE:
┌──────────────────────────────────────────┐
│ id                │ xyz789def             │
│ user_id           │ abc123xyz             │
│ date_of_birth     │ 1990-05-15            │
│ gender            │ Male                  │
│ blood_group       │ O+                    │
│ allergies         │ ["Penicillin"]        │
│ chronic_conditions│ []                    │
│ emergency_        │ Jane Doe              │
│  contact_name     │                       │
│ emergency_        │ +1-555-0123           │
│  contact_phone    │                       │
│ created_at        │ 2026-04-06 10:35:00   │
│ updated_at        │ 2026-04-06 10:35:00   │
└──────────────────────────────────────────┘
```

---

## 🔒 Row Level Security Policies

### For `public.users` table:

```
POLICY 1: Users can read own data
├─ Operation: SELECT
├─ Condition: auth.uid() = id
└─ Effect: User can only see their own row

POLICY 2: Users can update own data
├─ Operation: UPDATE
├─ Condition: auth.uid() = id
└─ Effect: User can only update their own row

POLICY 3: Users can insert own profile
├─ Operation: INSERT
├─ Condition: auth.uid() = id
└─ Effect: Users can insert only their own row
          (Trigger handles this automatically)
```

### For `public.patients` table:

```
POLICY 1: Patients can read own data
├─ Operation: SELECT
├─ Condition: auth.uid() = user_id
└─ Effect: Patient can only see their own record

POLICY 2: Patients can insert own data
├─ Operation: INSERT
├─ Condition: auth.uid() = user_id
└─ Effect: Can only insert own patient record

POLICY 3: Patients can update own data
├─ Operation: UPDATE
├─ Condition: auth.uid() = user_id
└─ Effect: Can only update their own record
```

---

## 📐 Constraints

### users table:
- ✅ `id` must exist in `auth.users.id`
- ✅ `email` must be unique
- ✅ `role` must be: 'patient', 'doctor', 'hospital', 'lab', or 'pharmacy'

### patients table:
- ✅ `id` must be unique
- ✅ `user_id` must exist in `users.id` (and be unique)
- ✅ `gender` must be: 'Male', 'Female', or 'Other'
- ✅ `blood_group` must be: 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', or 'AB-'
- ✅ `allergies` must be array of strings (can be empty)
- ✅ `chronic_conditions` must be array of strings (can be empty)

---

## 🔍 Query Examples

Once tables are created, you can query like:

```sql
-- Get current logged-in user's profile
SELECT * FROM users WHERE id = auth.uid();

-- Get current patient's medical info
SELECT * FROM patients WHERE user_id = auth.uid();

-- Update email (users can only do their own)
UPDATE users SET name = 'John Doe' WHERE id = auth.uid();

-- Update blood group (patients can only do their own)
UPDATE patients SET blood_group = 'A+' WHERE user_id = auth.uid();
```

---

## 📊 Schema Size

```
users table:
- Small: ~200 bytes per user
- With 1000 users: ~200 KB

patients table:
- Medium: ~500 bytes per patient
- With 1000 patients: ~500 KB

Total: < 1 MB for 1000 users + patients
       = Very efficient!
```

---

**Next:** Read [SQL_QUERIES_COPY_PASTE.md](SQL_QUERIES_COPY_PASTE.md) to see the exact SQL
