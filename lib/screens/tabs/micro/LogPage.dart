import 'package:deta/models/ProgramModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  DetaAPI detaAPI;
  ProgramModel programModel;
  LogPage({Key? key,required this.detaAPI,required this.programModel}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
