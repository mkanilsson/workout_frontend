import 'package:flutter/material.dart';
import 'package:workout_frontend/pages/exercises.dart';
import 'package:workout_frontend/pages/workout.dart';
import 'package:workout_frontend/routes.dart' as routes;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("Workout"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(routes.user());
              },
              icon: const Icon(Icons.account_circle),
            ),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: "Workout"),
            Tab(text: "Exercises"),
          ],
        ),
        body: const TabBarView(
          children: [WorkoutPage(), ExercisesPage()],
        ),
      ),
    );
  }
}
