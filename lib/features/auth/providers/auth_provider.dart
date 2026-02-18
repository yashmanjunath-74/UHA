import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_repository.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});

// Auth State
class AuthState {
  final bool isLoading;
  final String? error;
  final Session? session;

  AuthState({this.isLoading = false, this.error, this.session});

  AuthState copyWith({bool? isLoading, String? error, Session? session}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Reset error if not provided
      session: session ?? this.session,
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
    return AuthState(session: _repository.currentSession);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, session: response.session);
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
      state = state.copyWith(isLoading: false, session: response.session);
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
    state = state.copyWith(isLoading: false, session: null);
  }
}
