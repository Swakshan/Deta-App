import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:deta/screens/tabs/first/AllProjects.dart';
import 'package:deta/screens/tabs/first/UserAccessTokens.dart';

class TabUserPage extends StatefulWidget {
  final UserModel userModel;
  const TabUserPage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<TabUserPage> createState() => _TabUserPageState();
}

class _TabUserPageState extends State<TabUserPage> {
  int _pageindex = 0;
  var screens;

  @override
  void initState() {
    UserModel um = widget.userModel;
    screens = [Projects(userModel: um), UserAccessTokens(userModel: um)];
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
                icon: Icon(Icons.cases_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.cases_rounded),
                label: PROJECTS_TITLE),
            NavigationDestination(
                icon: Icon(Icons.vpn_key_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.vpn_key_rounded),
                label: USER_ACCESS_TOKEN_TITLE),
          ],
        ),
      ),
    );
  }
}
