import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/login_screen.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Logic for Navigation
    if (!authProvider.isLoading) {
      // Use Future.microtask to avoid "setState() or markNeedsBuild() called during build"
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) =>
                    authProvider.isAuthenticated
                        ? const MainNavigation()
                        : const LoginScreen(),
          ),
        );
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Using a subtle gradient makes it look more modern than a flat color
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBackgroundColor, Color(0xFFF0F2F5)],
          ),
        ),
        child: Stack(
          children: [
            // Center Logo and App Name
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      ksplashlogoAssetsPath,
                      height: 120, // Specific height for better control
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "WDUWLC", // Updated App Name
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Loading Indicator
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child:
                    authProvider.isLoading
                        ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              kPrimaryColor,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
