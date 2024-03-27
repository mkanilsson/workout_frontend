import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/workout.dart';
import 'package:workout_frontend/auth_service.dart';

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
          return ListTile(
            title: Text(
              _workout!.exercises[index].name,
            ),
            subtitle: Text(_workout!.exercises[index].setDescription),
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
}
