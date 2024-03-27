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
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 72, 133, 136),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(50, 20, 50, 20),
                ),
              ),
              child: const Text(
                "Log out",
                style: TextStyle(
                    color: Colors.white, fontSize: 16), // TODO: TextStyle
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
