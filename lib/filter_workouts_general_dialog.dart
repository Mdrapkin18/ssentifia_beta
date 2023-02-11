import 'package:flutter/material.dart';
import 'package:ssentifia/workout_plan.dart';

class FilterWorkoutsGeneralDialog extends StatefulWidget {
  RangeValues currentRangeValues;
  TextEditingController searchTextController;
  final List<WorkoutPlan> filteredWorkouts;
  String searchText;
  final Function(RangeValues, String) onFilterWorkouts;

  FilterWorkoutsGeneralDialog({
    Key? key,
    required this.currentRangeValues,
    required this.searchTextController,
    required this.filteredWorkouts,
    required this.searchText,
    required this.onFilterWorkouts,
  }) : super(key: key);

  @override
  _FilterWorkoutsGeneralDialogState createState() =>
      _FilterWorkoutsGeneralDialogState();
}

class _FilterWorkoutsGeneralDialogState extends State<FilterWorkoutsGeneralDialog> {
  double minDuration = 0;
  double maxDuration = 120;
  TextEditingController workoutTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    minDuration = widget.currentRangeValues.start;
    maxDuration = widget.currentRangeValues.end;
    workoutTextController.text = widget.searchText;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisSize: MainAxisSize.min ,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: workoutTextController,
                  maxLines: 1,
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: "Search for a workout...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    widget.searchText = value;
                    widget.onFilterWorkouts(widget.currentRangeValues, value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Filter by duration: $minDuration - $maxDuration minutes'),
              RangeSlider(
                values: RangeValues(minDuration, maxDuration),
                labels: RangeLabels("$minDuration", "$maxDuration"),
                min: 0,
                max: 120,
                divisions: 120,
                onChanged: (values) {
                  setState(() {
                    minDuration = values.start;
                    maxDuration = values.end;
                    widget.onFilterWorkouts(values, widget.searchText);
                    widget.currentRangeValues = values;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
