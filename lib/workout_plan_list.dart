import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'workout_plan.dart';
import 'workout_plan_detail.dart';

class WorkoutPlanList extends StatefulWidget {
  final db = FirebaseFirestore.instance;
  String filteredWorkoutString;
  RangeValues filteredWorkoutDurationRange;
  List<WorkoutPlan> filteredWorkouts;
  List<WorkoutPlan> firebaseWorkouts;

  WorkoutPlanList(
      {required this.filteredWorkoutString,
      required this.filteredWorkoutDurationRange,
      required this.filteredWorkouts,
      required this.firebaseWorkouts});

  @override
  _WorkoutPlanListState createState() => _WorkoutPlanListState();
}

class _WorkoutPlanListState extends State<WorkoutPlanList> {
  var filteredWorkouts;

  @override
  void initState() {
    super.initState();
    if (widget.firebaseWorkouts.isEmpty) {
      _getWorkoutPlansFromFirestore();
    } else {}
  }

  void _getWorkoutPlansFromFirestore() async {
    var workoutPlansData = await widget.db.collection('workouts').get();
    var newWorkoutPlans = workoutPlansData.docs
        .map((doc) => WorkoutPlan.fromJson(doc.data()))
        .toList();
    // newWorkoutPlans.forEach((element) {
    //   double totalMin = 0;
    //   element.exercises!.forEach((element) {
    //     totalMin = (totalMin + element['exercise_duration']) as double;
    //   });
    // widget.db.collection('workouts').doc(element.title).update({'workout_duration': totalMin}).then(
    //         (value) => print("DocumentSnapshot successfully updated!"),
    //     onError: (e) => print("Error with ${element.title}: $e"));
    // });
    setState(() {
      widget.firebaseWorkouts = newWorkoutPlans;
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

    return widget.firebaseWorkouts.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Loading Workouts...'),
                Padding(padding: EdgeInsets.all(8)),
                CircularProgressIndicator(),
              ],
            ),
          )
        : widget.filteredWorkouts.isEmpty &&
                widget.filteredWorkoutString == '' &&
                widget.filteredWorkoutDurationRange == RangeValues(0, 120)
            ? Scaffold(
                body: GridView.builder(
                    itemCount: widget.firebaseWorkouts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: itemsPerRow,
                      childAspectRatio: 18 / 11, // width / height
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WorkoutPlanDetail(
                                  workoutPlan: widget.firebaseWorkouts[index],
                                ),
                              ),
                            );
                          },
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
                              child: Column(children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 18 / 6,
                                    child: Image.network(
                                      widget.firebaseWorkouts[index].imgURL
                                          .toString(),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              .005,
                                      horizontal:
                                          MediaQuery.of(context).size.height *
                                              .025),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.firebaseWorkouts[index].title
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Text(
                                        widget
                                            .firebaseWorkouts[index].description
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Difficulty: ${widget.firebaseWorkouts[index].experience_level}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.firebaseWorkouts[index]
                                                        .completed =
                                                    !widget
                                                        .firebaseWorkouts[index]
                                                        .completed;
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: widget
                                                      .firebaseWorkouts[index]
                                                      .completed
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                              backgroundColor: widget
                                                      .firebaseWorkouts[index]
                                                      .completed
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                            ),
                                            child: Text(widget
                                                    .firebaseWorkouts[index]
                                                    .completed
                                                ? 'Completed'
                                                : 'Mark as completed'),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ])));
                    }),
              )
            : widget.filteredWorkouts.isEmpty
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
                          Text("No Workouts Found",
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
                    body: GridView.builder(
                      itemCount: widget.filteredWorkouts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemsPerRow,
                        childAspectRatio: 18 / 12, // width / height
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WorkoutPlanDetail(
                                  workoutPlan: widget.filteredWorkouts[index],
                                ),
                              ),
                            );
                          },
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
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 18 / 6,
                                    child: Image.network(
                                      widget.filteredWorkouts[index].imgURL
                                          .toString(),
                                      // height: 200,
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
                                        widget.filteredWorkouts[index].title
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget
                                            .filteredWorkouts[index].description
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        'Estimated ${widget.filteredWorkouts[index].workout_duration.toString()} minutes',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
  }
}
