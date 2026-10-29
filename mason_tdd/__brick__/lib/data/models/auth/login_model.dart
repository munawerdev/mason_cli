class LoginModel {
  LoginModel({required this.email, required this.password});
  String email;
  String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'password': password,
  };
}
