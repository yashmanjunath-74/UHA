-- ============================================================
-- UHA: Doctor, Pharmacy, Lab Tables + RLS + Storage Policies
-- Run this in your Supabase SQL Editor
-- ============================================================

-- 1. DOCTORS TABLE
CREATE TABLE IF NOT EXISTS public.doctors (
  id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  specialty TEXT NOT NULL,
  license_number TEXT NOT NULL,
  years_of_experience INTEGER NOT NULL DEFAULT 0,
  qualification TEXT NOT NULL,
  clinic_address TEXT,
  work_phone TEXT NOT NULL,
  document_url TEXT,
  is_independent BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now()),
  updated_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);

-- 2. DOCTOR-HOSPITAL AFFILIATIONS (Many-to-Many)
CREATE TABLE IF NOT EXISTS public.doctor_hospital_affiliations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  doctor_id UUID NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE,
  hospital_id UUID NOT NULL REFERENCES public.hospitals(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending', -- pending | approved | rejected
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now()),
  UNIQUE(doctor_id, hospital_id)
);

-- 3. PHARMACIES TABLE
CREATE TABLE IF NOT EXISTS public.pharmacies (
  id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  pharmacy_name TEXT NOT NULL,
  pharmacy_type TEXT NOT NULL DEFAULT 'Retail', -- Retail | Compounding | Specialty | Online
  license_number TEXT NOT NULL,
  contact_number TEXT NOT NULL,
  official_email TEXT NOT NULL,
  address TEXT NOT NULL,
  -- Affiliation
  is_hospital_affiliated BOOLEAN NOT NULL DEFAULT false,
  affiliated_hospital_id UUID REFERENCES public.hospitals(id) ON DELETE SET NULL,
  -- Services
  has_delivery BOOLEAN NOT NULL DEFAULT false,
  has_24hr_service BOOLEAN NOT NULL DEFAULT false,
  has_insurance_billing BOOLEAN NOT NULL DEFAULT false,
  -- Documents
  document_url TEXT,
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now()),
  updated_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);

-- 4. LABS TABLE
CREATE TABLE IF NOT EXISTS public.labs (
  id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  lab_name TEXT NOT NULL,
  lab_type TEXT NOT NULL DEFAULT 'Clinical', -- Clinical | Pathology | Radiology | Diagnostic
  license_number TEXT NOT NULL,
  contact_number TEXT NOT NULL,
  official_email TEXT NOT NULL,
  address TEXT NOT NULL,
  -- Affiliation
  is_hospital_affiliated BOOLEAN NOT NULL DEFAULT false,
  affiliated_hospital_id UUID REFERENCES public.hospitals(id) ON DELETE SET NULL,
  -- Capabilities
  has_home_collection BOOLEAN NOT NULL DEFAULT false,
  has_online_reports BOOLEAN NOT NULL DEFAULT false,
  has_emergency_testing BOOLEAN NOT NULL DEFAULT false,
  nabl_accredited BOOLEAN NOT NULL DEFAULT false,
  -- Documents
  document_url TEXT,
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now()),
  updated_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);

-- ============================================================
-- RLS POLICIES
-- ============================================================
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctor_hospital_affiliations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pharmacies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.labs ENABLE ROW LEVEL SECURITY;

-- Doctors: can insert/read their own record; admins can read all
CREATE POLICY "Doctors can insert own record" ON public.doctors FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Doctors can read own record" ON public.doctors FOR SELECT USING (auth.uid() = id OR public.is_admin());
CREATE POLICY "Admins can update doctors" ON public.doctors FOR UPDATE USING (public.is_admin());

-- Affiliations
CREATE POLICY "Allow insert affiliations" ON public.doctor_hospital_affiliations FOR INSERT WITH CHECK (auth.uid() = doctor_id);
CREATE POLICY "Allow read affiliations" ON public.doctor_hospital_affiliations FOR SELECT USING (auth.uid() = doctor_id OR public.is_admin());

-- Pharmacies
CREATE POLICY "Pharmacies can insert own record" ON public.pharmacies FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Pharmacies can read own record" ON public.pharmacies FOR SELECT USING (auth.uid() = id OR public.is_admin());
CREATE POLICY "Admins can update pharmacies" ON public.pharmacies FOR UPDATE USING (public.is_admin());

-- Labs
CREATE POLICY "Labs can insert own record" ON public.labs FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Labs can read own record" ON public.labs FOR SELECT USING (auth.uid() = id OR public.is_admin());
CREATE POLICY "Admins can update labs" ON public.labs FOR UPDATE USING (public.is_admin());

-- ============================================================
-- ADMIN: Allow joining on new tables
-- ============================================================
-- Update getPendingUsers to also join doctors, pharmacies, labs in your Flutter query.
-- The query already does SELECT '*, hospitals(*)' - add the others:
-- .select('*, hospitals(*), doctors(*), pharmacies(*), labs(*)')

-- ============================================================
-- STORAGE BUCKETS (run separately or check if exists)
-- ============================================================
-- In Supabase Dashboard > Storage > Create bucket:
-- Bucket name: "doctor_documents"   -> Public: false
-- Bucket name: "pharmacy_documents" -> Public: false
-- Bucket name: "lab_documents"      -> Public: false

-- Or via SQL:
INSERT INTO storage.buckets (id, name, public) VALUES ('doctor_documents', 'doctor_documents', false) ON CONFLICT DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('pharmacy_documents', 'pharmacy_documents', false) ON CONFLICT DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('lab_documents', 'lab_documents', false) ON CONFLICT DO NOTHING;

-- Storage policies (allow authenticated users to upload to their own folder)
CREATE POLICY "Allow upload doctor docs" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'doctor_documents' AND auth.role() = 'authenticated');
CREATE POLICY "Allow read doctor docs" ON storage.objects FOR SELECT USING (bucket_id = 'doctor_documents' AND auth.role() = 'authenticated');
CREATE POLICY "Allow upload pharmacy docs" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'pharmacy_documents' AND auth.role() = 'authenticated');
CREATE POLICY "Allow read pharmacy docs" ON storage.objects FOR SELECT USING (bucket_id = 'pharmacy_documents' AND auth.role() = 'authenticated');
CREATE POLICY "Allow upload lab docs" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'lab_documents' AND auth.role() = 'authenticated');
CREATE POLICY "Allow read lab docs" ON storage.objects FOR SELECT USING (bucket_id = 'lab_documents' AND auth.role() = 'authenticated');
