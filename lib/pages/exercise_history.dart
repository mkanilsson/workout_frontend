import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/api/set.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/theme.dart';

class ExerciseHistoryPage extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;
  const ExerciseHistoryPage(
      {super.key, required this.exerciseId, required this.exerciseName});

  @override
  State<ExerciseHistoryPage> createState() => _ExerciseHistoryState();
}

class _ExerciseHistoryState extends State<ExerciseHistoryPage> {
  static const spacing = 15.0;
  static const textFieldWidth = 40.0;

  var _loading = true;
  var _success = true;
  List<ExerciseHistory>? _history;
  String _message = "";

  @override
  void initState() {
    super.initState();
    refresh();
    // NOTE: widget.exerciseId;
  }

  void refresh() async {
    setState(() {
      _loading = true;
    });

    var response = await ExerciseAPI.getHistory(
      AuthService.token!,
      widget.exerciseId,
    );

    setState(() {
      _loading = false;
      _success = response.status == ResponseStatus.success;
      _message = response.message;
      if (_success) {
        _history = response.data!;
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("History of ${widget.exerciseName}"),
      ),
      body: widgetToShow,
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Text(
              "Changes here do not persist!",
              style: TextStyle(color: COLOR_ERROR, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _history!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card.filled(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                _history![index]
                                    .workoutDate
                                    .toLocal()
                                    .beautifulToString(),
                                style: Theme.of(context)
                                    .listTileTheme
                                    .titleTextStyle,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        ...groups(index),
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
          ),
        ],
      ),
    );
  }

  List<Widget> group(int historyIndex, int groupIndex) {
    var sets = _history![historyIndex]
        .groups[groupIndex]
        .sets
        .asMap()
        .map(
          (i, e) => MapEntry(
            i,
            setRow(historyIndex, groupIndex, i),
          ),
        )
        .values
        .toList();

    return [
      // Align(
      //   alignment: Alignment.centerLeft,
      //   child: TextButton.icon(
      //     onPressed: () {
      //       // addWarmup(index);
      //     },
      //     icon: const Icon(Icons.add),
      //     label: const Text("Add warmup"),
      //     style: ButtonStyle(
      //       textStyle: WidgetStateProperty.all(
      //         Theme.of(context).textTheme.labelMedium,
      //       ),
      //       backgroundColor: WidgetStateProperty.all(
      //         Colors.transparent,
      //       ),
      //       padding: WidgetStateProperty.all(
      //         const EdgeInsets.fromLTRB(0, 0, 15, 0),
      //       ),
      //     ),
      //   ),
      // ),
      ...sets,
      const SizedBox(
        height: 5,
      ),
      // Align(
      //   alignment: Alignment.centerLeft,
      //   child: TextButton.icon(
      //     onPressed: () {
      //       // addSet(index);
      //     },
      //     icon: const Icon(Icons.add),
      //     label: const Text("Add set"),
      //     style: ButtonStyle(
      //       textStyle: WidgetStateProperty.all(
      //         Theme.of(context).textTheme.labelMedium,
      //       ),
      //       backgroundColor: WidgetStateProperty.all(
      //         Colors.transparent,
      //       ),
      //       padding: WidgetStateProperty.all(
      //         const EdgeInsets.fromLTRB(0, 0, 15, 0),
      //       ),
      //     ),
      //   ),
      // ),
    ];
  }

  List<Widget> groups(int historyIndex) {
    var groups = _history![historyIndex]
        .groups
        .asMap()
        .map((i, e) => MapEntry(i, group(historyIndex, i)))
        .values
        .toList()
        .map((e) => [...e, const Divider()]);

    List<Widget> widgets = [];

    for (var g in groups) {
      for (var w in g) {
        widgets.add(w);
      }
    }

    widgets.removeLast();

    return widgets;
  }

  Widget setRow(int historyIndex, int groupIndex, int setIndex) {
    var set = _history![historyIndex].groups[groupIndex].sets[setIndex];
    var exerciseType = _history![historyIndex].exerciseType;

    var _qualityController =
        TextEditingController(text: set.quality.beautifulToString());

    var quantityWidgets =
        exerciseType == ExerciseType.weightOverAmount ? reps(set) : time(set);

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
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            onFocusChange: (hasFocus) {
              if (hasFocus) return;
              try {
                var value = double.parse(_qualityController.text);
                if (value != set.quality) {
                  // updateSet(exerciseIndex, setIndex, value, set.quantity);
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
        ...quantityWidgets,
        const Spacer(),
        // PopupMenuButton(
        //   itemBuilder: (context) => [
        //     PopupMenuItem(
        //       child: const Text(
        //         "Delete",
        //       ),
        //       onTap: () {
        //         // deleteSet(exerciseIndex, set);
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }

  List<Widget> reps(WorkoutSet set) {
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
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus) return;
            try {
              var value = double.parse(_quantityController.text);
              if (value != set.quantity) {
                // updateSet(exerciseIndex, setIndex, set.quality, value);
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

  List<Widget> time(WorkoutSet set) {
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
          // updateSet(exerciseIndex, setIndex, set.quality, value);
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
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
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
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
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
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
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

  // void deleteSet(int exerciseIndex, WorkoutSet set) {
  //   SetAPI.delete(AuthService.token!, set.id).then((response) {
  //     if (response.status == ResponseStatus.success) {
  //       setState(() {
  //         _workout!.exercises[exerciseIndex].sets = _workout!
  //             .exercises[exerciseIndex].sets
  //             .where((element) => element.id != set.id)
  //             .toList();
  //       });
  //     } else {
  //       showErrorSnackbar("Failed to delete Set");
  //     }
  //   });
  // }

  // void updateSet(
  //   int exerciseIndex,
  //   int setIndex,
  //   double newQuality,
  //   double newQuantity,
  // ) {
  //   var set = _workout!.exercises[exerciseIndex].sets[setIndex];

  //   SetAPI.update(
  //     AuthService.token!,
  //     set.id,
  //     newQuality,
  //     newQuantity,
  //     set.setType,
  //   ).then((response) {
  //     if (response.status == ResponseStatus.success) {
  //       setState(() {
  //         _workout!.exercises[exerciseIndex].sets[setIndex] = response.data!;
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Set has been updated"),
  //           duration: Duration(milliseconds: 500),
  //         ),
  //       );
  //     } else {
  //       showErrorSnackbar("Failed to update Set");
  //     }
  //   });
  // }

  void showErrorSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: COLOR_ERROR,
      ),
    );
  }

  // void addSet(int exerciseIndex) {
  //   var exercise = _workout!.exercises[exerciseIndex];
  //   SetAPI.create(
  //     AuthService.token!,
  //     exercise.exerciseWorkoutId,
  //     SetType.normal,
  //   ).then((response) {
  //     if (response.status == ResponseStatus.success) {
  //       setState(() {
  //         _workout!.exercises[exerciseIndex].sets.add(response.data!);
  //       });
  //     } else {
  //       showErrorSnackbar("Failed to add Warmup");
  //     }
  //   });
  // }

  // void addWarmup(int exerciseIndex) {
  //   var exercise = _workout!.exercises[exerciseIndex];
  //   SetAPI.create(
  //     AuthService.token!,
  //     exercise.exerciseWorkoutId,
  //     SetType.warmup,
  //   ).then((response) {
  //     if (response.status == ResponseStatus.success) {
  //       var index = exercise.sets
  //           .where((element) => element.setType == SetType.warmup)
  //           .length;

  //       setState(() {
  //         _workout!.exercises[exerciseIndex].sets.insert(index, response.data!);
  //       });
  //     } else {
  //       showErrorSnackbar("Failed to add Warmup");
  //     }
  //   });
  // }
}
