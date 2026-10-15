class RegisterResponse{
  final String message;

  RegisterResponse({required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json){
    return RegisterResponse(message: json['message']);
  }
}

class LoginResponse{
  final String token;
  final DateTime expiration;

  LoginResponse({
    required this.token,
    required this.expiration
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      expiration: DateTime.parse(json['expiration']),
      token: json['token'],
    );
  }
}