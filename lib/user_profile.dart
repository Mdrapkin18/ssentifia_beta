import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:ssentifia/calculations.dart';

class UserProfileScreen extends StatefulWidget {
  bool editProfile;
  final ValueChanged<bool> onEditProfileUpdate;

  UserProfileScreen({
    required this.editProfile,
    required this.onEditProfileUpdate,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  _showReportDialog(String type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          List<String> reportList = [];
          switch (type) {
            case "Fitness Goals":
              {
                reportList = _fitnessGoals;
                return AlertDialog(
                  title: Text(type),
                  content: MultiSelectChip(
                    reportList,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedGoalList = selectedList;
                      });
                    },
                    selectedReportList: selectedGoalList,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Save'))
                  ],
                );
              }
            case "Dietary Needs":
              {
                reportList = _dietaryNeedsList;
                return AlertDialog(
                  title: Text(type),
                  content: MultiSelectChip(
                    reportList,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedDietList = selectedList;
                      });
                    },
                    selectedReportList: selectedDietList,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Save'))
                  ],
                );
              }
            case "Workout Preferences":
              {
                reportList = _workoutPreferences;
                return AlertDialog(
                  title: Text(type),
                  content: MultiSelectChip(
                    reportList,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedWorkoutList = selectedList;
                      });
                    },
                    selectedReportList: selectedWorkoutList,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Save'))
                  ],
                );
              }
          }
          return AlertDialog(
            title: Text('Error!'),
            content: Text(
                'There was an error loading items to select. Please try again later'),
          );
        });
  }

  // Variables to store the user data
  List<String> selectedGoalList = [];
  List<String> selectedDietList = [];
  List<String> selectedWorkoutList = [];
  List<dynamic> calculations = [];
  String _profilePicture = "";
  String _name = "";
  String _email = "";
  String _gender = "male";
  int _age = 30;
  int _height_ft = 0;
  int _height_in = 0;
  int _weight = 180;
  int _goalWeight = 180;
  String _activityLevel = "Lightly Active";
  int _activityLevelNum = 1;
  String _fitnessGoal = "Lose weight";
  String _dietaryNeeds = "";
  var userData;
  var profileInfo;
  var profileInfo2;

  // List of the most popular fitness goals
  List<String> _fitnessGoals = [
    "Lose weight",
    "Gain muscle",
    "Improve endurance",
    "Increase flexibility",
    "Build strength",
    "Improve cardiovascular health",
    "Enhance balance and coordination",
    "Maximize sports performance",
    "Enhance overall wellness",
  ];
  // List of the most popular dietary needs
  List<String> _dietaryNeedsList = [
    "Low-carb",
    "Low-sodium",
    "Vegetarian",
    "Vegan",
    "Pescatarian",
    "Gluten-free",
    "Ketogenic",
    "Paleo",
    "Mediterranean",
    "High-protein",
    "Lacto-ovo vegetarian",
    "Raw food",
    "Whole food plant-based",
    "Intermittent fasting",
    "DASH diet",
  ];

  // List of the most popular Workout Preferences
  List<String> _workoutPreferences = [
    "Yoga",
    "Bodyweight",
    "Dumbbells",
    "Barbells",
    "HIIT",
    "<30 Minutes",
    "Cardio",
    "Kettlebells",
    "Strength Training",
    "Outdoor",
    "Pilates"
  ];

  @override
  void initState() {
    var db = FirebaseFirestore.instance;
    db.collection('users').doc('0wx3LeWLA1VrsEAmyiWAjdWY24G3').get().then(
      (DocumentSnapshot doc) {
        userData = doc.data() as Map<String, dynamic>;
        userData['full_name'] != null ? _name = userData['full_name'] : null;
        userData['email'] != null ? _email = userData['email'] : null;
        userData['age'] != null ? _age = userData['age'] : null;
        userData['gender'] != null ? _gender = userData['gender'] : null;
        userData['height_ft'] != null
            ? _height_ft = userData['height_ft']
            : null;
        userData['height_in'] != null
            ? _height_in = userData['height_in']
            : null;
        userData['weight'] != null ? _weight = userData['weight'] : null;
        userData['goalWeight'] != null
            ? _goalWeight = userData['goalWeight']
            : null;
        userData['activityLevel'] != null
            ? _activityLevel = userData['activityLevel']
            : null;

        calculations = Nutrients(_height_ft, _height_in, _weight.toDouble(),
            _age, _activityLevel, _gender, _goalWeight.toDouble());
        setState(() {
          profileInfo = _ProfileInfoRow(
            editProfile: widget.editProfile,
            height_ft: _height_ft,
            height_in: _height_in,
            weight: _weight,
            goalWeight: _goalWeight,
            activityLevel: _activityLevel,
            age: _age,
            gender: _gender,
            calculations: calculations,
          );
          profileInfo2 = _ProfileInfoRow2(
            bmr: calculations[0],
            tdee: calculations[1],
            bmi: calculations[2],
          );
        });
        print(_height_ft);
        print(userData['profileComplete']);
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.editProfile
        ? profileInfo = _ProfileInfoRow(
            editProfile: widget.editProfile,
            height_ft: _height_ft,
            height_in: _height_in,
            weight: _weight,
            goalWeight: _goalWeight,
            activityLevel: _activityLevel,
            age: _age,
            gender: _gender,
            calculations: calculations,
          )
        : profileInfo = _ProfileInfoRow(
            editProfile: widget.editProfile,
            height_ft: _height_ft,
            height_in: _height_in,
            weight: _weight,
            goalWeight: _goalWeight,
            activityLevel: _activityLevel,
            age: _age,
            gender: _gender,
            calculations: calculations,
          );
    return userData == null
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Loading Profile...'),
              Padding(padding: EdgeInsets.all(8)),
              CircularProgressIndicator(),
            ],
          ))
        : Scaffold(
            body: Column(
              children: [
                Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        _TopPortion(profilePicture: _profilePicture),
                        InkWell(
                          onTap: () {
                            setState(() {
                              print(calculations);
                            });
                          },
                          child: Text(
                            _name != "" ? _name : "Ssentifia Support",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          _email != "" ? _email : "Support@ssentifia.com",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        profileInfo,
                        profileInfo2,
                      ],
                    )),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Recommended Macros:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    SizedBox()
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                            'assets/images/icons8-protein-64.png'),
                                        Text('Protien'),
                                        Text('${calculations[3]}g')
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                            'assets/images/icons8-carbs-64.png'),
                                        Text('Carbs'),
                                        Text('${calculations[4]}g')
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                            'assets/images/icons8-fats-64.png'),
                                        Text('Fat'),
                                        Text('${calculations[5]}g')
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Dietary Needs:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    IconButton(
                                      onPressed: widget.editProfile
                                          ? () {
                                              _showReportDialog(
                                                  'Dietary Needs');
                                            }
                                          : null,
                                      icon: Icon(Icons.add),
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          ?.background,
                                    ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 6,
                                  children: [
                                    for (var item in selectedDietList)
                                      ChoiceChip(
                                        label: Text(item),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        selected: true,
                                        onSelected: (selected) {},
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Fitness Goals:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    IconButton(
                                      onPressed: widget.editProfile
                                          ? () {
                                              _showReportDialog(
                                                  'Fitness Goals');
                                            }
                                          : null,
                                      icon: Icon(Icons.add),
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          ?.background,
                                    ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 6,
                                  children: [
                                    for (var item in selectedGoalList)
                                      ChoiceChip(
                                        label: Text(item),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        selected: true,
                                        onSelected: (selected) {},
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Workout Preferences:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    IconButton(
                                      onPressed: widget.editProfile
                                          ? () {
                                              _showReportDialog(
                                                  'Workout Preferences');
                                            }
                                          : null,
                                      icon: Icon(Icons.add),
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          ?.background,
                                    ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 6,
                                  children: [
                                    for (var item in selectedWorkoutList)
                                      ChoiceChip(
                                        label: Text(item),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        selected: true,
                                        onSelected: (selected) {},
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class _ProfileInfoRow extends StatefulWidget {
  bool editProfile;
  var height_ft;
  var height_in;
  var weight;
  var goalWeight;
  var activityLevel;
  var age;
  var gender;
  var calculations;
  _ProfileInfoRow(
      {Key? key,
      required this.editProfile,
      required this.height_ft,
      required this.height_in,
      required this.weight,
      required this.goalWeight,
      required this.activityLevel,
      required this.age,
      required this.gender,
      required this.calculations})
      : super(key: key);

  @override
  State<_ProfileInfoRow> createState() => _ProfileInfoRowState();
}

class _ProfileInfoRowState extends State<_ProfileInfoRow> {
  List<ProfileInfoItem> _items = [];

  @override
  void initState() {
    super.initState();
    _items = [
      ProfileInfoItem("Height", "${widget.height_ft}' ${widget.height_in}\""),
      ProfileInfoItem("Weight (lbs)", "${widget.weight}"),
      ProfileInfoItem("Goal Weight (lbs)", "${widget.goalWeight}"),
      ProfileInfoItem("Activity Level", "${widget.activityLevel}"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(
                      child: _singleItem(context, item,
                          editProfile: widget.editProfile,
                          height_ft: widget.height_ft,
                          height_in: widget.height_in,
                          weight: widget.weight,
                          goalWeight: widget.goalWeight),
                    )
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item,
          {required int height_ft,
          required int height_in,
          required bool editProfile,
          required int weight,
          required int goalWeight}) =>
      InkWell(
        onTap: editProfile
            ? () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //Here we will build the content of the dialog
                      switch (item.title) {
                        case "Height":
                          {
                            return AlertDialog(
                              title: Text(
                                item.title,
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 60,
                                        child: SpinBox(
                                          min: 3,
                                          max: 7,
                                          value: widget.height_ft.toDouble(),
                                          onChanged: (value) {
                                            height_ft = value.toInt();
                                          },
                                          direction: Axis.vertical,
                                          iconColor: MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                          incrementIcon:
                                              Icon(Icons.arrow_upward_rounded),
                                          decrementIcon: Icon(
                                              Icons.arrow_downward_rounded),
                                          decoration: InputDecoration(
                                              fillColor: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      Text('ft'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        width: 60,
                                        child: SpinBox(
                                          min: 0,
                                          max: 12,
                                          value: widget.height_in.toDouble(),
                                          onChanged: (value) {
                                            height_in = value.toInt();
                                          },
                                          direction: Axis.vertical,
                                          iconColor: MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                          incrementIcon:
                                              Icon(Icons.arrow_upward_rounded),
                                          decrementIcon: Icon(
                                              Icons.arrow_downward_rounded),
                                          decoration: InputDecoration(
                                              fillColor: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      Text('in'),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.height_ft = height_ft;
                                        widget.height_in = height_in;
                                        widget.calculations = Nutrients(
                                            widget.height_ft,
                                            widget.height_in,
                                            widget.weight.toDouble(),
                                            widget.age,
                                            widget.activityLevel,
                                            widget.gender,
                                            widget.goalWeight.toDouble());
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('0wx3LeWLA1VrsEAmyiWAjdWY24G3')
                                            .update({
                                          "height_ft": height_ft,
                                          "height_in": height_in
                                        }).then((value) => print('success'),
                                                onError: (e) =>
                                                    print('Error: $e'));
                                        _items.removeAt(0);
                                        _items.insert(
                                            0,
                                            ProfileInfoItem("Height",
                                                "${widget.height_ft}' ${widget.height_in}\""));
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Save'))
                              ],
                            );
                          }
                        case "Weight (lbs)":
                          {
                            return AlertDialog(
                              title: Text(
                                item.title,
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        child: SpinBox(
                                          min: 60,
                                          max: 400,
                                          value: 180,
                                          onChanged: (value) {
                                            weight = value.toInt();
                                          },
                                          direction: Axis.vertical,
                                          iconColor: MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                          incrementIcon:
                                              Icon(Icons.arrow_upward_rounded),
                                          decrementIcon: Icon(
                                              Icons.arrow_downward_rounded),
                                          decoration: InputDecoration(
                                              fillColor: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('lbs'),
                                    ],
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Save'))
                              ],
                            );
                          }
                        case "Goal Weight (lbs)":
                          {
                            return AlertDialog(
                              title: Text(
                                item.title,
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        child: SpinBox(
                                          min: 60,
                                          max: 400,
                                          value: 180,
                                          onChanged: (value) {
                                            goalWeight = value.toInt();
                                          },
                                          direction: Axis.vertical,
                                          iconColor: MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                          incrementIcon:
                                              Icon(Icons.arrow_upward_rounded),
                                          decrementIcon: Icon(
                                              Icons.arrow_downward_rounded),
                                          decoration: InputDecoration(
                                              fillColor: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('lbs'),
                                    ],
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Save'))
                              ],
                            );
                          }
                        case "Activity Level":
                          {
                            return AlertDialog(
                              title: Text(
                                item.title,
                                textAlign: TextAlign.center,
                              ),
                              content: Column(),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Save'))
                              ],
                            );
                          }
                      }
                      return AlertDialog(
                        title: Text('Error!'),
                        content: Text(
                            'There was an error loading items to select. Please try again later'),
                      );
                    });
              }
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      );
}

class ProfileInfoItem {
  final String title;
  final String value;
  ProfileInfoItem(this.title, this.value);
}

class _ProfileInfoRow2 extends StatefulWidget {
  var bmr;
  var tdee;
  var bmi;

  _ProfileInfoRow2({
    Key? key,
    required this.bmr,
    required this.tdee,
    required this.bmi,
  }) : super(key: key);

  @override
  State<_ProfileInfoRow2> createState() => _ProfileInfoRow2State();
}

class _ProfileInfoRow2State extends State<_ProfileInfoRow2> {
  List<ProfileInfoItem2> _items2 = [];
  @override
  void initState() {
    super.initState();
    _items2 = [
      ProfileInfoItem2("BMR", "${widget.bmr}"),
      ProfileInfoItem2("TDEE", "${widget.tdee}"),
      ProfileInfoItem2("BMI", "${widget.bmi}"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items2
            .map((item2) => Expanded(
                    child: Row(
                  children: [
                    if (_items2.indexOf(item2) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem2(context, item2)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem2(BuildContext context, ProfileInfoItem2 item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              ),
            ),
          ),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
}

class ProfileInfoItem2 {
  final String title;
  final String value;
  const ProfileInfoItem2(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  String profilePicture = "";
  _TopPortion({Key? key, required String profilePicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).primaryColor
                  ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: profilePicture == ""
                              ? AssetImage('assets/images/male_avatar.png')
                                  as ImageProvider
                              : NetworkImage(profilePicture)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final List<String> selectedReportList;
  final Function(List<String>) onSelectionChanged; // +added

  MultiSelectChip(this.reportList,
      {required this.onSelectionChanged, required this.selectedReportList});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];
  bool isSelected = false;
// this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = [];
    selectedChoices = widget.selectedReportList;
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item,
              style: TextStyle(
                  color: selectedChoices.contains(item)
                      ? Colors.black
                      : Colors.white)),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
