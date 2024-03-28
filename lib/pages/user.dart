import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/theme.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final date = AuthService.user!.createdAt.toLocal();
    var userSince = "${date.day}/${date.month}/${date.year}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Account"),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AuthService.user!.email,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 35),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "User since",
                  style: TextStyle(
                    fontSize: 16,
                    height: 0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  userSince,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 35),
              TextButton(
                onPressed: () {
                  AuthService.logout().then((success) {
                    if (success) {
                      Navigator.of(context).pushReplacementNamed("/login");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to log out"),
                          backgroundColor: COLOR_ERROR,
                        ),
                      );
                    }
                  });
                },
                child: const Text(
                  "Log out",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
