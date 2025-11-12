import 'package:flutter/material.dart';
import 'package:roadsafe_estimator/screens/admin_panel_screen.dart';
import 'package:roadsafe_estimator/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _onLoginClick() {
    // Simulate login
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardHome()),
      );
    }
  }

  void _onSignupClick() {
    // Simulate signup
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardHome()),
      );
    }
  }

  void _onGoogleAuthClick() {
    // Simulate Google OAuth
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardHome()),
    );
  }

  void _onForgotPasswordClick() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Reset'),
        content: const Text('Password reset link sent to your email!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onAdminLogin() {
    showDialog(
      context: context,
      builder: (context) {
        final adminPasswordController = TextEditingController();
        return AlertDialog(
          title: const Text('Admin Login'),
          content: TextField(
            controller: adminPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Admin Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (adminPasswordController.text == 'admin123') {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPanel()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid admin password')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.shield, size: 80, color: Color(0xFF1976D2)),
              const SizedBox(height: 20),
              const Text(
                'RoadSafe Estimator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isLogin = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLogin
                            ? const Color(0xFF1976D2)
                            : Colors.grey[300],
                        foregroundColor: _isLogin ? Colors.white : Colors.black,
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isLogin = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isLogin
                            ? const Color(0xFF1976D2)
                            : Colors.grey[300],
                        foregroundColor: !_isLogin
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: const Text('Signup'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 10),
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _onForgotPasswordClick,
                    child: const Text('Forgot Password?'),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLogin ? _onLoginClick : _onSignupClick,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _onGoogleAuthClick,
                icon: const Icon(Icons.g_mobiledata, size: 30),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _onAdminLogin,
                child: const Text(
                  'Admin Login',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
