import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ssentifia/home_screen.dart';
import 'package:ssentifia/login_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color black = const Color(0xFF000000);
  final Color darkSlateGray = const Color(0xFF305f5f);
  final Color verdigris = const Color(0xFF66b2b2);
  final Color mistyRose = const Color(0xFFFDDDD8);
  final Color grannySmithApple = const Color(0xFF9fd983);
  final Color pakistanGreen = const Color(0xFF3b6d22);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: grannySmithApple,
            ),
            primaryColor: grannySmithApple,
            backgroundColor: mistyRose,
            scaffoldBackgroundColor: mistyRose,
            secondaryHeaderColor: verdigris,
            primaryColorDark: pakistanGreen,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(grannySmithApple))),
            progressIndicatorTheme:
                ProgressIndicatorThemeData(color: grannySmithApple),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: grannySmithApple, splashColor: verdigris),
            buttonTheme: ButtonThemeData(
                buttonColor: grannySmithApple,
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(background: grannySmithApple)),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: grannySmithApple)),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: grannySmithApple,
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(color: black),
              displayMedium: TextStyle(color: black),
              bodyLarge: TextStyle(color: black),
              bodyMedium: TextStyle(color: black),
            ),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: verdigris, tertiary: darkSlateGray),
            chipTheme: ChipThemeData(
                backgroundColor: pakistanGreen,
                selectedColor: grannySmithApple,
                elevation: 20,
                pressElevation: 0,
                selectedShadowColor: Colors.white)),
        title: 'Ssentifia',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen(
                currentIndex: 0,
              );
            } else {
              return LoginScreen();
            }
          },
        ));
  }
}
