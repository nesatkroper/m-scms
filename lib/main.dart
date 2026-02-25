import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/screens/splash_screen.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';

// flutter build apk --split-per-abi

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkAuthenticationStatus(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M SCMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const Splash(),
    );
  }
}
