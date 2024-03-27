import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/auth_service.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Workout"),
        actions: const [],
      ),
      body: FutureBuilder(
        future: ExerciseAPI.getAllExercises(AuthService.token!),
        builder: loadingBuilder,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget loadingBuilder(BuildContext context,
      AsyncSnapshot<Response<List<ExerciseResponse>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Text("Loading..."),
      );
    } else {
      if (snapshot.hasError) {
        return Center(child: Text("Something went wrong ${snapshot.error}"));
      } else {
        if (snapshot.data!.status == ResponseStatus.success) {
          return loaded(snapshot.data!.data!);
        } else {
          var message = snapshot.data!.message;
          return Center(child: Text("Something went wrong: $message"));
        }
      }
    }
  }

  Widget loaded(List<ExerciseResponse> exercises) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.separated(
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              exercises[index].name,
              style: const TextStyle(
                color: Color.fromARGB(255, 219, 219, 178),
              ),
            ),
            tileColor: const Color.fromARGB(255, 29, 32, 33),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
      ),
    );
  }
}
