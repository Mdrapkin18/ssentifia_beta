// import 'package:flutter/material.dart';
//
// class TempCode extends StatefulWidget {
//   const TempCode({Key? key}) : super(key: key);
//
//   @override
//   State<TempCode> createState() => _TempCodeState();
// }
//
// class _TempCodeState extends State<TempCode> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.builder(
//           gridDelegate: gridDelegate,
//           itemBuilder: (context, index) {
//             return InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => WorkoutPlanDetail(
//                         workoutPlan: widget.firebaseWorkouts[index],
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                     margin: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0, 2),
//                             blurRadius: 6,
//                           )
//                         ]),
//                     child: Column(children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         ),
//                         child: AspectRatio(
//                           aspectRatio: 18 / 6,
//                           child: Image.network(
//                             widget.firebaseWorkouts[index].imgURL.toString(),
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                             vertical: MediaQuery.of(context).size.height * .005,
//                             horizontal:
//                                 MediaQuery.of(context).size.height * .025),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.firebaseWorkouts[index].name,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * .01,
//                             ),
//                             Text(
//                               widget.firebaseWorkouts[index].description,
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * .01,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Difficulty: ${widget.firebaseWorkouts[index].difficulty}',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       widget.firebaseWorkouts[index].completed =
//                                           !widget.firebaseWorkouts[index]
//                                               .completed;
//                                     });
//                                   },
//                                   style: TextButton.styleFrom(
//                                     primary: widget
//                                             .firebaseWorkouts[index].completed
//                                         ? Theme.of(context)
//                                             .colorScheme
//                                             .secondary
//                                         : Theme.of(context).colorScheme.primary,
//                                     secondary: widget
//                                             .firebaseWorkouts[index].completed
//                                         ? Theme.of(context).colorScheme.primary
//                                         : Theme.of(context)
//                                             .colorScheme
//                                             .secondary,
//                                   ),
//                                   child: Text(
//                                       widget.firebaseWorkouts[index].completed
//                                           ? 'Completed'
//                                           : 'Mark as completed'),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     ])));
//           }),
//     );
//   }
// }
