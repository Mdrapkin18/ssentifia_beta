import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssentifia/workout_plan.dart';

class WorkoutPlanDetail extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  WorkoutPlanDetail({
    required this.workoutPlan,
  });

  @override
  _WorkoutPlanDetailState createState() => _WorkoutPlanDetailState();
}

class _WorkoutPlanDetailState extends State<WorkoutPlanDetail> {
  Map exerciseUpdate = {};
  Map exerciseNew = {};
  final Map exerciseList = {};

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    widget.workoutPlan.exercises?.asMap().forEach((key, value) {
      exerciseNew[key] = value;
      exerciseList[key] = value;
    });
    print('Top: \n$exerciseNew');
    print('Top2: \n$exerciseList');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.workoutPlan.title.toString()),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            // height: screenSize.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Description: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: screenSize.width * 0.8,
                  child: Text(
                    widget.workoutPlan.description.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Experience level: ${widget.workoutPlan.experience_level}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Workout duration: ${widget.workoutPlan.workout_duration} minutes",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Estimated MET: ${widget.workoutPlan.estimated_MET}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Equipment: ${widget.workoutPlan.workout_equipment!.isNotEmpty ? widget.workoutPlan.workout_equipment : "None"}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Location: ${widget.workoutPlan.location_to_complete}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: widget.workoutPlan.exercises?.length,
                itemBuilder: (context, index) {
                  Map exercise = widget.workoutPlan.exercises![index];
                  String exName = exercise['exercise'].toString();
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(exercise['exercise'],
                              style: Theme.of(context).textTheme.titleLarge),
                          SizedBox(height: 8),
                          Text(
                            exercise['exerciseDescription'],
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: Text(
                                'Sets:',
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: '${exercise['sets']} Sets',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                  onChanged: (value) {
                                    exerciseNew[index]['sets'] =
                                        int.parse(value);
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Text('   Sets',
                                      textAlign: TextAlign.start)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: Text(
                                'Reps:',
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: '${exercise['repetition']} Reps',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                  onChanged: (value) {
                                    exerciseNew[index]['repetition'] =
                                        int.parse(value);
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Text('   Reps',
                                      textAlign: TextAlign.start)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: Text(
                                'Weight:',
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: '${exercise['weight']} lbs',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                  onChanged: (value) {
                                    exerciseNew[index]['weight'] =
                                        int.parse(value);
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Text('   lbs',
                                      textAlign: TextAlign.start)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: Text(
                                'Duration:',
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText:
                                        '${exercise['exercise_duration']} min',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                  onChanged: (value) {
                                    exerciseNew[index]['exercise_duration'] =
                                        int.parse(value);
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Text('   Minutes',
                                      textAlign: TextAlign.start)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  exerciseUpdate.update(
                                      exName, (value) => exerciseNew,
                                      ifAbsent: () => exerciseNew);
                                  print(exerciseUpdate);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("My title"),
                                          content: Text("$exerciseUpdate"),
                                        );
                                      });
                                },
                                child: Text('Update Exercise'),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Save & Exit'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
