-- Create labs table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.labs (
    id UUID PRIMARY KEY
);

-- Safely add columns to labs if they were created previously without them
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS name TEXT DEFAULT 'Unknown Lab';
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS registration_number TEXT;
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS test_types TEXT[] DEFAULT '{}';
ALTER TABLE public.labs ADD COLUMN IF NOT EXISTS verification_status TEXT DEFAULT 'pending';

-- Create lab_orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.lab_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid()
);

-- Safely add columns to lab_orders
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS lab_id UUID REFERENCES public.labs(id) ON DELETE CASCADE;
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS patient_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS patient_name TEXT DEFAULT 'Guest';
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS patient_age INTEGER DEFAULT 0;
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS patient_gender TEXT DEFAULT 'Unknown';
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS test_name TEXT DEFAULT 'Unknown Test';
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'New';
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS result_url TEXT;
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS doctor_name TEXT;
ALTER TABLE public.lab_orders ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Set up Row Level Security (RLS) policies
ALTER TABLE public.labs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lab_orders ENABLE ROW LEVEL SECURITY;

-- Labs policies
CREATE POLICY "Public can view labs" ON public.labs
    FOR SELECT USING (true);

CREATE POLICY "Labs can update own profile" ON public.labs
    FOR ALL USING (auth.uid() = user_id);

-- Lab Orders policies
CREATE POLICY "Patients can view own lab orders" ON public.lab_orders
    FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Patients can insert lab orders" ON public.lab_orders
    FOR INSERT WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Labs can view their orders" ON public.lab_orders
    FOR SELECT USING (
        lab_orders.lab_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.labs 
            WHERE labs.id = lab_orders.lab_id AND labs.user_id = auth.uid()
        )
    );

CREATE POLICY "Labs can update their orders" ON public.lab_orders
    FOR UPDATE USING (
        lab_orders.lab_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.labs 
            WHERE labs.id = lab_orders.lab_id AND labs.user_id = auth.uid()
        )
    );
