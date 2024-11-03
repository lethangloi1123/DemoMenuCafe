import 'package:flutter/material.dart';
import 'package:shop_cafe/menucafe.dart';
import 'package:shop_cafe/services/auth_service.dart';
import 'package:shop_cafe/register.dart'; // Import màn hình đăng ký

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6CC),
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo/cappuccino.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 32),
                
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email/số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () async {
                    try {
                      final message = await authService.login(
                        emailController.text,
                        passwordController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuCafe()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: const Text('Đăng nhập'),
                ),
                
                const SizedBox(height: 16), // Khoảng cách trước liên kết đăng ký

                // TextButton cho Đăng ký
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: const Text("Chưa có tài khoản? Đăng ký", style: TextStyle(color: Colors.brown)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
