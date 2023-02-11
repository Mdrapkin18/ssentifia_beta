import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ssentifia/create_login_screen.dart';
import 'package:ssentifia/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color grannySmithApple = const Color(0xFF9fd983);

  final Color verdigris = const Color(0xFF66b2b2);

  final Color pakistanGreen = const Color(0xFF3b6d22);

  final Color darkSlateGray = const Color(0xFF305f5f);

  final Color mistyRose = const Color(0xFFFDDDD8);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => HomeScreen(
                  currentIndex: 0,
                )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // color: mistyRose,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkSlateGray, pakistanGreen],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).orientation.index == 1
                  ? MediaQuery.of(context).size.width * .3
                  : MediaQuery.of(context).size.width * .1,
              vertical: MediaQuery.of(context).size.height * .1),
          children: <Widget>[
            const SizedBox(height: 15),
            SvgPicture.asset(
              'assets/images/ssentifia_word_logo_transparent_2.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: mistyRose.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: darkSlateGray),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: verdigris),
                  ),
                ),
                style: TextStyle(color: darkSlateGray),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).orientation.index == 1
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: mistyRose.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: darkSlateGray),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: verdigris),
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: darkSlateGray),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => HomeScreen(
                            currentIndex: 0,
                          )));
                  // code to handle forgot password
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }

                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (_) => HomeScreen(
                //           currentIndex: 0,
                //         )));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.transparent,
                elevation: 5,
                minimumSize: MediaQuery.of(context).orientation.index == 1
                    ? Size(MediaQuery.of(context).size.width * 0.4, 60)
                    : Size(MediaQuery.of(context).size.width * 0.8, 40),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: Colors.white, width: 2)),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => CreateLoginScreen()));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => HomeScreen(
                          currentIndex: 0,
                        )));
              },
            ),
            const SizedBox(height: 20),
            SignInButton(
              Buttons.Apple,
              text: 'Coming Soon!',
              onPressed: () {
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (_) => HomeScreen(
                //           currentIndex: 0,
                //         )));
              },
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
