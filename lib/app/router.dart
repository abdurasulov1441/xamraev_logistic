
import 'package:go_router/go_router.dart';
import 'package:xamraev_logistic/pages/auth/login_page.dart';
import 'package:xamraev_logistic/services/db/cache.dart';

abstract class Routes {
  static const welcome = '/welcome';
  static const homeScreen = '/homeScreen';
  static const loginPage = '/loginPage';
}

String _initialLocation() {
  // return Routes.permissionPage;

  final userToken = cache.getString("user_token");
  String? refreshToken = cache.getString('refresh_token');
  print('Refresh Token: $refreshToken');

  if (userToken != null) {
    return Routes.homeScreen;
  } else {
 
    return Routes.loginPage;
  }
}

Object? _initialExtra() {
  return {};
}

final router = GoRouter(
  initialLocation: _initialLocation(),
  initialExtra: _initialExtra(),
  routes: [
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
   
  ],
);
