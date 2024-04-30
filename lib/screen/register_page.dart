import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:youstoryapp02/data/model/user.dart';
import 'package:youstoryapp02/provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final formKey = GlobalKey<FormState>();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name.';
    }
    return null;
  }

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Scrollable(
              axisDirection: AxisDirection.down,
              physics: const BouncingScrollPhysics(),
              controller: PrimaryScrollController.of(context),
              viewportBuilder: (context, offset) {
                return Viewport(
                  axisDirection: AxisDirection.down,
                  offset: offset,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 200,
                            ),
                            TextFormField(
                              controller: nameController,
                              validator: validateName,
                              decoration: InputDecoration(
                                labelText: 'Name',
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
                              validator: validatePassword,
                              obscureText: !isPasswordVisible,
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
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        final scaffoldMessenger =
                                            ScaffoldMessenger.of(context);
                                        final User user = User(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );

                                        final authRead =
                                            context.read<AuthProvider>();
                                        final result =
                                            await authRead.register(user);

                                        if (result) {
                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Registration successful. Please log in."),
                                            ),
                                          );

                                          if (!context.mounted) return;
                                          context.go('/login');
                                        } else {
                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Registration failed. Please try again."),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF004418),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
