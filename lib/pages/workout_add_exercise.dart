import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/api/target.dart';
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
  var _filterController = TextEditingController();

  List<ExerciseResponse> _exercises = [];

  List<TargetResponse> _targets = [];
  List<String> _selectedTargetIds = [];

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

    var exerciseResponse =
        await ExerciseAPI.getAllExercises(AuthService.token!);
    var targetResponse = await TargetAPI.getAllTargets();

    setState(() {
      if (exerciseResponse.status == ResponseStatus.failure) {
        _success = false;
        _message = exerciseResponse.message;
      } else if (targetResponse.status == ResponseStatus.failure) {
        _success = false;
        _message = targetResponse.message;
      } else {
        _success = true;
      }

      _loading = false;

      if (_success) {
        _exercises = exerciseResponse.data!;
        _targets = targetResponse.data!;
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
              controller: _filterController,
              decoration: const InputDecoration(
                hintText: "Search",
              ),
              onChanged: (_) {
                filter();
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 15.0,
              ),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: chips(),
              ),
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

  void filter() {
    var sanitizedQuery = sanitizeText(_filterController.text);

    List<ExerciseResponse> newFilteredList = [];

    for (var exercise in _exercises) {
      if (sanitizeText(exercise.name).contains(sanitizedQuery) ||
          sanitizedQuery == "") {
        if (_selectedTargetIds.isEmpty) {
          newFilteredList.add(exercise);
          continue;
        }

        for (var targetId in _selectedTargetIds) {
          if (exercise.targets.map((e) => e.id).contains(targetId)) {
            newFilteredList.add(exercise);
            break;
          }
        }
      }
    }

    setState(() {
      _filteredExercises = newFilteredList;
    });
  }

  String sanitizeText(String text) {
    return text.replaceAll(" ", "").toLowerCase().trim();
  }

  List<Widget> chips() {
    var chips = _targets
        .map(
          (e) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(e.name),
              selected: _selectedTargetIds.contains(e.id),
              onSelected: (selected) {
                setState(
                  () {
                    if (selected) {
                      _selectedTargetIds.add(e.id);
                    } else {
                      _selectedTargetIds = _selectedTargetIds
                          .where((element) => element != e.id)
                          .toList();
                    }
                  },
                );

                filter();
              },
            ),
          ),
        )
        .toList();

    chips.insert(
      0,
      Container(
        margin: const EdgeInsets.only(right: 4.0),
        child: FilterChip(
          label: const Text("All"),
          selected: _selectedTargetIds.isEmpty,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedTargetIds = [];
              });
            }

            filter();
          },
        ),
      ),
    );

    return chips;
  }
}
