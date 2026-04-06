import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controller/auth_controller.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  await GoogleSignIn.instance.initialize(
    clientId: SupabaseConfig.googleClientId,
    serverClientId: SupabaseConfig.googleServerClientId,
  );

  runApp(const ProviderScope(child: UnifiedHealthAllianceApp()));
}

class UnifiedHealthAllianceApp extends ConsumerStatefulWidget {
  const UnifiedHealthAllianceApp({super.key});

  @override
  ConsumerState<UnifiedHealthAllianceApp> createState() => _UnifiedHealthAllianceAppState();
}

class _UnifiedHealthAllianceAppState extends ConsumerState<UnifiedHealthAllianceApp> {
  late final RoutemasterDelegate routemaster;

  RouteMap _currentRouteMap = appRouter;
  late RoutemasterDelegate _routemaster;

  @override
  void initState() {
    super.initState();
    _initRoutemaster(appRouter);
  }

  void _initRoutemaster(RouteMap map) {
    _currentRouteMap = map;
    _routemaster = RoutemasterDelegate(
      routesBuilder: (context) => _currentRouteMap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final normalizedRole = authState.userRole?.trim().toLowerCase();

    RouteMap targetRouteMap;
    if (authState.session == null) {
      targetRouteMap = appRouter;
    } else if (normalizedRole == null) {
      targetRouteMap = RouteMap(
        routes: {'/': (_) => const MaterialPage(child: Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))))}
      );
    } else if (normalizedRole == 'admin') {
      targetRouteMap = adminRouter;
    } else if (!authState.isApproved && normalizedRole != 'patient') {
      targetRouteMap = unapprovedRouter;
    } else if (normalizedRole == 'hospital') {
      targetRouteMap = hospitalRouter;
    } else if (normalizedRole == 'doctor') {
      targetRouteMap = doctorRouter;
    } else if (normalizedRole == 'lab') {
      targetRouteMap = labRouter;
    } else if (normalizedRole == 'pharmacy') {
      targetRouteMap = pharmacyRouter;
    } else {
      targetRouteMap = appRouter;
    }

    // Only recreate RoutemasterDelegate if the underlying map type has fundamentally changed
    // (e.g. going from logged out to logged in) to avoid dropping navigation stack unnecessarily.
    if (_currentRouteMap != targetRouteMap) {
      _initRoutemaster(targetRouteMap);
    }

    return MaterialApp.router(
      title: 'Unified Health Alliance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerDelegate: _routemaster,
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
