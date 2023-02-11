import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssentifia/drawer.dart';
import 'package:ssentifia/filter_meals_general_dialog.dart';
import 'package:ssentifia/filter_workouts_general_dialog.dart';
import 'package:ssentifia/meal_list.dart';
import 'package:ssentifia/meals.dart';
import 'package:ssentifia/user_profile.dart';
import 'package:ssentifia/workout_plan.dart';
import 'package:ssentifia/workout_plan_list.dart';

class HomeScreen extends StatefulWidget {
  final Color darkSlateGray = const Color(0xFF305f5f);
  final Color verdigris = const Color(0xFF66b2b2);
  final Color mistyRose = const Color(0xFFFDDDD8);
  final Color grannySmithApple = const Color(0xFF9fd983);
  final Color pakistanGreen = const Color(0xFF3b6d22);
  final db = FirebaseFirestore.instance;
  var firebaseMeals = <Meal>[];
  var firebaseWorkouts = <WorkoutPlan>[];
  var newMeals = <Meal>[];
  var newWorkouts = <WorkoutPlan>[];
  String searchTextMealsWidget = '';
  String searchTextWorkoutsWidget = '';
  bool editStatus = false;
  String userID = 'rSDbGlblAZSLjlMG2YKT57KLHkg1';

  int currentIndex = 0;

