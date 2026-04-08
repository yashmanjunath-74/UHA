-- ============================================================
-- UHA: Patient Features (Appointments & Medical Records)
-- Run this in your Supabase SQL Editor to support the new features.
-- ============================================================

-- 1. UPDATE DOCTORS TABLE (Add missing fields for UI display)
ALTER TABLE public.doctors 
ADD COLUMN IF NOT EXISTS avatar_url TEXT,
ADD COLUMN IF NOT EXISTS consultation_fee NUMERIC DEFAULT 0.0;

-- 2. APPOINTMENTS TABLE
CREATE TABLE IF NOT EXISTS public.appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE,
  scheduled_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending', -- pending | confirmed | completed | cancelled
  fee NUMERIC NOT NULL DEFAULT 0.0,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);

-- 3. MEDICAL RECORDS TABLE (For the Health Journey / Timeline)
CREATE TABLE IF NOT EXISTS public.medical_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES public.doctors(id) ON DELETE SET NULL,
  doctor_name TEXT, -- Fallback for external records
  type TEXT NOT NULL, -- lab_report | prescription | vaccination | other
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT,
  record_date TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
  tags TEXT[], -- Array of strings for categories
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);

-- ============================================================
-- RLS POLICIES FOR PATIENT FEATURES
-- ============================================================

-- Enable RLS
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_records ENABLE ROW LEVEL SECURITY;

-- ── Appointments Policies ──────────────────────────────────────────────────
-- Drop old ones if re-running
DROP POLICY IF EXISTS "Patients can view their own appointments" ON public.appointments;
DROP POLICY IF EXISTS "Patients can book appointments" ON public.appointments;
DROP POLICY IF EXISTS "Patients can cancel their own appointments" ON public.appointments;
DROP POLICY IF EXISTS "Doctors can view their own appointments" ON public.appointments;

CREATE POLICY "Patients can view their own appointments" 
ON public.appointments FOR SELECT 
USING (auth.uid() = patient_id);

CREATE POLICY "Patients can book appointments" 
ON public.appointments FOR INSERT 
WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Patients can cancel their own appointments" 
ON public.appointments FOR UPDATE 
USING (auth.uid() = patient_id)
WITH CHECK (status = 'cancelled');

CREATE POLICY "Doctors can view their own appointments" 
ON public.appointments FOR SELECT 
USING (auth.uid() = doctor_id);

-- ── Medical Records Policies ───────────────────────────────────────────────
DROP POLICY IF EXISTS "Patients can view their own medical records" ON public.medical_records;
DROP POLICY IF EXISTS "Doctors can add records for their patients" ON public.medical_records;

CREATE POLICY "Patients can view their own medical records" 
ON public.medical_records FOR SELECT 
USING (auth.uid() = patient_id);

CREATE POLICY "Doctors can add records for their patients" 
ON public.medical_records FOR INSERT 
WITH CHECK (auth.uid() = doctor_id);

-- ── Public Doctor Access (Allow patients to find doctors) ───────────────────
DROP POLICY IF EXISTS "Allow authenticated users to view doctors" ON public.doctors;
CREATE POLICY "Allow authenticated users to view doctors" 
ON public.doctors FOR SELECT 
USING (auth.role() = 'authenticated');

-- ============================================================
-- STORAGE FOR MEDICAL RECORDS
-- ============================================================
-- Create bucket for medical files (run in SQL or check dash)
-- Bucket name: "medical_records" -> Public: false

-- Storage policies for patient records
DROP POLICY IF EXISTS "Authenticated users can upload medical files" ON storage.objects;
DROP POLICY IF EXISTS "Users can only read their own medical folder" ON storage.objects;

CREATE POLICY "Authenticated users can upload medical files" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'medical_records' AND auth.role() = 'authenticated');

CREATE POLICY "Users can only read their own medical folder" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'medical_records' AND (storage.foldername(name))[1] = auth.uid()::text);
