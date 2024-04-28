import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:youstoryapp02/data/model/user.dart';
import 'package:youstoryapp02/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    height: 200.0,
                    width: 200.0,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: emailController,
                    validator: validateEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  context.watch<AuthProvider>().isLoadingLogin
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.lightBlue,
                        ))
                      : _buildLoginAction(),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Implement register navigation here
                      context.goNamed('register');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildLoginAction() {
    return ElevatedButton(
      onPressed: () async {
        // Implement login logic here
        if (formKey.currentState!.validate()) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final User user = User(
            email: emailController.text,
            password: passwordController.text,
            name: '',
          );
          final authRead = context.read<AuthProvider>();

          try {
            final result = await authRead.login(user.email, user.password);
            if (result) {
              final contextMounted = context;
              if (!contextMounted.mounted) return;
              context.goNamed('home');
            } else {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text("Your email or password is invalid"),
                ),
              );
            }
          } catch (error) {
            // Handle login errors more gracefully
            if (kDebugMode) {
              print(error.toString());
            } // Log the error for debugging
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Login failed. Please try again later.'),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              'Log In',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
