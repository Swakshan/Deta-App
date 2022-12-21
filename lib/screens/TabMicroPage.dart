import 'package:deta/assets/Constants.dart';
import 'package:deta/models/ProgramModel.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/models/UserModel.dart';
import 'package:deta/screens/tabs/micro/DetailPage.dart';
import 'package:deta/screens/tabs/micro/DomainPage.dart';
import 'package:deta/screens/tabs/micro/LogPage.dart';
import 'package:deta/utils/APIService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:deta/screens/tabs/first/AllProjects.dart';
import 'package:deta/screens/tabs/first/UserAccessTokens.dart';

class TabMicroPage extends StatefulWidget {
  final DetaAPI detaAPI;
  final ProgramModel programModel;
  const TabMicroPage(
      {Key? key, required this.detaAPI, required this.programModel})
      : super(key: key);

  @override
  State<TabMicroPage> createState() => _TabMicroPageState();
}

class _TabMicroPageState extends State<TabMicroPage> {
  int _pageindex = 0;
  var screens;

  @override
  void initState() {
    // UserModel? um = widget.detaAPI;
    var detaAPI = widget.detaAPI;
    var programModel = widget.programModel;
    screens = [
      DetailPage(detaAPI: detaAPI, programModel: programModel),
      DomainPage(detaAPI: detaAPI, programModel: programModel),
      // LogPage(detaAPI: detaAPI, programModel: programModel),
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
                icon: Icon(CupertinoIcons.info_circle, color: Colors.white),
                selectedIcon: Icon(CupertinoIcons.info_circle_fill),
                label: INFO_TITLE),
            NavigationDestination(
                icon: Icon(Icons.language, color: Colors.white),
                selectedIcon: Icon(Icons.language_rounded),
                label: DOMAIN_TITLE),
          //   NavigationDestination(
          //       icon: Icon(Icons.terminal, color: Colors.white),
          //       selectedIcon: Icon(Icons.terminal_rounded),
          //       label: LOG_TITLE),
          ],
        ),
      ),
    );
  }
}
