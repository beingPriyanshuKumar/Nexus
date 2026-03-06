import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/models/user_model.dart';
import '../../../utils/repositories/auth_repository.dart';

// ─── Auth State ─────────────────────────────────────────────────

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── Auth Notifier ──────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repo;
  static const _storage = FlutterSecureStorage();
  static const _userKey = 'cached_user';

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  /// Save user to secure storage
  Future<void> _saveUserLocally(UserModel user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  /// Clear saved user
  Future<void> _clearLocalUser() async {
    await _storage.delete(key: _userKey);
  }

  /// Read saved user from secure storage
  Future<UserModel?> _readLocalUser() async {
    final data = await _storage.read(key: _userKey);
    if (data != null) {
      try {
        return UserModel.fromJson(jsonDecode(data));
      } catch (_) {
        await _clearLocalUser();
      }
    }
    return null;
  }

  /// Check if user is already logged in (local storage first, then API)
  Future<void> checkAuth() async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Try restoring from local storage first
    final localUser = await _readLocalUser();
    if (localUser != null) {
      state = state.copyWith(user: localUser, isLoading: false);
      return;
    }

    // Fall back to API session check
    final result = await _repo.getUserInfo();
    if (result.success && result.user != null) {
      await _saveUserLocally(result.user!);
      state = state.copyWith(user: result.user, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false, clearUser: true);
    }
  }

  /// Email/password login
  Future<({bool success, String message})> login(
      String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    // ── Mock credentials for demo ──
    const mockAccounts = {
      'fe@sync.com': ('fe123', 'FE', 'Priyanshu Kumar'),
      'se@sync.com': ('se123', 'SE', 'SE User'),
      'te@sync.com': ('te123', 'TE', 'TE User'),
    };

    final mock = mockAccounts[email.toLowerCase()];
    if (mock != null) {
      if (password == mock.$1) {
        final user = UserModel(
          id: 'mock_${mock.$2.toLowerCase()}',
          name: mock.$3,
          email: email,
          year: mock.$2,
          isAccountVerified: true,
        );
        await _saveUserLocally(user);
        state = state.copyWith(user: user, isLoading: false);
        return (success: true, message: 'Welcome, ${mock.$3}!');
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Invalid password');
        return (success: false, message: 'Invalid password');
      }
    }
    // ── End mock ──

    final result = await _repo.login(email, password);
    if (result.success && result.user != null) {
      await _saveUserLocally(result.user!);
      state = state.copyWith(user: result.user, isLoading: false);
      return (success: true, message: result.message);
    } else {
      state =
          state.copyWith(isLoading: false, errorMessage: result.message);
      return (success: false, message: result.message);
    }
  }

  /// Sign up
  Future<({bool success, String message})> signUp(
      String name, String email, String password, String year) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repo.signUp(name, email, password, year);
    if (result.success && result.user != null) {
      await _saveUserLocally(result.user!);
      state = state.copyWith(user: result.user, isLoading: false);
      return (success: true, message: result.message);
    } else {
      state =
          state.copyWith(isLoading: false, errorMessage: result.message);
      return (success: false, message: result.message);
    }
  }

  /// Google sign-in
  Future<({bool success, String message})> googleAuth(String token) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repo.googleAuth(token);
    if (result.success && result.user != null) {
      await _saveUserLocally(result.user!);
      state = state.copyWith(user: result.user, isLoading: false);
      return (success: true, message: result.message);
    } else {
      state =
          state.copyWith(isLoading: false, errorMessage: result.message);
      return (success: false, message: result.message);
    }
  }

  /// Update profile
  Future<({bool success, String message})> updateUserInfo(
      Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repo.updateUserInfo(data);
    if (result.success && result.user != null) {
      await _saveUserLocally(result.user!);
      state = state.copyWith(user: result.user, isLoading: false);
      return (success: true, message: result.message);
    } else {
      state =
          state.copyWith(isLoading: false, errorMessage: result.message);
      return (success: false, message: result.message);
    }
  }

  /// Send OTP
  Future<({bool success, String message})> sendVerifyOtp(String email) async {
    return _repo.sendVerifyOtp(email);
  }

  /// Verify account
  Future<({bool success, String message})> verifyAccount(String otp) async {
    final result = await _repo.verifyAccount(otp);
    if (result.success) {
      await checkAuth(); // refresh user
    }
    return result;
  }

  /// Logout
  Future<void> logout() async {
    await _clearLocalUser();
    await _repo.logout();
    state = const AuthState();
  }
}

// ─── Providers ──────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
