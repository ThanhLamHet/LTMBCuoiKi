import 'dart:convert';

class User {
  final String id; // Định danh duy nhất của người dùng
  final String username; // Tên đăng nhập
  final String password; // Mật khẩu
  final String email; // Email người dùng
  final String? avatar; // URL avatar (nullable)
  final DateTime createdAt; // Thời gian tạo tài khoản
  final DateTime lastActive; // Thời gian hoạt động gần nhất
  final bool isAdmin; // New field to determine if the user is admin
  // Constructor
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    this.avatar,
    required this.createdAt,
    required this.lastActive,
    required this.isAdmin,
  });

  // Phương thức chuyển đổi User thành Map (để lưu vào database hoặc truyền qua mạng)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isAdmin': isAdmin ? 1 : 0, // Save as 1 for admin, 0 for non-admin
    };
  }

  // Phương thức tạo User từ Map (đọc từ database hoặc từ JSON)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      avatar: map['avatar'],
      createdAt: DateTime.parse(map['createdAt']),
      lastActive: DateTime.parse(map['lastActive']),
      isAdmin: map['isAdmin'] == 1,
    );
  }

  // Phương thức chuyển đổi User thành JSON (để gửi qua mạng)
  String toJson() => json.encode(toMap());

  // Phương thức tạo User từ JSON
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
