
import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/db/UserDatabaseHelper.dart';
import 'package:app_02/Flutter_Task_Manager_v1/View/TaskListScreen.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/User.dart';
import 'RegisterScreen.dart';

// Màn hình Login là StatefulWidget vì nó cần theo dõi trạng thái nhập liệu
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// State chứa logic và giao diện chính
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Khóa để quản lý Form
  final _usernameController = TextEditingController(); // Lấy giá trị Username
  final _passwordController = TextEditingController(); // Lấy giá trị Password

  // Hàm xử lý đăng nhập
  Future<void> _login() async {
    // Kiểm tra các trường đã nhập đúng chưa
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // Truy vấn CSDL để tìm người dùng phù hợp
      final user = await UserDatabaseHelper.instance
          .getUserByUsernameAndPassword(username, password);

      // Nếu tìm được người dùng, chuyển sang TaskListScreen
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen(user: user)),
        );
      } else {
        // Nếu sai tài khoản/mật khẩu, hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sai tên đăng nhập hoặc mật khẩu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Nhập', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Gắn Form với khóa để kiểm tra hợp lệ
          child: Column(
            children: [
              // Ô nhập tên đăng nhập
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),

              // Ô nhập mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Ẩn ký tự để bảo mật
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Nút đăng nhập, gọi hàm _login khi nhấn
              ElevatedButton(
                onPressed: _login,
                child: Text('Đăng nhập'),
              ),

              // Chuyển sang màn hình đăng ký nếu chưa có tài khoản
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: Text('Chưa có tài khoản? Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
