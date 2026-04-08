import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/auth_repository.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});

// Auth State
class AuthState {
  final bool isLoading;
  final String? error;
  final Session? session;
  final String? userRole;
  final bool isApproved;

  AuthState({
    this.isLoading = false,
    this.error,
    this.session,
    this.userRole,
    this.isApproved = true, // Default true for now until we identify role
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    Session? session,
    String? userRole,
    bool? isApproved,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      session: session ?? this.session,
      userRole: userRole ?? this.userRole,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}

// Auth Controller Provider
final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    final session = _repository.currentSession;
    if (session != null) {
      _fetchInitialRole(session.user.id);
    }
    return AuthState(session: session);
  }

  Future<void> _fetchInitialRole(String userId) async {
    try {
      final metadata = await _repository.getUserMetadata(userId);
      if (metadata != null) {
        state = state.copyWith(
          userRole: metadata['role'] ?? 'patient',
          isApproved: metadata['is_approved'] ?? true,
        );
      } else {
        // Fallback or move to registration if metadata is missing
        state = state.copyWith(userRole: 'patient', isApproved: true);
      }
    } catch (e) {
      state = state.copyWith(userRole: 'patient', isApproved: true, error: e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.signInWithEmailPassword(
        email: email,
        password: password,
      );

      String? role;
      bool isApproved = true;
      if (response.user != null) {
        final metadata = await _repository.getUserMetadata(response.user!.id);
        role = metadata?['role'];
        isApproved = metadata?['is_approved'] ?? true;
      }

      state = state.copyWith(
        isLoading: false,
        session: response.session,
        userRole: role,
        isApproved: isApproved,
      );
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.signInWithGoogle();

      String? role;
      bool isApproved = true;
      if (response.user != null) {
        final metadata = await _repository.getUserMetadata(response.user!.id);
        role = metadata?['role'];
        isApproved = metadata?['is_approved'] ?? true;
      }

      state = state.copyWith(
        isLoading: false,
        session: response.session,
        userRole: role,
        isApproved: isApproved,
      );
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google Sign-In failed: $e',
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _repository.signOut();
    state = state.copyWith(isLoading: false, session: null, userRole: null);
  }
}

// Global provider to fetch any user's metadata by ID (e.g. for showing names in lists)
final userDataProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.getUserMetadata(userId);
});
