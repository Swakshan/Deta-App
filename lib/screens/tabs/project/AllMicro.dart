import 'package:deta/assets/Constants.dart';
import 'package:deta/models/ProgramModel.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/widgets/AlertDialog.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:deta/screens/TabMicroPage.dart';

class AllMicro extends StatefulWidget {
  final DetaAPI detaAPI;
  final ProjectModel projectModel;
  const AllMicro({Key? key, required this.detaAPI, required this.projectModel})
      : super(key: key);

  @override
  State<AllMicro> createState() => _AllMicroState();
}

class _AllMicroState extends State<AllMicro> {
  bool deletedMicro = false;
  late Future<List?> allList;
  // late List? allList;
  Future<List?> getMicroList(bool refresh) async {
    var data;
    String project_id = widget.projectModel.id;
    data = await widget.detaAPI.getMicros(project_id, refresh);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, MICRO_TITLE),
      body: RefreshIndicator(
        onRefresh: () async {
          // allProjects = getProjectList(true);
          allList = getMicroList(true);
          setState(() {});
        },
        child: FutureBuilder(
          future: allList,
          builder: (context, AsyncSnapshot<List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return buildContent(snapshot.data!);
              }
              return Center(
                child: Text(
                  EMPTY_LIST.format("micro"),
                  style: TextStyle(fontSize: 24),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget buildContent(List items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          EMPTY_LIST.format("micro"),
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        ProgramModel microModel = items[index];
        return AdvancedCardWidget(
            title: microModel.name.toString(),
            subTitle: null,
            circleAvatar: CircleAvatar(
              child: Text(microModel.name.toString()[0],
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            iconButton: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () async {
                  showInfoSheet(microModel);
                  return;
                }),
            onTap: () async {
              await GotoPage(
                  context,
                  TabMicroPage(
                    detaAPI: widget.detaAPI,
                    programModel: microModel,
                  ));
              return;
            },
            onHold: null);
      },
    );
  }

  showInfoSheet(ProgramModel microModel) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                microModel.name.toString(),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await deleteMicro(microModel);
                },
                child: const Text(BTN_DELETE),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text(BTN_CLOSE),
              ),
            ),
          ],
        ),
      ),
    ).then((value) => {
          if (deletedMicro)
            {
              allList = getMicroList(true),
              deletedMicro = false,
              setState(() {}),
            }
        });
  }

  deleteMicro(ProgramModel microModel) async {
    String microId = microModel.programId.toString();
    String microName = microModel.name.toString();
    String text = DELETE_WARNING.format(microName);
    final action = await Dialogs.AlertBox(
      context,
      WARNING,
      text,
    );
    if (action == DialogAction.yes) {
      bool suc = false;
      suc = await widget.detaAPI.deleteMicro(microId);

      String title, message, contType;
      if (suc) {
        title = DELETED;
        message = DELETED_MSG;
        contType = "SUCCESS";
        deletedMicro = true;
        //TODO delete keys
      } else {
        title = ERROR;
        message = DELETED_ERR;
        contType = "FAIlURE";
      }
      bigSnakbar(context, title, message, contType);
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    allList = getMicroList(false);
    super.initState();
  }
}
