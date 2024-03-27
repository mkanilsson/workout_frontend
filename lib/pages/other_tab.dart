import 'package:flutter/material.dart';
import 'package:workout_frontend/auth_service.dart';

class OtherTabPage extends StatefulWidget {
  const OtherTabPage({super.key});

  @override
  State<OtherTabPage> createState() => _OtherTabPageState();
}

class _OtherTabPageState extends State<OtherTabPage> {
  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () => {
                AuthService.logout().then((success) {
                  if (success) {
                    Navigator.of(context).pushReplacementNamed("/login");
                  }
                })
              },
              child: const Text(
                "Log out",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
