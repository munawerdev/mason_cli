
abstract class AppUrl {
  AppUrl._();

  static String? get _base => 'http://192.168.18.68:3001';
  // static String? get _base => 'http://192.168.100.31:3001';
  // static String? get _base => dotenv.env['BASE_URL'];
  static String? get socketBaseUrl => _base;
  static String get _baseUrl => '$_base/api/v1';

  // Authentication endpoints
  static String get refreshToken => '$_baseUrl/refreshToken';
  static String get login => '$_baseUrl/login';
  static String get signUp => '$_baseUrl/signUp';
  static String get forgotPassword => '$_baseUrl/forgotPassword';

  // {{folder_name_camelCase}}
  static String get {{folder_name_camelCase}} => '$_baseUrl/{{folder_name_camelCase}}';

}
  // static String endpoint(String userId) => '$_baseUrl/$path';
