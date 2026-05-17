-- hospital_schema.sql
-- Run this in your Supabase SQL Editor

-- Hospitals Profile Table
CREATE TABLE IF NOT EXISTS public.hospitals (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    institution_type TEXT,
    contact_number TEXT,
    official_email TEXT,
    bed_count INTEGER DEFAULT 0,
    department_count INTEGER DEFAULT 0,
    has_emergency BOOLEAN DEFAULT false,
    has_ambulance BOOLEAN DEFAULT false,
    has_icu BOOLEAN DEFAULT false,
    document_url TEXT,
    verification_status TEXT DEFAULT 'pending', -- pending, verified, rejected
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hospital Staff Table
CREATE TABLE IF NOT EXISTS public.hospital_staff (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hospital_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    department TEXT NOT NULL,
    status TEXT DEFAULT 'Active', -- Active, On Leave, Off Duty
    phone TEXT,
    email TEXT,
    avatar_url TEXT,
    is_doctor BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hospital Admissions (Patients in the hospital)
CREATE TABLE IF NOT EXISTS public.hospital_admissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hospital_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    patient_id UUID REFERENCES auth.users(id) ON DELETE SET NULL, -- Optional linking to UHA patient account
    patient_name TEXT NOT NULL,
    patient_display_id TEXT, -- e.g. UHA-20241
    age INTEGER DEFAULT 0,
    gender TEXT DEFAULT 'Unknown',
    ward TEXT DEFAULT 'General',
    status TEXT DEFAULT 'Admitted', -- Admitted, OPD, Emergency, Discharged
    doctor_name TEXT,
    bed_no TEXT,
    admitted_since TEXT DEFAULT 'Today',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE public.hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hospital_staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hospital_admissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Hospitals can manage their own profile" ON public.hospitals
    FOR ALL USING (auth.uid() = id);

CREATE POLICY "Public can view verified hospitals" ON public.hospitals
    FOR SELECT USING (verification_status = 'verified');

CREATE POLICY "Hospitals can manage their staff" ON public.hospital_staff
    FOR ALL USING (auth.uid() = hospital_id);

CREATE POLICY "Hospitals can manage their admissions" ON public.hospital_admissions
    FOR ALL USING (auth.uid() = hospital_id);
