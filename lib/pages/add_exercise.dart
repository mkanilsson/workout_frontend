import 'package:flutter/material.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/auth_service.dart';

class AddExercisePage extends StatefulWidget {
  final ExerciseResponse? exercise;

  const AddExercisePage({super.key, this.exercise});

  @override
  State<StatefulWidget> createState() => _AddExercisePage();
}

class _AddExercisePage extends State<AddExercisePage> {
  final nameController = TextEditingController();

  var _selectedExerciseType = ExerciseType.weightOverAmount;

  void add() {
    if (widget.exercise == null) {
      ExerciseAPI.create(
        AuthService.token!,
        nameController.text,
        _selectedExerciseType,
      ).then((response) {
        if (response.status == ResponseStatus.failure) {
          showFailedToAddDialog();
        } else {
          Navigator.of(context).pop(response.data);
        }
      });
    } else {
      ExerciseAPI.update(
        AuthService.token!,
        widget.exercise!.id,
        nameController.text,
        _selectedExerciseType,
      ).then((response) {
        if (response.status == ResponseStatus.failure) {
          showFailedToAddDialog();
        } else {
          Navigator.of(context).pop(response.data);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      nameController.text = widget.exercise!.name;
      _selectedExerciseType = widget.exercise!.exerciseType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Workout"),
      ),
      body: loaded(),
    );
  }

  Widget loaded() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Text(
                widget.exercise == null
                    ? "Add Exercise"
                    : "Edit ${widget.exercise!.name}",
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Name",
                style: TextStyle(
                  fontSize: 16,
                  height: 0.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            TextField(
              controller: nameController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 35),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Type",
                style: TextStyle(
                  fontSize: 16,
                  height: 0.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 15),
            DropdownButton(
              items: [
                DropdownMenuItem(
                  value: ExerciseType.weightOverAmount,
                  child: Text(ExerciseType.weightOverAmount.description),
                ),
                DropdownMenuItem(
                  value: ExerciseType.staticExercise,
                  child: Text(ExerciseType.staticExercise.description),
                ),
                DropdownMenuItem(
                  value: ExerciseType.distanceOverTime,
                  child: Text(ExerciseType.distanceOverTime.description),
                ),
              ],
              value: _selectedExerciseType,
              onChanged: (selectedValue) {
                if (selectedValue is ExerciseType) {
                  setState(() {
                    _selectedExerciseType = selectedValue;
                  });
                }
              },
              isExpanded: true,
            ),
            const SizedBox(height: 35),
            TextButton(
              onPressed: nameController.text.isNotEmpty ? add : null,
              child: Text(
                widget.exercise == null ? "Add" : "Save",
              ),
            )
          ],
        ),
      ),
    );
  }

  void showFailedToAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text("Something went wrong :("),
        );
      },
    );
  }
}
