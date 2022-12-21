import 'package:deta/models/ProjectModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:flutter/material.dart';

class AllDrives extends StatefulWidget {
  final DetaAPI detaAPI;
  final ProjectModel projectModel;
  const AllDrives({Key? key,required this.detaAPI,required this.projectModel}) : super(key: key);

  @override
  State<AllDrives> createState() => _AllDrivesState();
}

class _AllDrivesState extends State<AllDrives> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
