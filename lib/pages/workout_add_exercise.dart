import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/routes.dart' as routes;

class WorkoutAddExercisePage extends StatefulWidget {
  const WorkoutAddExercisePage({super.key});

  @override
  State<WorkoutAddExercisePage> createState() => _WorkoutAddExercisePageState();
}

class _WorkoutAddExercisePageState extends State<WorkoutAddExercisePage> {
  var _loading = true;
  var _success = true;
  List<ExerciseResponse> _exercises = [];
  List<ExerciseResponse> _filteredExercises = [];
  String _message = "";

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    setState(() {
      _loading = true;
    });

    var response = await ExerciseAPI.getAllExercises(AuthService.token!);

    setState(() {
      _success = response.status == ResponseStatus.success;
      _loading = false;
      _message = response.message;
      if (_success) {
        _exercises = response.data!;
        _filteredExercises = _exercises;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetToShow = loading();

    if (_loading == false && _success == false) {
      widgetToShow = failed();
    } else if (_loading == false) {
      widgetToShow = loaded();
    }

    return Scaffold(
      body: widgetToShow,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Select Exercise"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(routes.user());
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget failed() {
    return Center(child: Text("Something went wrong: $_message"));
  }

  Widget loaded() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search",
              ),
              onChanged: filter,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredExercises.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    _filteredExercises[index].name,
                  ),
                  subtitle:
                      Text(_filteredExercises[index].exerciseType.description),
                  onTap: () {
                    Navigator.of(context).pop(_filteredExercises[index]);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 5);
              },
            ),
          ),
        ],
      ),
    );
  }

  void filter(String query) {
    var sanitizedQuery = sanitizeText(query);

    List<ExerciseResponse> newFilteredList = [];

    for (var exercise in _exercises) {
      if (sanitizeText(exercise.name).contains(sanitizedQuery) || query == "") {
        newFilteredList.add(exercise);
      }
    }

    setState(() {
      _filteredExercises = newFilteredList;
    });
  }

  String sanitizeText(String text) {
    return text.replaceAll(" ", "").toLowerCase().trim();
  }
}
