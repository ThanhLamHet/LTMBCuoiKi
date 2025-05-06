import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/db/UserDatabaseHelper.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/User.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
        avatar: '',
        isAdmin: false,
      );

      final success = await UserDatabaseHelper.instance.insertUser(user);
      if (success != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
        Navigator.pop(context); // Trở về màn hình đăng nhập
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng ký thất bại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Ký', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên người dùng';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _register, child: Text('Đăng ký')),
            ],
          ),
        ),
      ),
    );
  }
}