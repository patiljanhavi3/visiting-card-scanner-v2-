import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

import 'theme/app_theme.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const BusinessCardScannerApp());
}

class BusinessCardScannerApp extends StatelessWidget {
  const BusinessCardScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Business Card Scanner",

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const SplashScreen(),

      routes: {
        "/auth": (_) => const AuthWrapper(),

        "/login": (_) => const LoginScreen(),

        "/signup": (_) => const SignupScreen(),

        "/home": (_) => const HomeScreen(),

        "/scan": (_) => const ScanScreen(),
      },
    );
  }
}
