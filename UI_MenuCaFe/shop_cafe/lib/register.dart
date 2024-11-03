import 'package:flutter/material.dart';
import 'package:shop_cafe/services/auth_service.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6CC),
      appBar: AppBar(title: const Text("Register")),
      body: Center( // Đặt ở giữa màn hình
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24.0), // Khoảng cách bên trong container
            decoration: BoxDecoration(
              color: Colors.white, // Màu nền của container
              borderRadius: BorderRadius.circular(16.0), // Bo tròn các góc
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Đổ bóng nhẹ
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Chỉ chiếm diện tích tối thiểu cần thiết
              children: [
                Image.asset(
                  'assets/logo/coffee-bean.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 32),
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Họ tên")),
                const SizedBox(height: 16),
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email")),
                const SizedBox(height: 16),
                TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Số điện thoại")),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Mật khẩu"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Vui lòng điền đầy đủ thông tin")));
                      return;
                    }

                    try {
                      final message = await authService.register(
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        passwordController.text,
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                      Navigator.pop(
                          context); // Quay lại trang Login sau khi đăng ký thành công
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: const Text("Đăng ký"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
