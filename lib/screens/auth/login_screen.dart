import 'package:m_scms/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../main_navigation.dart';
import 'package:m_scms/constants/constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final result = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      if (result) {
        final userData = authProvider.userData;
        final List<dynamic> roles = userData?['roles'] ?? [];

        bool isStudent = roles.any((role) {
          if (role is String) return role.toLowerCase() == 'student';
          if (role is Map)
            return role['name']?.toString().toLowerCase() == 'student';
          return false;
        });

        if (!isStudent &&
            userData?['enrollments'] != null &&
            (userData?['enrollments'] as List).isNotEmpty) {
          isStudent = true;
        }

        if (!isStudent) {
          await authProvider.logout();
          _showErrorDialog(
            'Access Denied',
            'This app is used for Students only',
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        _showErrorDialog(
          'Login Failed',
          'Please check your credentials and try again.',
        );
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 16, color: kDarkGreyColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoadingFromProvider = authProvider.isLoading;

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        title: const Text(
          'User Login',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildLogoHeader(),
              const SizedBox(height: 40),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Username (Email)').copyWith(
                  prefixIcon: const Icon(
                    Icons.account_circle,
                    color: kGreyColor,
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Username is required" : null,
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: _inputDecoration('Password').copyWith(
                  prefixIcon: const Icon(Icons.lock, color: kGreyColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: kGreyColor,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Password is required" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoadingFromProvider ? null : _attemptLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: kGreyColor.withOpacity(0.4),
                  ),
                  child:
                      isLoadingFromProvider
                          ? const CircularProgressIndicator(
                            color: kPrimaryColor,
                          )
                          : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset('assets/wlc_logo.png', width: 80, height: 80),
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: kDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to continue to your account.",
          style: TextStyle(color: kGreyColor, fontSize: 16),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: kGreyColor.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2),
    ),
  );
}
