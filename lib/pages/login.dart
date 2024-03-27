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
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
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
                    color: Colors.white,
                    fontSize: 24,
                  ), // TODO: TextStyle
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 0.5,
                  ), // TODO: TextStyle
                  textAlign: TextAlign.left,
                ),
              ),
              TextField(
                style: const TextStyle(color: Colors.white), // TODO: TextStyle
                controller: emailController,
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 0.5,
                  ), // TODO: TextStyle
                  textAlign: TextAlign.left,
                ),
              ),
              TextField(
                style: const TextStyle(color: Colors.white), // TODO: TextStyle
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 35),
              TextButton(
                onPressed: login,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 72, 133, 136),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16), // TODO: TextStyle
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
