import 'dart:convert';

/// Object model for common response from API.
class CommonResponse {
  final bool error;
  final String message;

  const CommonResponse({
    required this.error,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
    };
  }

  factory CommonResponse.fromMap(Map<String, dynamic> map) {
    return CommonResponse(
      error: map['error'] as bool,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommonResponse.fromJson(String source) =>
      CommonResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
