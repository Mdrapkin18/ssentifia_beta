import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ssentifia/home_screen.dart';
import 'package:ssentifia/login_screen.dart';
import 'package:ssentifia/on_boarding.dart';

class CreateLoginScreen extends StatefulWidget {
  @override
  State<CreateLoginScreen> createState() => _CreateLoginScreenState();
}

class _CreateLoginScreenState extends State<CreateLoginScreen> {
  final Color grannySmithApple = const Color(0xFF9fd983);

  final Color verdigris = const Color(0xFF66b2b2);

  final Color pakistanGreen = const Color(0xFF3b6d22);

  final Color darkSlateGray = const Color(0xFF305f5f);

  final Color mistyRose = const Color(0xFFFDDDD8);

  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void formErrorMessage() {
    print('error');
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
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Please address the following errors:'),
                      SizedBox(
                        height: 20,
                      ),
                      first_name.text.isEmpty
                          ? Text('Please enter a name')
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      EmailValidator.validate(email.text)
                          ? Container()
                          : Text('Please enter a valid Email'),
                      SizedBox(
                        height: 10,
                      ),
                      password.text.length < 8
                          ? Text('Password is too short')
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void firebaseErrorMessage(text) {
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
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('$text'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> createAccount() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'first_name': first_name.text,
        'last_name': last_name.text,
        'full_name': "${first_name.text} ${last_name.text}",
        'email': email.text,
        'accEmail': credential.user!.email,
        'verified': credential.user!.emailVerified,
        'phoneNumber': credential.user!.phoneNumber,
        'profileComplete': false,
        'profileVisited': false,
        'onBoardingComplete': false,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Error: $e');
    }

    // .then((value) => () {
    //       print(value);
    //       FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(value.user!.uid)
    //           .set({'email': value.user!.email, 'name': name.text}).onError(
    //               (e, _) => print("Error writing document: $e"));
    //       // Navigator.pushReplacement(
    //       //     context,
    //       //     MaterialPageRoute(
    //       //         builder: (BuildContext context) =>
    //       //             HomeScreen(currentIndex: 0)));
    //     })
    //     .onError((error, stackTrace) {
    //   firebaseErrorMessage(error);
    //   print(error);
    //   return () {};
    // });
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingPage1(user: user.uid)));
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
            SvgPicture.asset(
              'assets/images/ssentifia_word_logo_transparent_2.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: const Text(
                'Already have an account?',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.38,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: mistyRose.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: first_name,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: darkSlateGray),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: verdigris),
                      ),
                    ),
                    style: TextStyle(color: darkSlateGray),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.38,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: mistyRose.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: last_name,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: darkSlateGray),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: verdigris),
                      ),
                    ),
                    style: TextStyle(color: darkSlateGray),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
              width: MediaQuery.of(context).size.width * 0.8,
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
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                EmailValidator.validate(email.text)
                    ? first_name.text.isNotEmpty
                        ? password.text.isNotEmpty
                            ? password.text.length > 8
                                ? createAccount()
                                : formErrorMessage()
                            : formErrorMessage()
                        : formErrorMessage()
                    : formErrorMessage();
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (_) => HomeScreen(
                //           currentIndex: 0,
                //         )));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.transparent,
                elevation: 5,
                maximumSize: Size(MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.1),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 41),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: Colors.white, width: 2)),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Or',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            SignInButton(
              Buttons.Google,
              text: 'Sign Up with Google',
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => OnboardingPage1(
                          user: 'rSDbGlblAZSLjlMG2YKT57KLHkg1',
                        )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
