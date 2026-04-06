import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';

class AdminState {
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> pendingUsers;

  AdminState({
    this.isLoading = false, 
    this.error, 
    this.pendingUsers = const []
  });

  AdminState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? pendingUsers,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      pendingUsers: pendingUsers ?? this.pendingUsers,
    );
  }
}

class AdminController extends Notifier<AdminState> {
  late final AuthRepository _repository;

  @override
  AdminState build() {
    _repository = ref.watch(authRepositoryProvider);
    Future.microtask(() => fetchPendingUsers());
    return AdminState(isLoading: true);
  }

  Future<void> fetchPendingUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _repository.getPendingUsers();
      state = state.copyWith(isLoading: false, pendingUsers: users);
    } catch (e) {
      print('Error fetching pending users: $e'); // Added logging
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> approveUser(String uid) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateUserApproval(uid, true);
      // Refresh list
      final updatedList = state.pendingUsers.where((u) => u['id'] != uid).toList();
      state = state.copyWith(isLoading: false, pendingUsers: updatedList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> rejectUser(String uid) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // In a real app, maybe delete or mark as rejected
      await _repository.updateUserApproval(uid, false); 
      final updatedList = state.pendingUsers.where((u) => u['id'] != uid).toList();
      state = state.copyWith(isLoading: false, pendingUsers: updatedList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminProvider = NotifierProvider<AdminController, AdminState>(
  AdminController.new,
);
