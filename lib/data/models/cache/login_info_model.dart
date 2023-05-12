import 'dart:convert';

import 'package:dicoding_flutter_story_app/domain/entities/login_info.dart';

class LoginInfoModel {
  final String name;
  final String token;

  const LoginInfoModel({
    required this.name,
    required this.token,
  });

  LoginInfo toEntity() => LoginInfo(name: name, token: token);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'token': token,
    };
  }

  factory LoginInfoModel.fromMap(Map<String, dynamic> map) {
    return LoginInfoModel(
      name: map['name'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginInfoModel.fromJson(String source) =>
      LoginInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
