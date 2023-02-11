import 'package:flutter/material.dart';
import 'package:ssentifia/meals.dart';

// Meal detail class
class MealDetail extends StatelessWidget {
  final Meal meal;

  MealDetail({
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    String nutritionString = meal.nutrition
        .toString()
        .substring(1, meal.nutrition.toString().length - 1);
    List<String> words = nutritionString.split(", ");
    words.sort();
    words =
        words.map((word) => word[0].toUpperCase() + word.substring(1)).toList();
    String output = words.join(", ");

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name ?? 'Loading...'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(meal.imgURL.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    meal.name.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nutritional Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey))),
                      child: Text(
                        output,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      )),
                  const SizedBox(height: 10),
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey))),
                    child: Column(
                        children: meal.ingredients!
                            .map((ingredient) => Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    ingredient,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ))
                            .toList()),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Instructions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey))),
                      child: Text(
                        meal.instructions.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
