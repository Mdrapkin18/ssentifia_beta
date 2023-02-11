import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssentifia/meal_detail.dart';
import 'package:ssentifia/meals.dart';

class MealList extends StatefulWidget {
  final db = FirebaseFirestore.instance;
  // final HomeScreen homeScreen;
  List<Meal> filteredMeals;
  List<Meal> firebaseMeals;
  String filteredMealsString;
  RangeValues filteredMealsRange;

  MealList({
    // required this.homeScreen,
    required this.firebaseMeals,
    required this.filteredMeals,
    required this.filteredMealsString,
    required this.filteredMealsRange,
  });

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  var filteredMeals;

  @override
  void initState() {
    super.initState();
    if (widget.firebaseMeals.isEmpty) {
      _getMealsFromFirestore();
    } else {}
  }

  void _getMealsFromFirestore() async {
    var mealsData = await widget.db.collection('meals').get();
    var newMeals =
        mealsData.docs.map((doc) => Meal.fromJson(doc.data())).toList();
    setState(() {
      widget.firebaseMeals = newMeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    int itemsPerRow = 1;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 800 && screenWidth <= 1280) {
      itemsPerRow = 2;
    } else if (screenWidth > 1280) {
      itemsPerRow = 3;
    }
    return widget.firebaseMeals.isEmpty
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
        : widget.filteredMeals.isEmpty &&
                widget.filteredMealsString == '' &&
                widget.filteredMealsRange == RangeValues(0, 1000)
            ? Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.firebaseMeals.length,
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
                                  child: AspectRatio(
                                    aspectRatio: 18 / 6,
                                    child: Image.network(
                                      widget.firebaseMeals[index].imgURL
                                          .toString(),
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         .25,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        widget.firebaseMeals[index].name
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Calories: ${widget.firebaseMeals[index].calories}",
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
                                    meal: widget.firebaseMeals[index],
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
              )
            : widget.filteredMeals.isEmpty
                ? Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.sentiment_dissatisfied,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 20),
                          Text("No Meals Found",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.grey)),
                          SizedBox(height: 20),
                          Text("Please try adjusting your search criteria.",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                : Scaffold(
                    body: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.filteredMeals.length,
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
                                      child: AspectRatio(
                                        aspectRatio: 18 / 6,
                                        child: Image.network(
                                          widget.filteredMeals[index].imgURL
                                              .toString(),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            widget.filteredMeals[index].name
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Calories: ${widget.filteredMeals[index].calories}",
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
                                        meal: widget.filteredMeals[index],
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
                  );
  }
}
