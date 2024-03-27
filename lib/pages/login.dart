import 'package:flutter/material.dart';
import 'package:workout_frontend/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    AuthService.login(emailController.text, passwordController.text)
        .then((success) {
      if (success) {
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        showLoginFailedDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                    height: 0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              TextField(
                controller: emailController,
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 16,
                    height: 0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 35),
              TextButton(
                onPressed: login,
                child: const Text(
                  "Login",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text("Login failed"),
        );
      },
    );
  }
}
