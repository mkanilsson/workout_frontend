import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/auth.dart';
import 'package:workout_frontend/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    if (passwordController.text.length <= 5 ||
        emailController.text.length <= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Both email and password must be longer than 5 characters"),
          backgroundColor: COLOR_ERROR,
        ),
      );

      return;
    }

    AuthAPI.register(
      emailController.text,
      passwordController.text,
    ).then((response) {
      if (response.status == ResponseStatus.success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your account has been created, you can now log in"),
            backgroundColor: COLOR_SUCCESS,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
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
                  "Register",
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
                onPressed: register,
                child: const Text(
                  "Register",
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
