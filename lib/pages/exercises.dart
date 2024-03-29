import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/pages/exercise_history.dart';
import 'package:workout_frontend/theme.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  var _loading = true;
  var _success = true;
  List<ExerciseResponse> _exercises = [];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/add_exercise").then((result) {
            if (result is ExerciseResponse) {
              setState(() {
                _exercises.add(result);
              });
            }
          });
        },
        tooltip: 'Add new Exercise',
        child: const Icon(Icons.add),
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
      child: ListView.separated(
        itemCount: _exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              _exercises[index].name,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) => ExerciseHistoryPage(
                    exerciseId: _exercises[index].id,
                    exerciseName: _exercises[index].name,
                  ),
                ),
              );
            },
            subtitle: Text(_exercises[index].exerciseType.description),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    "Delete",
                  ),
                  onTap: () {
                    ExerciseAPI.delete(
                      AuthService.token!,
                      _exercises[index].id,
                    ).then((response) {
                      if (response.status == ResponseStatus.success) {
                        setState(() {
                          _exercises = _exercises
                              .where(
                                (element) => element.id != response.data!.id,
                              )
                              .toList();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Failed to remove '${_exercises[index].name}'",
                            ),
                            backgroundColor: COLOR_ERROR,
                          ),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
      ),
    );
  }
}
