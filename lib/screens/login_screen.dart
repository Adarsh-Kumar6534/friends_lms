import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard.dart'; // Import the new DashboardScreen

class LoginScreen extends StatefulWidget {
  final String userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final email = await _storage.read(key: 'email');
      final password = await _storage.read(key: 'password');
      if (email != null && password != null) {
        setState(() {
          _emailController.text = email;
          _passwordController.text = password;
        });
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    try {
      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'password', value: password);
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  Future<void> _signIn(String email, String password) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate API call
    setState(() => _isLoading = false);

    // Save credentials after successful sign-in
    await _saveCredentials(email, password);

    // Navigate to DashboardScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(userType: widget.userType),
      ),
    );
  }

  Future<void> _loginWithSavedDetails() async {
    try {
      final email = await _storage.read(key: 'email');
      final password = await _storage.read(key: 'password');
      if (email != null && password != null) {
        await _signIn(email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No saved credentials found!")),
        );
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error accessing saved credentials")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0f172a),
                  Color(0xFF0f1e30),
                  Color(0xFF082f2b),
                  Color(0xFF04201e),
                  Color(0xFF0f172a),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 60, color: Colors.white),
                    const SizedBox(height: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.greenAccent, Colors.cyanAccent],
                      ).createShader(bounds),
                      child: const Text(
                        'Friends LMS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Login as ${widget.userType}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "yourname@fndslms.com",
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF10b981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.2)),
                          foregroundColor: Colors.white,
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                              Colors.white.withOpacity(0.1)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10b981).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Sign In",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () => _signIn(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _loginWithSavedDetails,
                      child: const Text(
                        "Already registered? Login with saved details",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
