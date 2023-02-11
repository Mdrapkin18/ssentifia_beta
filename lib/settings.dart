import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssentifia/home_screen.dart';

class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({Key? key}) : super(key: key);

  @override
  State<SettingsPage2> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<SettingsPage2> {
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                      title: "Dark Mode",
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                          value: _isDark,
                          onChanged: (value) {
                            setState(() {
                              _isDark = value;
                            });
                          }),
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "Notifications",
                      icon: Icons.notifications_none_rounded,
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "Security Status",
                      icon: CupertinoIcons.lock_shield,
                      function: () => {},
                    ),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  title: "Organization",
                  children: [
                    _CustomListTile(
                        title: "Profile",
                        icon: Icons.person_outline_rounded,
                        function: () {
                          Navigator.pop(context);
                          Navigator.pop(context);

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => HomeScreen(
                                        currentIndex: 2,
                                      )));
                        }),
                    _CustomListTile(
                      title: "Messaging",
                      icon: Icons.message_outlined,
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "Calling",
                      icon: Icons.phone_outlined,
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "People",
                      icon: Icons.contacts_outlined,
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "Calendar",
                      icon: Icons.calendar_today_rounded,
                      function: () => {},
                    )
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    _CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded,
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "About",
                      icon: Icons.info_outline_rounded,
                      function: () => {},
                    ),
                    _CustomListTile(
                      title: "Sign out",
                      icon: Icons.exit_to_app_rounded,
                      function: () => {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  Function function;

  _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.trailing,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        function();
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
