import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global provider exposing the Supabase client instance.
/// Use [supabaseClientProvider] in repositories instead of calling
/// Supabase.instance.client directly, so it can be easily mocked in tests.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
