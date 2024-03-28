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
                // Navigator.of(context).pushNamed("/add_exercise");
              },
              tooltip: 'Add exercise to workout',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget loading() {
    return const Center(
      child: Text("Loading..."),
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
        itemCount: _workout!.exercises.length,
        itemBuilder: (BuildContext context, int index) {
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
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          print("Hello");
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("Add warmup"),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.labelMedium,
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        padding: MaterialStateProperty.all(
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
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("Add set"),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.labelMedium,
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        padding: MaterialStateProperty.all(
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
    var _quantityController =
        TextEditingController(text: set.quantity.toString());
    var _qualityController =
        TextEditingController(text: set.quality.toString());

    return Row(
      children: [
        Icon(
          set.setType == SetType.warmup
              ? Icons.fireplace_sharp
              : Icons.fitness_center_sharp,
        ),
        const SizedBox(
          width: 35,
        ),
        SizedBox(
          width: 55,
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
          width: 35,
        ),
        SizedBox(
          width: 55,
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
                _quantityController.text = set.quantity.toString();
              }
            },
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          exerciseType.qualityUnit,
          style: Theme.of(context).listTileTheme.subtitleTextStyle,
        ),
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
}
