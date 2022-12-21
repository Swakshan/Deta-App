import 'package:deta/assets/Constants.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/models/UserModel.dart';
import 'package:deta/screens/tabs/project/AllBases.dart';
import 'package:deta/screens/tabs/project/AllDrives.dart';
import 'package:deta/screens/tabs/project/AllMicro.dart';
import 'package:deta/screens/tabs/project/AllProjectKeys.dart';
import 'package:deta/utils/APIService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:deta/screens/tabs/first/AllProjects.dart';
import 'package:deta/screens/tabs/first/UserAccessTokens.dart';

class TabProjectPage extends StatefulWidget {
  final DetaAPI detaAPI;
  final ProjectModel projectModel;
  const TabProjectPage(
      {Key? key, required this.detaAPI, required this.projectModel})
      : super(key: key);

  @override
  State<TabProjectPage> createState() => _TabProjectPageState();
}

class _TabProjectPageState extends State<TabProjectPage> {
  int _pageindex = 0;
  var screens;

  @override
  void initState() {
    // UserModel? um = widget.detaAPI;
    var detaAPI = widget.detaAPI;
    var projectModel = widget.projectModel;
    screens = [
      AllMicro(detaAPI: detaAPI, projectModel: projectModel),
      AllBases(detaAPI: detaAPI, projectModel: projectModel),
      AllDrives(detaAPI: detaAPI, projectModel: projectModel),
      AllProjectKeys(detaAPI: detaAPI, projectModel: projectModel)
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
            NavigationDestination(
                icon: Icon(Icons.vpn_key_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.vpn_key_rounded),
                label: PROJECT_TOKEN_TITLE),
          ],
        ),
      ),
    );
  }
}
