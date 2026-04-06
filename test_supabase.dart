import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  await dotenv.load(fileName: '.env');
  
  final supabase = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
  );

  print('Attempting to fetch users...');
  
  try {
    // Try to fetch users directly without RLS (Wait, we can't bypass RLS with anon key)
    // But let's see if we get an error or empty list
    final response = await supabase
        .from('users')
        .select('*, hospitals(*)')
        .eq('is_approved', false)
        .neq('role', 'patient');
        
    print('Response: $response');
  } catch (e) {
    print('Error from Supabase: $e');
  }
  
  exit(0);
}
