import 'package:flutter/material.dart';
import 'package:xamraev_logistic/pages/auth/login_page.dart';
import 'package:xamraev_logistic/pages/user_page/user_page.dart';
import 'package:xamraev_logistic/services/db/cache.dart';
import 'package:xamraev_logistic/services/request_helper.dart';
import 'package:xamraev_logistic/services/utils/errors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>?> _futureUserStatus;

  Future<Map<String, dynamic>?> checkUserStatus() async {
    try {
      final response = await requestHelper.getWithAuth(
        '/api/v1/auth/me',
        log: true,
      );

      if (response['success'] == true) {
        final user = response['data'];

        // Cache’ga user info saqlaymiz
        await cache.setInt('roleId', user['roleId']);
        await cache.setInt('user_id', user['id']);
        await cache.setString('username', user['username']);
        await cache.setString('fullname', user['fullname'] ?? '');
        await cache.setString('phone', user['phone'] ?? '');
        await cache.setString('photo', user['photo'] ?? '');

        // Role JSON
        final role = user['role'];
        if (role != null) {
          await cache.setInt('role_id', role['id']);
          await cache.setString('role_uz', role['uz'] ?? '');
          await cache.setString('role_ru', role['ru'] ?? '');
          await cache.setString('role_en', role['en'] ?? '');
        }

        return user;
      }

      return null;
    } on UnauthenticatedError {
      cache.clear();
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _futureUserStatus = checkUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _futureUserStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset('assets/images/logo.png', width: 200),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginPage();
        }

        final user = snapshot.data!;
        final int roleId = user['roleId'];

        switch (roleId) {
          case 1:
            return const UserPage();
          // return const AdminPage();

          case 2:
            cache.clear();
            return const LoginPage();

          default:
            cache.clear();
            return const LoginPage();
        }
      },
    );
  }
}
