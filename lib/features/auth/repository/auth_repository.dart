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
      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
    } catch (e) {
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
      'name': firstName != null && lastName != null ? '$firstName $lastName' : firstName,
      'role': role,
      'phone' : null, // Optional if you have phone in registration
      'updated_at': DateTime.now().toIso8601String(),
    };
    // Remove null values to avoid overwriting with null if only partial update
    updates.removeWhere((key, value) => value == null);

    await _supabase.from('users').update(updates).eq('id', uid);
  }

  // Get User Role and Approval Status
  Future<Map<String, dynamic>?> getUserMetadata(String uid) async {
    try {
      final response = await _supabase
          .from('users')
          .select('role, is_approved')
          .eq('id', uid)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }

  // Update User Approval Status using RPC
  Future<void> updateUserApproval(String uid, bool approved) async {
    // We use a Security Definer RPC function to completely bypass RLS
    await _supabase.rpc('admin_update_approval', params: {
      'target_user_id': uid,
      'new_status': approved,
    });
  }

  // Get Pending Users
  Future<List<Map<String, dynamic>>> getPendingUsers() async {
    final response = await _supabase
        .from('users')
        .select('*, hospitals(*)')
        .eq('is_approved', false)
        .neq('role', 'patient');
    return List<Map<String, dynamic>>.from(response);
  }
}
