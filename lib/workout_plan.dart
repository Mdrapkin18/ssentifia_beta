class WorkoutPlan {
  final String? title; // Make the title parameter nullable
  final String? description;
  final double? workout_duration;
  final List<Map<String, dynamic>>? exercises;
  final String? equipment;
  final String? imgURL;
  final String? experience_level;
  final String? location_to_complete;
  final double? estimated_MET;
  final List? workout_equipment;
  bool completed;

  WorkoutPlan({
    this.title,
    this.description,
    this.workout_duration,
    this.exercises,
    this.equipment,
    this.imgURL,
    this.experience_level,
    this.location_to_complete,
    this.estimated_MET,
    this.workout_equipment,
    this.completed = false,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
        title: json['title'] as String,
        description: json['description'] as String,
        experience_level: json['experience_level'] as String,
        location_to_complete: json['location_to_complete'] as String,
        workout_duration: json['workout_duration'].toDouble() as double,
        estimated_MET: json['estimated_MET'].toDouble() as double,
        workout_equipment: json['workout_equipment'] as List,
        exercises: json['exercises'] != null
            ? json['exercises']
                .map((key, value) => MapEntry(key, value))
                .values
                .toList()
                .cast<Map<String, dynamic>>()
            : null,
        imgURL: json['imgURL'] ??
            'https://storage.googleapis.com/ssentifia-beta.appspot.com/man-2604149_960_720%20(1).jpg'
                as String);
  }

  // String get id => title!.toLowerCase().replaceAll(' ', '_');
}
