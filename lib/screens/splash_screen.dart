import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Small splash delay for smooth startup
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = _authService.currentUser;

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.badge,
                  size: 55,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Business Card Scanner",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "AI Powered Contact Extraction",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 50),

              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
