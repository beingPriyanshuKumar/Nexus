import '../api/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _api = ApiService();

  /// Login with email/password.
  Future<({bool success, String message, UserModel? user})> login(
      String email, String password) async {
    try {
      final res = await _api.login(email, password);
      if (res.data['success'] == true) {
        final userResult = await getUserInfo();
        return (
          success: true,
          message: 'Login successful',
          user: userResult.user,
        );
      }
      return (
        success: false,
        message: (res.data['message'] ?? 'Login failed').toString(),
        user: null,
      );
    } catch (e) {
      return (
        success: false,
        message: _extractErrorMessage(e, 'Login failed'),
        user: null,
      );
    }
  }

  /// Sign up new user
  Future<({bool success, String message, UserModel? user})> signUp(
      String name, String email, String password, String year) async {
    try {
      final res = await _api.signUp(name, email, password, year);
      if (res.data['success'] == true) {
        final userResult = await getUserInfo();
        return (
          success: true,
          message: 'Signup successful',
          user: userResult.user,
        );
      }
      return (
        success: false,
        message: (res.data['message'] ?? 'Signup failed').toString(),
        user: null,
      );
    } catch (e) {
      return (
        success: false,
        message: _extractErrorMessage(e, 'Signup failed'),
        user: null,
      );
    }
  }

  /// Google OAuth
  Future<({bool success, String message, UserModel? user})> googleAuth(
      String token) async {
    try {
      final res = await _api.googleAuth(token);
      if (res.data['success'] == true) {
        final userResult = await getUserInfo();
        return (
          success: true,
          message: (res.data['message'] ?? 'Google login successful').toString(),
          user: userResult.user,
        );
      }
      return (
        success: false,
        message: (res.data['message'] ?? 'Google auth failed').toString(),
        user: null,
      );
    } catch (e) {
      return (
        success: false,
        message: _extractErrorMessage(e, 'Google auth failed'),
        user: null,
      );
    }
  }

  /// Fetch current user info
  Future<({bool success, UserModel? user})> getUserInfo() async {
    try {
      final res = await _api.getUserInfo();
      if (res.data['success'] == true) {
        final user = UserModel.fromJson(res.data['data']);
        return (success: true, user: user);
      }
      return (success: false, user: null);
    } catch (e) {
      return (success: false, user: null);
    }
  }

  /// Update user profile info
  Future<({bool success, String message, UserModel? user})> updateUserInfo(
      Map<String, dynamic> data) async {
    try {
      final res = await _api.updateUserInfo(data);
      if (res.data['success'] == true) {
        final userResult = await getUserInfo();
        return (
          success: true,
          message: (res.data['message'] ?? 'Updated successfully').toString(),
          user: userResult.user,
        );
      }
      return (
        success: false,
        message: (res.data['message'] ?? 'Update failed').toString(),
        user: null,
      );
    } catch (e) {
      return (
        success: false,
        message: _extractErrorMessage(e, 'Update failed'),
        user: null,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {}
  }

  /// Send verification OTP
  Future<({bool success, String message})> sendVerifyOtp(String email) async {
    try {
      final res = await _api.sendVerifyOtp(email);
      if (res.data['success'] == true) {
        return (
          success: true,
          message: (res.data['message'] ?? 'OTP sent successfully').toString(),
        );
      }
      return (
        success: false,
        message: (res.data['message'] ?? 'Error sending OTP').toString(),
      );
    } catch (e) {
      return (
        success: false,
        message: _extractErrorMessage(e, 'Cannot send OTP'),
      );
    }
  }

  /// Verify account with OTP
  Future<({bool success, String message})> verifyAccount(String otp) async {
    try {
      final res = await _api.verifyAccount(otp);
      if (res.data['success'] == true) {
        return (
          success: true,
          message: (res.data['message'] ?? 'Account verified').toString(),
        );
      }
      return (
        success: false,
        message: (res.data['message'] ?? 'Verification failed').toString(),
      );
    } catch (e) {
      return (
        success: false,
        message: _extractErrorMessage(e, 'Verification failed'),
      );
    }
  }

  String _extractErrorMessage(dynamic error, String fallback) {
    if (error is Exception) {
      try {
        final dioError = error as dynamic;
        final msg = dioError.response?.data?['message'];
        if (msg != null) return msg.toString();
      } catch (_) {}
    }
    return fallback;
  }
}
