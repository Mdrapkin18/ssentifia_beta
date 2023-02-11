import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssentifia/meal_detail.dart';
import 'package:ssentifia/meals.dart';

class MealList extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  String searchText = '';
  TextEditingController searchTextController = TextEditingController();
  RangeValues currentRangeValues = RangeValues(0, 1000);
  RangeLabels rangeLabels = RangeLabels("0", "1000");

  @override
  void initState() {
    super.initState();
    _getMealsFromFirestore();
  }

  void _getMealsFromFirestore() async {
    var mealsData = await widget.db.collection('meals').get();
    var newMeals =
        mealsData.docs.map((doc) => Meal.fromJson(doc.data())).toList();
    setState(() {
      meals = newMeals;
      filteredMeals = newMeals;
    });
  }

  // void _showFilterMealsGeneralDialog() {
  //   showGeneralDialog(
  //     barrierDismissible: true,
  //     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //     barrierColor: Colors.black45,
  //     transitionDuration: const Duration(milliseconds: 200),
  //     context: context,
  //     pageBuilder: (BuildContext context, Animation animation,
  //         Animation secondaryAnimation) {
  //       return Center(
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width * 0.75,
  //           // height: MediaQuery.of(context).size.height * 0.3,
  //           child: FilterMealsGeneralDialog(
  //             currentRangeValues: currentRangeValues,
  //             searchTextController: searchTextController,
  //             filteredMeals: filteredMeals,
  //             searchText: searchText,
  //             onFilterMeals: (currentRangeValues, searchText) {
  //               filterMeals(currentRangeValues, searchText);
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // void filterMeals(RangeValues currentRangeValues, String searchText) {
  //   setState(() {
  //     filteredMeals = meals.where((meal) {
  //       if (meal.name!.toLowerCase().contains(searchText.toLowerCase()) &&
  //           meal.calories! >= currentRangeValues.start &&
  //           meal.calories! <= currentRangeValues.end) {
  //         return true;
  //       }
  //       return false;
  //     }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return meals.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Loading Meals...'),
                Padding(padding: EdgeInsets.all(8)),
                CircularProgressIndicator(),
              ],
            ),
          )
        : Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                )
                              ]),
                          child: Column(children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                meals[index].imgURL.toString(),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    filteredMeals[index].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Calories: " +
                                        filteredMeals[index]
                                            .calories
                                            .toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MealDetail(
                                meal: filteredMeals[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: _showFilterMealsGeneralDialog,
            //   child: const Icon(Icons.filter_list),
            //   backgroundColor: Colors.green,
            // ),
          );
    ;
  }
}
