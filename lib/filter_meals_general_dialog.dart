import 'package:flutter/material.dart';
import 'package:ssentifia/meals.dart';

class FilterMealsGeneralDialog extends StatefulWidget {
  RangeValues currentRangeValues;
  TextEditingController searchTextController;
  final List<Meal> filteredMeals;
  String searchText;
  Function(RangeValues, String) onFilterMeals;

  FilterMealsGeneralDialog({
    Key? key,
    required this.currentRangeValues,
    required this.searchTextController,
    required this.filteredMeals,
    required this.searchText,
    required this.onFilterMeals,
  }) : super(key: key);

  @override
  _FilterMealsGeneralDialogState createState() =>
      _FilterMealsGeneralDialogState();
}

class _FilterMealsGeneralDialogState extends State<FilterMealsGeneralDialog> {
  double minCalories = 0;
  double maxCalories = 1000;
  TextEditingController mealTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    minCalories = widget.currentRangeValues.start;
    maxCalories = widget.currentRangeValues.end;
    mealTextController.text = widget.searchText;
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
                  maxLines: 1,
                  autofocus: true,
                  controller: mealTextController,
                  decoration: const InputDecoration(
                      hintText: "Search for a meal...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    widget.searchText = value;
                    widget.onFilterMeals(widget.currentRangeValues, value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Filter by Calories: $minCalories - $maxCalories'),
              RangeSlider(
                values: RangeValues(minCalories, maxCalories),
                labels: RangeLabels("$minCalories", "$maxCalories"),
                min: 0,
                max: 1000,
                divisions: 1000,
                onChanged: (values) {
                  setState(() {
                    minCalories = values.start;
                    maxCalories = values.end;
                    widget.onFilterMeals(values, widget.searchText);
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
