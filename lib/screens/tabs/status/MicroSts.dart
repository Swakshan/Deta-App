import 'package:deta/assets/Constants.dart';
import 'package:deta/models/MicroStatusModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:flutter/material.dart';

class MicroSts extends StatefulWidget {
  const MicroSts({Key? key}) : super(key: key);

  @override
  State<MicroSts> createState() => _MicroStsState();
}



class _MicroStsState extends State<MicroSts> {
  late Future<List<MicroStatusModel>?> allList;
  String country = STATUS_COUNTRY[0];

  Future<List<MicroStatusModel>?> loadMicroStatus(country) async{
    // print("here");
    var detaStatusAPI = DetaStatusAPI(country: country);
    return await detaStatusAPI.microStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    allList = loadMicroStatus(country);
  }
}
