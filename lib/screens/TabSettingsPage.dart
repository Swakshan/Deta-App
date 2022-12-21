import 'package:deta/assets/Constants.dart';
import 'package:deta/screens/tabs/settings/InfoPage.dart';
import 'package:deta/screens/tabs/settings/SettingsPage.dart';
import 'package:flutter/material.dart';

class TabSettingsPage extends StatefulWidget {
  const TabSettingsPage({Key? key}) : super(key: key);

  @override
  State<TabSettingsPage> createState() => _TabSettingsPageState();
}

class _TabSettingsPageState extends State<TabSettingsPage> {
  int _pageindex = 0;
  var screens;

  @override
  void initState() {

    screens = [SettingsPage(), InfoPage()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_pageindex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          selectedIndex: _pageindex,
          onDestinationSelected: (index) => setState(() {
            _pageindex = index;
          }),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.settings_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.settings_rounded),
                label: SETTINGS_TITLE),
            NavigationDestination(
                icon: Icon(Icons.info_outline, color: Colors.white),
                selectedIcon: Icon(Icons.info_rounded),
                label: INFO_TITLE),
          ],
        ),
      ),
    );
  }
}
