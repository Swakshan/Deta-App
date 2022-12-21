import 'package:deta/assets/Constants.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/models/ProjectTokenModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/widgets/AlertDialog.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:format/format.dart';
import 'package:deta/assets/widgetThemes.dart';

import 'package:deta/models/UserModel.dart';

class AllProjectKeys extends StatefulWidget {
  final DetaAPI detaAPI;
  final ProjectModel projectModel;
  const AllProjectKeys(
      {Key? key, required this.detaAPI, required this.projectModel})
      : super(key: key);

  @override
  State<AllProjectKeys> createState() => _ProjectsState();
}

class _ProjectsState extends State<AllProjectKeys> {
  late Future<List?> allList;
  late int allList_len;
  late DetaAPI detaAPI;
  late final TextEditingController id_controller,
      desp_controller,
      access_token_controller,
      created_on_controller,
      access_level_controller,
      active_controller;

  Future<List?> allProjectAccessTokenList(bool refresh) async {
    List data;
    detaAPI = widget.detaAPI;
    String project_id = widget.projectModel.id.toString();
    data = await detaAPI.getProjectTokens(project_id, refresh);
    // if(data==null){
    //   toaster(context, ERROR, ERROR, ContentType.failure);
    // }

    // print(data);

    allList_len = data.length;
    return data;
  }

  @override
  initState() {
    allList = allProjectAccessTokenList(false);
    id_controller = TextEditingController();
    desp_controller = TextEditingController();
    access_token_controller = TextEditingController();
    created_on_controller = TextEditingController();
    access_level_controller = TextEditingController();
    active_controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, PROJECT_TOKEN_TITLE),
      body: RefreshIndicator(
        onRefresh: () async {
          allList = allProjectAccessTokenList(true);
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
                  EMPTY_LIST.format(PROJECT_TOKEN_TITLE),
                  style: TextStyle(fontSize: 24),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: fab(widget.projectModel.id.toString()),
    );
  }

  Widget buildContent(List items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          EMPTY_LIST.format("user access token"),
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          ProjectTokenModel projectTokenModel = items[index];
          // print(items[index].runtimeType);
          return AdvancedCardWidget(
              title: projectTokenModel.name.toString(),
              subTitle: null,
              circleAvatar: CircleAvatar(
                backgroundColor: projectTokenModel.active == true
                    ? Colors.green
                    : Colors.red,
                child: Text(projectTokenModel.name.toString()[0],
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              iconButton: IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () async {
                    // print(userAccessTokenModel);

                    showInfoSheet(projectTokenModel);
                    return;
                  }),
              onTap: null,
              onHold: () async {
                showInfoSheet(projectTokenModel);
                return;
              });
        });
  }

  FloatingActionButton fab(String project_id) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColorDark,
      onPressed: () async {
        String limit = (TOTAL_ACCESSTOKEN_KEYS - allList_len).toString();
        if (limit != "0") {
          showAddSheet(project_id);
        } else {
          bigSnakbar(context, ERROR, ACCESSTOKEN_LIMIT, "FAILURE");
        }
        setState(() {});
      },
      tooltip: TOOLTIP_ADD_USER,
      child: const Icon(Icons.add),
    );
  }

  showInfoSheet(ProjectTokenModel projectTokenModel) async {
    projectTokenModel = await detaAPI.getProjectTokenKey(projectTokenModel);
    // logger.i(projectTokenModel.toJson());

    id_controller.text = (projectTokenModel.name.toString());
    desp_controller.text = projectTokenModel.description.toString();
    created_on_controller.text = formatDate(projectTokenModel.created);
    access_level_controller.text = projectTokenModel.accessLevel.toString();
    active_controller.text = (projectTokenModel.active == true)
        ? ACCESS_TOKEN_ACTIVE_TXT
        : ACCESS_TOKEN_EXP_TXT;
    access_token_controller.text = (projectTokenModel.accessToken == null)
        ? ""
        : projectTokenModel.accessToken.toString();

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
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                PROJECT_KEYS_DETAILS_TXT,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_KEYS_ID_TXT,
                hintTxt: PROJECT_KEYS_ID_TXT,
                shouldHide: false,
                textController: id_controller,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                    readOnly: false,
                    onChange: null,
                    hintTxt: KEYS_TXT,
                    labelTxt: KEYS_TXT,
                    shouldHide: true,
                    textController: access_token_controller)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_KEYS_DESP_TXT,
                hintTxt: PROJECT_KEYS_DESP_TXT,
                shouldHide: false,
                textController: desp_controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: ACCESS_TOKEN_STARTDATE_TXT,
                hintTxt: ACCESS_TOKEN_STARTDATE_TXT,
                shouldHide: false,
                textController: created_on_controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_KEYS_ACCESS_LEVEL,
                hintTxt: ACCESS_TOKEN_EXPDATE_TXT,
                shouldHide: false,
                textController: access_level_controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: ACCESS_TOKEN_ACTIVE_TXT,
                hintTxt: ACCESS_TOKEN_ACTIVE_TXT,
                shouldHide: false,
                textController: active_controller,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async{
                    projectTokenModel.accessToken = access_token_controller.text;
                    bool rd =
                        await detaAPI.saveProjectToken(projectTokenModel);
                    if(rd){
                      toaster(context, SAVED);
                    }
                    else{
                      toaster(context, ERROR);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(BTN_SAVE),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    final action = await Dialogs.AlertBox(
                      context,
                      WARNING,
                      DELETE_WARNING.format(id_controller.text),
                    );
                    if (action == DialogAction.yes) {
                      bool rd = await detaAPI.deleteProjectToken(
                          projectTokenModel.projectId.toString(),
                          id_controller.text);
                      if (rd) {
                        allList = allProjectAccessTokenList(true);
                      }
                    }
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text(CARD_DELETE),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAddSheet(String project_id) async {
    id_controller.text = "";
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
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                PROJECT_KEYS_DETAILS_TXT,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: false,
                onChange: null,
                labelTxt: PROJECT_KEYS_ID_TXT,
                hintTxt: PROJECT_KEYS_ID_TXT,
                shouldHide: false,
                textController: id_controller,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    String title, message, contTyp;
                    String name = id_controller.text;
                    if (name.isNotEmpty) {
                      name = name.replaceAll(" ", "-");
                      String desp = "$PROJECT_TOKEN_TITLE: $name";
                      var rd = await detaAPI.createProjectToken(
                          project_id, name, desp);
                      switch (rd) {
                        case 1:
                          {
                            allList = allProjectAccessTokenList(true);
                            title = SAVED;
                            message = ACCESSTOKEN_CREATED;
                            contTyp = "SUCCESS";
                            break;
                          }
                        case 2:
                          {
                            title = EXISTS;
                            message = EXISTS_WARNING.format(name);
                            contTyp = "WARNING";
                            break;
                          }
                        default:
                          {
                            title = ERROR;
                            message = UNAUTHORZIED;
                            contTyp = "FAILURE";
                            break;
                          }
                      }
                    } else {
                      title = ERROR;
                      message = CHECK_WARNING.format(ACCESS_TOKEN_ID_TXT);
                      contTyp = "FAILURE";
                    }
                    setState(() {});
                    bigSnakbar(context, title, message, contTyp);
                    Navigator.pop(context);
                  },
                  child: const Text(BTN_SAVE),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(BTN_CLOSE),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    access_token_controller.dispose();
    desp_controller.dispose();
    created_on_controller.dispose();
    access_level_controller.dispose();
    active_controller.dispose();
    super.dispose();
  }
}
