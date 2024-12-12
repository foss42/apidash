class BasicAuth {
  final String username;
  final String password;

  BasicAuth({required this.username, required this.password});

  factory BasicAuth.fromJson(Map<String, dynamic> json) {
    return BasicAuth(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}
