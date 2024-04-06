import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/routes.dart' as routes;
import 'package:workout_frontend/theme.dart';

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
        Navigator.of(context).pushReplacement(routes.home());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Check your email and password"),
            backgroundColor: COLOR_ERROR,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Workout"),
      ),
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
                keyboardType: TextInputType.emailAddress,
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
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(routes.register());
                },
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(
                    Theme.of(context).textTheme.labelMedium,
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                ),
                child: const Text(
                  "Don't have an account?\nRegister here",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