  HomeScreen({super.key, required this.currentIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MealList mealList;
  late WorkoutPlanList workoutList;
  late UserProfileScreen profileScreen;
  late UserProfileScreen calendarScreen;
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  List<WorkoutPlan> workouts = [];
  List<WorkoutPlan> filteredWorkouts = [];
  String searchTextMeals = '';
  String searchTextWorkouts = '';
  TextEditingController searchTextControllerMeals = TextEditingController();
  TextEditingController searchTextControllerWorkouts = TextEditingController();
  RangeValues currentRangeValuesMeals = RangeValues(0, 1000);
  RangeValues currentRangeValuesWorkouts = RangeValues(0, 120);
  RangeLabels rangeLabels = const RangeLabels("0", "1000");
  RangeLabels rangeLabelsWorkouts = const RangeLabels("0", "120");

  bool _updateEditProfile(bool newValue) {
    setState(() {
      widget.editStatus = newValue;
      profileScreen = UserProfileScreen(
          editProfile: widget.editStatus,
          onEditProfileUpdate: _updateEditProfile);
    });

    return newValue;
  }

  @override
  void initState() {
    super.initState();
    _getMealsFromFirestore();
    _getWorkoutPlansFromFirestore();
    meals = widget.firebaseMeals;
    workouts = widget.firebaseWorkouts;
    workoutList = WorkoutPlanList(
      filteredWorkoutString: '',
      filteredWorkoutDurationRange: RangeValues(0, 120),
      filteredWorkouts: widget.newWorkouts,
      firebaseWorkouts: widget.firebaseWorkouts,
    );
    mealList = MealList(
      filteredMeals: widget.newMeals,
      firebaseMeals: widget.firebaseMeals,
      filteredMealsString: '',
      filteredMealsRange: RangeValues(0, 1000),
    );
    profileScreen = UserProfileScreen(
        editProfile: widget.editStatus,
        onEditProfileUpdate: _updateEditProfile);
    calendarScreen = UserProfileScreen(
        editProfile: widget.editStatus,
        onEditProfileUpdate: _updateEditProfile);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        widget.userID = user.uid;
        print('User is signed in!');
      }
    });
  }

  void _getMealsFromFirestore() async {
    var mealsData = await widget.db.collection('meals').get();
    var newMeals =
        mealsData.docs.map((doc) => Meal.fromJson(doc.data())).toList();
    setState(() {
      widget.firebaseMeals = newMeals;
    });
  }

  void _showFilterMealsGeneralDialog() {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        print(MediaQuery.of(context).orientation.index);
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).orientation.index == 1
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width * 0.90,
            child: FilterMealsGeneralDialog(
              currentRangeValues: currentRangeValuesMeals,
              searchTextController: searchTextControllerMeals,
              filteredMeals: widget.newMeals,
              searchText: searchTextMeals,
              onFilterMeals: (currentRangeValues, searchText) {
                filterMeals(currentRangeValues, searchText);
              },
            ),
          ),
        );
      },
    );
  }

  void filterMeals(RangeValues currentRangeValues, String searchText) {
    setState(() {
      widget.newMeals = widget.firebaseMeals.where((meal) {
        if (meal.name!.toLowerCase().contains(searchText.toLowerCase()) &&
            meal.calories! >= currentRangeValues.start &&
            meal.calories! <= currentRangeValues.end) {
          return true;
        }
        return false;
      }).toList();
      filteredMeals = widget.newMeals;
      mealList = MealList(
          filteredMeals: filteredMeals,
          firebaseMeals: widget.firebaseMeals,
          filteredMealsString: searchTextMeals,
          filteredMealsRange: currentRangeValuesMeals);
      searchTextControllerMeals.text = searchText;
      searchTextMeals = searchText;
      currentRangeValuesMeals = currentRangeValues;
    });
  }

  void _getWorkoutPlansFromFirestore() async {
    var workoutPlansData = await widget.db.collection('workouts').get();
    var newWorkoutPlans = workoutPlansData.docs
        .map((doc) => WorkoutPlan.fromJson(doc.data()))
        .toList();
    setState(() {
      widget.firebaseWorkouts = newWorkoutPlans;
    });
  }

  void _showFilterWorkoutsGeneralDialog() {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).orientation.index == 1
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width * 0.90,
            child: FilterWorkoutsGeneralDialog(
              currentRangeValues: currentRangeValuesWorkouts,
              searchTextController: searchTextControllerWorkouts,
              filteredWorkouts: widget.newWorkouts,
              searchText: searchTextWorkouts,
              onFilterWorkouts: (currentRangeValues, searchText) {
                filterWorkouts(currentRangeValues, searchText);
              },
            ),
          ),
        );
      },
    );
  }

  void filterWorkouts(RangeValues currentRangeValues, String searchText) {
    setState(() {
      widget.newWorkouts = widget.firebaseWorkouts.where((workout) {
        if (workout.title!.toLowerCase().contains(searchText.toLowerCase()) &&
            workout.workout_duration! >= currentRangeValues.start &&
            workout.workout_duration! <= currentRangeValues.end) {
          return true;
        }
        return false;
      }).toList();
      filteredWorkouts = widget.newWorkouts;
      workoutList = WorkoutPlanList(
        filteredWorkouts: filteredWorkouts,
        firebaseWorkouts: widget.firebaseWorkouts,
        filteredWorkoutString: searchTextWorkouts,
        filteredWorkoutDurationRange: currentRangeValuesWorkouts,
      );
      searchTextControllerWorkouts.text = searchText;
      searchTextWorkouts = searchText;
      currentRangeValuesWorkouts = currentRangeValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
            'Ssentifia - ${widget.currentIndex == 0 ? 'Workouts' : widget.currentIndex == 1 ? 'Meals' : widget.currentIndex == 2 ? 'Profile' : 'Not A Calendar'}'),
        centerTitle: true,
        actions: widget.currentIndex == 2
            ? [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _updateEditProfile(widget.editStatus ? false : true);
                      });
                    },
                    icon: Icon(widget.editStatus
                        ? Icons.save
                        : Icons.mode_edit_outline))
              ]
            : null,
      ),
      drawer: CustomDrawer(
        currentIndex: widget.currentIndex,
        onTap: (int selected) {
          setState(() {
            widget.currentIndex = selected;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.fitness_center,
                        color: widget.currentIndex == 0
                            ? Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor
                            : Theme.of(context)
                                .bottomNavigationBarTheme
                                .unselectedItemColor),
                    onPressed: () {
                      setState(() {
                        widget.currentIndex = 0;
                      });
                    },
                  ),
                  Text('Workout \nPlans',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.currentIndex == 0
                              ? Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .selectedItemColor
                              : Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor)),
                  Padding(padding: EdgeInsets.all(5))
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.local_dining,
                        color: widget.currentIndex == 1
                            ? Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor
                            : Theme.of(context)
                                .bottomNavigationBarTheme
                                .unselectedItemColor),
                    onPressed: () {
                      setState(() {
                        widget.currentIndex = 1;
                      });
                    },
                  ),
                  Text('Nutrition \nTracking',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.currentIndex == 1
                              ? Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .selectedItemColor
                              : Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor)),
                  Padding(padding: EdgeInsets.all(5))
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .1,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.person_rounded,
                        color: widget.currentIndex == 2
                            ? Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor
                            : Theme.of(context)
                                .bottomNavigationBarTheme
                                .unselectedItemColor),
                    onPressed: () {
                      setState(() {
                        widget.currentIndex = 2;
                      });
                    },
                  ),
                  Text('Profile',
                      style: TextStyle(
                          color: widget.currentIndex == 2
                              ? Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .selectedItemColor
                              : Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor)),
                  Padding(padding: EdgeInsets.all(5))
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.calendar_month_rounded,
                        color: widget.currentIndex == 3
                            ? Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor
                            : Theme.of(context)
                                .bottomNavigationBarTheme
                                .unselectedItemColor),
                    onPressed: () {
                      setState(() {
                        widget.currentIndex = 3;
                      });
                    },
                  ),
                  Text('Not A \nCalendar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.currentIndex == 3
                              ? Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .selectedItemColor
                              : Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor)),
                  Padding(padding: EdgeInsets.all(5))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.currentIndex == 0
            ? _showFilterWorkoutsGeneralDialog
            : _showFilterMealsGeneralDialog,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.filter_list),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: widget.currentIndex == 0
          ? workoutList
          : widget.currentIndex == 1
              ? mealList
              : widget.currentIndex == 2
                  ? profileScreen
                  : calendarScreen,
    );
  }
}
