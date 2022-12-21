import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UserModel.dart';
import 'package:deta/screens/tabs/status/Base.dart';
import 'package:deta/screens/tabs/status/Drive.dart';
import 'package:deta/screens/tabs/status/MicroSts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deta/screens/tabs/first/AllProjects.dart';
import 'package:deta/screens/tabs/first/UserAccessTokens.dart';

class TabStatusPage extends StatefulWidget {
  const TabStatusPage({Key? key}) : super(key: key);

  @override
  State<TabStatusPage> createState() => _TabStatusPageState();
}

class _TabStatusPageState extends State<TabStatusPage> {
  int _pageindex = 0;
  var screens;

  @override
  void initState() {
    screens = [
      MicroSts(),
      BaseSts(),
      DriveSts(),

    ];
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
                icon: Icon(CupertinoIcons.cube, color: Colors.white),
                selectedIcon: Icon(CupertinoIcons.cube_fill),
                label: MICRO_TITLE),
            NavigationDestination(
                icon: Icon(CupertinoIcons.collections, color: Colors.white),
                selectedIcon: Icon(CupertinoIcons.collections_solid),
                label: BASE_TITLE),
            NavigationDestination(
                icon: Icon(Icons.cloud_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.cloud),
                label: DRIVE_TITLE),
          ],
        ),
      ),
    );
  }
}
