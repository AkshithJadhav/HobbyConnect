import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/authentication/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authService = AuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: _emailController,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _passwordController,
              placeholder: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              child: const Text('Login'),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  // Navigate to the home screen after successful login
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  print('Login Error: $e');
                  // Show an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: const Text('Sign in with Google'),
              onPressed: () async {
                final userCredential = await _authService.signInWithGoogle();
                if (userCredential != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
