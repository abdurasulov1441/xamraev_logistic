import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xamraev_logistic/app/router.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';
import 'package:xamraev_logistic/services/request_helper.dart';
import 'package:xamraev_logistic/services/db/cache.dart';
import 'package:xamraev_logistic/services/utils/toats/error.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  Future<void> login() async {
    final username = loginController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login va parol kiriting")));
      return;
    }

    try {
      final server = await requestHelper.post('/api/v1/auth/login', {
        "username": username,
        "password": password,
      }, log: true);

      if (server['success'] == false) {
        final msg = (server['message'] is List && server['message'].isNotEmpty)
            ? server['message'][0]
            : "Xatolik yuz berdi";

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      final data = server['data'];
      final user = data['user'];

      // Tokenlar
      await cache.setString('user_token', data['accessToken']);
      await cache.setString('refresh_token', data['refreshToken']);

      // User ma'lumotlari (alohida)
      await cache.setInt('user_id', user['id']);
      await cache.setString('username', user['username']);
      await cache.setString('fullname', user['fullname'] ?? '');
      await cache.setInt('roleId', user['roleId']);
      await cache.setString('phone', user['phone'] ?? '');
      await cache.setString('photo', user['photo'] ?? '');

      // Role ma'lumotlari
      final role = user['role'];
      if (role != null) {
        await cache.setInt('role_id', role['id']);
        await cache.setString('role_uz', role['uz'] ?? '');
        await cache.setString('role_ru', role['ru'] ?? '');
        await cache.setString('role_en', role['en'] ?? '');
      }

      if (!mounted) return;

      if (user['roleId'] == 1) {
        context.go(Routes.homeScreen);

        return;
      }

      if (user['roleId'] == 2) {
        showErrorToast(context, "Siz adminsiz", "Admin panel web saytda");
        return;
      }

      context.go(Routes.homeScreen);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Server xatosi: $e")));
    }
  }

  // -----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.png', height: 150),
              const Text(
                'Xush kelibsiz',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tizimga kirish uchun login va parolni kiriting',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              _inputField(
                label: 'Login',
                controller: loginController,
                icon: Icons.person,
              ),

              const SizedBox(height: 20),

              _inputField(
                label: 'Parol',
                controller: passwordController,
                icon: Icons.lock,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grade1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: login,
                  child: const Text(
                    'Kirish',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => isObscure = !isObscure);
                },
              )
            : null,
      ),
    );
  }
}
