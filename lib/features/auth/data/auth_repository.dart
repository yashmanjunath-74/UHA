import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Google Sign-In Instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Initialize Google Sign-In (Call this logic early, e.g. in main.dart or constructor)
  Future<void> initializeGoogleSignIn({
    String? clientId,
    String? serverClientId,
  }) async {
    await _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );
    // Listen to silent sign-in events if needed, matching user's snippet
    _googleSignIn.authenticationEvents.listen((event) {
      // Handle auth events if necessary
    });
  }

  // Sign in with Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // 1. Trigger Google Sign-In flow
      final googleUser = await _googleSignIn.authenticate();

      // 2. Obtain auth details
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthException('No ID Token found.');
      }

      // 3. Sign in to Supabase with the tokens
      // Note: accessToken is no longer directly available in google_sign_in 7.x
      // and is optional for Supabase ID Token auth.
      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
    } catch (e) {
      // google_sign_in 7.x throws on cancellation
      throw AuthException('Google Sign-In failed or cancelled: $e');
    }
  }

  // Update Profile
  Future<void> updateProfile({
    required String uid,
    String? firstName,
    String? lastName,
    String? role,
    String? nationalId,
    String? gender,
    DateTime? dob,
  }) async {
    final updates = {
      'id': uid,
      'first_name': firstName,
      'last_name': lastName,
      if (firstName != null && lastName != null)
        'full_name': '$firstName $lastName',
      'role': role,
      'national_id_number': nationalId,
      'gender': gender,
      'date_of_birth': dob?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    // Remove null values to avoid overwriting with null if only partial update
    updates.removeWhere((key, value) => value == null);

    await _supabase.from('profiles').upsert(updates);
  }
}
