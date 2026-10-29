class UserInfoStoreModel {
  UserInfoStoreModel({required this.accessToken, required this.refreshToken});

  factory UserInfoStoreModel.fromJson(Map<String, dynamic> json) =>
      UserInfoStoreModel(
        accessToken: json['accessToken'] as String ?? '',
        refreshToken: json['refreshToken'] as String ?? '',
      );
  factory UserInfoStoreModel.empty() =>
      UserInfoStoreModel(accessToken: '', refreshToken: '');

  final String accessToken;
  final String refreshToken;

  UserInfoStoreModel copyWith({String? accessToken, String? refreshToken}) =>
      UserInfoStoreModel(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}
