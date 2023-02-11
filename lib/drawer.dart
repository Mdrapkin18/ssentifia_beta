import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssentifia/login_screen.dart';
import 'package:ssentifia/settings.dart';

class CustomDrawer extends StatefulWidget {
  int currentIndex;
  final Function(int) onTap;
  CustomDrawer({Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
      child: Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                accountName: Text(
                  "Support Staff",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("Support@Ssentifia.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    "S",
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ), //Text
                ), //circleAvatar
              ),
            ),
            ListTile(
              title: Text('Workout Plans',
                  style: TextStyle(
                      color: widget.currentIndex == 0
                          ? Color(0xFF3b6d22)
                          : Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor,
                      fontSize: widget.currentIndex == 0 ? 25 : 15)),
              trailing: Icon(Icons.fitness_center,
                  color: widget.currentIndex == 0
                      ? Color(0xFF3b6d22)
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor),
              onTap: () {
                setState(() {
                  widget.onTap(0);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Nutrition Tracking',
                  style: TextStyle(
                      color: widget.currentIndex == 1
                          ? Color(0xFF3b6d22)
                          : Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor,
                      fontSize: widget.currentIndex == 1 ? 25 : 15)),
              trailing: Icon(Icons.local_dining,
                  color: widget.currentIndex == 1
                      ? Color(0xFF3b6d22)
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor),
              onTap: () {
                setState(() {
                  widget.onTap(1);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile',
                  style: TextStyle(
                      color: widget.currentIndex == 2
                          ? Color(0xFF3b6d22)
                          : Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor,
                      fontSize: widget.currentIndex == 2 ? 25 : 15)),
              trailing: Icon(Icons.person_2,
                  color: widget.currentIndex == 2
                      ? Color(0xFF3b6d22)
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor),
              onTap: () {
                setState(() {
                  widget.onTap(2);
                });
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      trailing: Icon(Icons.settings),
                      title: Text("Settings"),
                      onTap: () {
                        // navigate to settings page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SettingsPage2()));
                      },
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));
                      },
                      title: Text("Logout",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor,
                              fontSize: 15)),
                      trailing: Icon(Icons.logout_rounded),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
