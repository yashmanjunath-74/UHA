import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/role_selection/role_selection_gateway.dart';
import 'features/role_selection/role_selection_grid.dart';
import 'features/auth/login_screen.dart';
import 'features/registration/basic_info_screen.dart';
import 'features/registration/verification_screen.dart';

void main() {
  runApp(const UnifiedHealthAllianceApp());
}

class UnifiedHealthAllianceApp extends StatelessWidget {
  const UnifiedHealthAllianceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unified Health Alliance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/role_selection': (context) => const RoleSelectionGatewayScreen(),
        '/role_selection_grid': (context) => const RoleSelectionGridScreen(),
        '/login': (context) => const UniversalLoginScreen(),
        '/registration/basic': (context) => const BasicInfoScreen(),
        '/registration/verification': (context) => const VerificationScreen(),
      },
    );
  }
}
