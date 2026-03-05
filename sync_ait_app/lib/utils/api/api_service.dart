import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiService {
  static const String _defaultBaseUrl = 'http://10.0.2.2:8000';

  late final Dio dio;
  late final CookieJar cookieJar;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    cookieJar = CookieJar();
    dio = Dio(
      BaseOptions(
        baseUrl: _defaultBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    );
  }

  /// Update the base URL at runtime if needed
  void setBaseUrl(String url) {
    dio.options.baseUrl = url;
  }

  // ─── Auth Endpoints ───────────────────────────────────────────

  Future<Response> login(String email, String password) async {
    return dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> signUp(
      String name, String email, String password, String year) async {
    return dio.post('/api/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'year': year,
    });
  }

  Future<Response> googleAuth(String token) async {
    return dio.post('/api/auth/google-auth', data: {
      'token': token,
    });
  }

  Future<Response> getUserInfo() async {
    return dio.get('/api/auth/get-user-info');
  }

  Future<Response> updateUserInfo(Map<String, dynamic> data) async {
    return dio.post('/api/auth/update-user-info', data: data);
  }

  Future<Response> logout() async {
    return dio.post('/api/auth/logout');
  }

  Future<Response> sendVerifyOtp(String email) async {
    return dio.post('/api/auth/verify-otp', data: {'email': email});
  }

  Future<Response> verifyAccount(String otp) async {
    return dio.post('/api/auth/verify-account', data: {'otp': otp});
  }

  // ─── Clubs Endpoints ──────────────────────────────────────────

  Future<Response> getClubs() async {
    return dio.get('/api/clubs.json');
  }
}
