import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Required for iOS (from Google Cloud Console -> Credentials -> Create Credentials -> OAuth client ID -> iOS)
  // For Android, this is usually handled by google-services.json, but you can put the Android Client ID here if needed.
  static String get googleClientId => dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

  // Required for Web & Backend verification (from Google Cloud Console -> Credentials -> Create Credentials -> OAuth client ID -> Web application)
  // This is CRITICAL for Supabase to verify the ID token.
  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';
}
