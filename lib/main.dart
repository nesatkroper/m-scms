import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduwlc/screens/splash.dart';
import 'package:eduwlc/constants/constant.dart';
import 'package:eduwlc/providers/auth_provider.dart';

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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}

