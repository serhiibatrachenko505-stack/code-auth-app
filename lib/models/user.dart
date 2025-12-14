class UserModel {
  final int? id;
  final String nick;
  final String email;
  final String fullName;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.nick,
    required this.email,
    required this.fullName,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nick': nick,
    'email': email,
    'full_name': fullName,
    'password_hash': passwordHash,
    'salt': salt,
    'created_at': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as int?,
    nick: map['nick'] as String,
    email: map['email'] as String,
    fullName: map['full_name'] as String? ?? '',
    passwordHash: map['password_hash'] as String,
    salt: map['salt'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
