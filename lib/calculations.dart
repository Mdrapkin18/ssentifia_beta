import 'dart:math';

List<dynamic> Nutrients(int heightFt, int heightIn, double weight, int age,
    String activityLevel, String gender, double goalWeight) {
  int activityLevelnum = 1;
  // inputs
  switch (activityLevel) {
    case "Sedentary":
      {
        activityLevelnum = 1;
      }
      break;
    case "Lightly Active":
      {
        activityLevelnum = 2;
      }
      break;
    case "Moderately Active":
      {
        activityLevelnum = 3;
      }
      break;
    case "Very Active":
      {
        activityLevelnum = 4;
      }
  }

  double height =
      heightFt.toDouble() * 12 + heightIn.toDouble(); // height in inches

  // convert weight from pounds to kilograms
  weight = weight * 0.453592;

  // convert height from inches to meters
  height = height * 0.0254;

  // calculate BMR
  double bmr;
  if (gender == "male") {
    bmr = 66.5 + (13.75 * weight) + (5.003 * height * 100) - (6.755 * age);
  } else {
    bmr = 655.1 + (9.563 * weight) + (1.850 * height * 100) - (4.676 * age);
  }

  // calculate TDEE
  double tdee;
  switch (activityLevelnum) {
    case 1:
      tdee = bmr * 1.2;
      break;
    case 2:
      tdee = bmr * 1.375;
      break;
    case 3:
      tdee = bmr * 1.55;
      break;
    case 4:
      tdee = bmr * 1.725;
      break;
    default:
      tdee = bmr;
  }
  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  // calculate BMI
  double bmi = weight / pow(height, 2);

  // display results
  print("BMR: ${roundDouble(bmr, 0)}");
  print("TDEE: ${roundDouble(tdee, 0)}");
  print("BMI: ${roundDouble(bmi, 1)}");
  bmr = roundDouble(bmr, 2);
  tdee = roundDouble(tdee, 2);
  bmi = roundDouble(bmi, 1);

  // recommended macro consumption (in grams)
  double goalProtein = (goalWeight * 0.453592).toInt() * 2;
  double goalCarbs = (goalWeight * 0.453592).toInt() * 3;
  double goalFat = (goalWeight * 0.453592).toInt() * 0.8;
  print("Protein: ${roundDouble(goalProtein, 2)}g");
  print("Carbs: ${roundDouble(goalCarbs, 2)}g");
  print("Fat: ${roundDouble(goalFat, 2)}g");
  double protein = roundDouble(goalProtein, 2);
  double carbs = roundDouble(goalCarbs, 2);
  double fat = roundDouble(goalFat, 2);

  // recommended calorie intake
  int goalCalories = (goalProtein * 4 + goalCarbs * 4 + goalFat * 9).toInt();
  print("Calories: $goalCalories");
  print([
    bmr.toInt(),
    tdee.toInt(),
    bmi,
    protein.toInt(),
    carbs.toInt(),
    fat.toInt(),
    goalCalories
  ]);
  return [
    bmr.toInt(),
    tdee.toInt(),
    bmi,
    protein.toInt(),
    carbs.toInt(),
    fat.toInt(),
    goalCalories
  ];
}
