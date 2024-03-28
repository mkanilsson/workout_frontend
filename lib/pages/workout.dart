import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/api/set.dart';
import 'package:workout_frontend/api/workout.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/theme.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  static const spacing = 15.0;
  static const textFieldWidth = 40.0;

  var _loading = true;
  var _success = true;
  DetailedWorkout? _workout;
  String _message = "";
  var _notFound = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    setState(() {
      _loading = true;
    });

    var response = await WorkoutAPI.current(AuthService.token!);

    setState(() {
      _loading = false;
      if (response.message == "Not Found") {
        _notFound = true;
        return;
      }
      _notFound = false;
      _success = response.status == ResponseStatus.success;
      _message = response.message;
      if (_success) {
        _workout = response.data!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetToShow = loading();

    if (_loading == false && _success == false) {
      widgetToShow = failed();
    } else if (_loading == false) {
      if (_notFound) {
        widgetToShow = noWorkout();
      } else {
        widgetToShow = loaded();
      }
    }

    return Scaffold(
      body: widgetToShow,
      floatingActionButton: _success && !_notFound && !_loading
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/workout_add_exercise").then(
                  (value) {
                    if (value is ExerciseResponse) {
                      addExercise(value);
                    }
                  },
                );
              },
              tooltip: 'Add exercise to workout',
              child: const Icon(Icons.add),
            )
          : null,
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

  Widget noWorkout() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: const Text(
              "You're not currently not working out!",
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: startWorkout,
            child: const Text(
              "Start working out",
            ),
          )
        ],
      ),
    );
  }

  Widget loaded() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.separated(
        itemCount: _workout!.exercises.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == _workout!.exercises.length) {
            return Row(
              children: [
                const SizedBox(
                  height: 75,
                ),
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: finishWorkout,
                      child: const Text("Finish workout"),
                    ),
                  ),
                ),
              ],
            );
          }
          var sets = _workout!.exercises[index].sets
              .asMap()
              .map(
                (i, e) => MapEntry(
                  i,
                  setRow(index, i, e),
                ),
              )
              .values
              .toList();

          return Card.filled(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        _workout!.exercises[index].name,
                        style: Theme.of(context).listTileTheme.titleTextStyle,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.history),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text(
                              "Delete",
                            ),
                            onTap: () {
                              removeExercise(
                                index,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        addWarmup(index);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add warmup"),
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(
                          Theme.of(context).textTheme.labelMedium,
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        ),
                      ),
                    ),
                  ),
                  ...sets,
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        addSet(index);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add set"),
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(
                          Theme.of(context).textTheme.labelMedium,
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
      ),
    );
  }

  void startWorkout() async {
    setState(() {
      _loading = true;
    });

    var response = await WorkoutAPI.startWorkout(AuthService.token!);
    if (response.status == ResponseStatus.success) {
      refresh();
    } else {
      setState(() {
        _loading = false;
        _success = false;
        _message = response.message;
      });
    }
  }

  Widget setRow(int exerciseIndex, int setIndex, WorkoutSet set) {
    var exerciseType = _workout!.exercises[exerciseIndex].exerciseType;
    var _qualityController =
        TextEditingController(text: set.quality.beautifulToString());

    var quantityWidgets = exerciseType == ExerciseType.weightOverAmount
        ? reps(set, exerciseIndex, setIndex)
        : time(set, exerciseIndex, setIndex);

    return Row(
      children: [
        Icon(
          set.setType == SetType.warmup
              ? Icons.fireplace_sharp
              : Icons.fitness_center_sharp,
        ),
        const SizedBox(
          width: spacing,
        ),
        SizedBox(
          width: textFieldWidth,
          child: Focus(
            child: TextField(
              textAlign: TextAlign.right,
              controller: _qualityController,
            ),
            onFocusChange: (hasFocus) {
              if (hasFocus) return;
              try {
                var value = double.parse(_qualityController.text);
                if (value != set.quality) {
                  updateSet(exerciseIndex, setIndex, value, set.quantity);
                }
              } catch (e) {
                showErrorSnackbar("Must be a number");
                _qualityController.text = set.quality.toString();
              }
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          exerciseType.quantityUnit,
          style: Theme.of(context).listTileTheme.subtitleTextStyle,
        ),
        const SizedBox(
          width: spacing,
        ),
        // HERE,
        ...quantityWidgets,
        // HERE,
        const Spacer(),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text(
                "Delete",
              ),
              onTap: () {
                deleteSet(exerciseIndex, set);
              },
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> reps(WorkoutSet set, int exerciseIndex, int setIndex) {
    var _quantityController =
        TextEditingController(text: set.quantity.beautifulToString());

    return [
      SizedBox(
        width: textFieldWidth,
        child: Focus(
          child: TextField(
            textAlign: TextAlign.right,
            controller: _quantityController,
            keyboardType: TextInputType.number,
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus) return;
            try {
              var value = double.parse(_quantityController.text);
              if (value != set.quantity) {
                updateSet(exerciseIndex, setIndex, set.quality, value);
              }
            } catch (e) {
              showErrorSnackbar("Must be a number");
              _quantityController.text = set.quantity.beautifulToString();
            }
          },
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        "reps",
        style: Theme.of(context).listTileTheme.subtitleTextStyle,
      ),
    ];
  }

  List<Widget> time(WorkoutSet set, int exerciseIndex, int setIndex) {
    var _hourController = TextEditingController(text: set.hours.toString());
    var _minuteController = TextEditingController(text: set.minutes.toString());
    var _secondController =
        TextEditingController(text: set.seconds.beautifulToString());

    final onFocusChange = (hasFocus) {
      if (hasFocus) return;
      try {
        var hours = double.parse(_hourController.text);
        var minutes = double.parse(_minuteController.text);
        var seconds = double.parse(_secondController.text);

        var value = hours * 3600 + minutes * 60 + seconds;
        if (value != set.quantity) {
          updateSet(exerciseIndex, setIndex, set.quality, value);
        }
      } catch (e) {
        showErrorSnackbar("Must be a number");
        _hourController.text = set.hours.toString();
        _minuteController.text = set.minutes.toString();
        _secondController.text = set.seconds.beautifulToString();
      }
    };

    return [
      // Hour
      SizedBox(
        width: textFieldWidth,
        child: Focus(
          child: TextField(
            textAlign: TextAlign.right,
            controller: _hourController,
            keyboardType: TextInputType.number,
          ),
          onFocusChange: onFocusChange,
        ),
      ),
      Text(
        "h",
        style: Theme.of(context).listTileTheme.subtitleTextStyle,
      ),
      const SizedBox(width: 5),
      // Minute
      SizedBox(
        width: textFieldWidth,
        child: Focus(
          child: TextField(
            textAlign: TextAlign.right,
            controller: _minuteController,
            keyboardType: TextInputType.number,
          ),
          onFocusChange: onFocusChange,
        ),
      ),
      Text(
        "m",
        style: Theme.of(context).listTileTheme.subtitleTextStyle,
      ),
      const SizedBox(width: 5),
      // Second
      SizedBox(
        width: textFieldWidth,
        child: Focus(
          child: TextField(
            textAlign: TextAlign.right,
            controller: _secondController,
            keyboardType: TextInputType.number,
          ),
          onFocusChange: onFocusChange,
        ),
      ),
      Text(
        "s",
        style: Theme.of(context).listTileTheme.subtitleTextStyle,
      ),
    ];
  }

  void deleteSet(int exerciseIndex, WorkoutSet set) {
    SetAPI.delete(AuthService.token!, set.id).then((response) {
      if (response.status == ResponseStatus.success) {
        setState(() {
          _workout!.exercises[exerciseIndex].sets = _workout!
              .exercises[exerciseIndex].sets
              .where((element) => element.id != set.id)
              .toList();
        });
      } else {
        showErrorSnackbar("Failed to delete Set");
      }
    });
  }

  void updateSet(
    int exerciseIndex,
    int setIndex,
    double newQuality,
    double newQuantity,
  ) {
    var set = _workout!.exercises[exerciseIndex].sets[setIndex];

    SetAPI.update(
      AuthService.token!,
      set.id,
      newQuality,
      newQuantity,
      set.setType,
    ).then((response) {
      if (response.status == ResponseStatus.success) {
        setState(() {
          _workout!.exercises[exerciseIndex].sets[setIndex] = response.data!;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Set has been updated"),
            duration: Duration(milliseconds: 500),
          ),
        );
      } else {
        showErrorSnackbar("Failed to update Set");
      }
    });
  }

  void showErrorSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: COLOR_ERROR,
      ),
    );
  }

  void addSet(int exerciseIndex) {
    var exercise = _workout!.exercises[exerciseIndex];
    SetAPI.create(
      AuthService.token!,
      exercise.exerciseWorkoutId,
      SetType.normal,
    ).then((response) {
      if (response.status == ResponseStatus.success) {
        setState(() {
          _workout!.exercises[exerciseIndex].sets.add(response.data!);
        });
      } else {
        showErrorSnackbar("Failed to add Warmup");
      }
    });
  }

  void addWarmup(int exerciseIndex) {
    var exercise = _workout!.exercises[exerciseIndex];
    SetAPI.create(
      AuthService.token!,
      exercise.exerciseWorkoutId,
      SetType.warmup,
    ).then((response) {
      if (response.status == ResponseStatus.success) {
        var index = exercise.sets
            .where((element) => element.setType == SetType.warmup)
            .length;

        setState(() {
          _workout!.exercises[exerciseIndex].sets.insert(index, response.data!);
        });
      } else {
        showErrorSnackbar("Failed to add Warmup");
      }
    });
  }

  void finishWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Finish workout"),
        content: const Text("Are you sure you want to finish your workout?"),
        actions: [
          TextButton(
            onPressed: () {
              WorkoutAPI.finish(AuthService.token!).then((response) {
                Navigator.of(context).pop();
                if (response.status == ResponseStatus.success) {
                  refresh();
                } else {
                  showErrorSnackbar("Failed to finish workout");
                }
              });
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  void addExercise(ExerciseResponse exercise) {
    WorkoutAPI.addExercise(AuthService.token!, exercise).then((response) {
      if (response.status == ResponseStatus.success) {
        refresh();
      } else {
        showErrorSnackbar(
            "Failed to add '${exercise.name}' to current workout");
      }
    });
  }

  void removeExercise(int exerciseIndex) {
    var exercise = _workout!.exercises[exerciseIndex];

    WorkoutAPI.removeExercise(
      AuthService.token!,
      exercise.exerciseWorkoutId,
    ).then((response) {
      if (response.status == ResponseStatus.success) {
        setState(() {
          _workout!.exercises.removeAt(exerciseIndex);
        });
      } else {
        showErrorSnackbar(
            "Failed to remove '${exercise.name}' from current workout");
      }
    });
  }
}
