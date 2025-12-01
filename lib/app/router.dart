import 'package:go_router/go_router.dart';
import 'package:xamraev_logistic/app/permissions/get_permissions.dart';
import 'package:xamraev_logistic/pages/auth/login_page.dart';
import 'package:xamraev_logistic/pages/home_screen.dart';
import 'package:xamraev_logistic/pages/user_page/masla_get_page/masla_get_page.dart';
import 'package:xamraev_logistic/pages/user_page/other_get_page/other_get_page.dart';
import 'package:xamraev_logistic/pages/user_page/petrol_get_page/petrol_get_page.dart';
import 'package:xamraev_logistic/pages/user_page/remont_get_page/remont_get_page.dart';
import 'package:xamraev_logistic/pages/user_page/shina_get_page/shina_get_page.dart';
import 'package:xamraev_logistic/pages/user_page/user_page.dart';
import 'package:xamraev_logistic/services/db/cache.dart';

abstract class Routes {
  static const homeScreen = '/homeScreen';
  static const loginPage = '/loginPage';
  static const permissionPage = '/permissionPage';
  static const userPage = '/userPage';
  static const petrolGet = '/petrolGet';
  static const shinaGet = '/shinaGet';
  static const maslaGet = '/maslaGet';
  static const remontGet = '/remontGet';
  static const otherGet = '/otherGet';
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
    GoRoute(
      path: Routes.userPage,
      builder: (context, state) => const UserPage(),
    ),
    GoRoute(
      path: Routes.homeScreen,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.permissionPage,
      builder: (context, state) => const PermissionScreen(),
    ),
    GoRoute(
      path: Routes.petrolGet,
      builder: (context, state) => const PetrolGetPage(),
    ),
    GoRoute(
      path: Routes.shinaGet,
      builder: (context, state) {
        return const ShinaGetPage();
      },
    ),
    GoRoute(
      path: Routes.maslaGet,
      builder: (context, state) => const MaslaGetPage(),
    ),
    GoRoute(
      path: Routes.remontGet,
      builder: (context, state) => const RemontGetPage(),
    ),
    GoRoute(
      path: Routes.otherGet,
      builder: (context, state) => const OtherGetPage(),
    ),
  ],
);
