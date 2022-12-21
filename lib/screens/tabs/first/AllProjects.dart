import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UserAccessTokenModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/utils/HiveHelper.dart';
import 'package:deta/widgets/AlertDialog.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/TextFieldWidget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:format/format.dart';
import 'package:deta/assets/widgetThemes.dart';

import 'package:deta/models/UserModel.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/screens/TabProjectPage.dart';

class Projects extends StatefulWidget {
  final UserModel userModel;
  const Projects({Key? key, required this.userModel}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  bool createdProject = false;
  String regionVal = "Auto";
  late Future<List?> allProjects;
  late DetaAPI detaAPI;
  late String boxName;

  Future<List?> getProjectList(bool refresh) async {
    var data;
    UserModel um = widget.userModel;
    detaAPI = DetaAPI(userModel: um);
    data = await detaAPI.getProjects(refresh);

    return data;
  }


  @override
  initState() {
    allProjects = getProjectList(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, PROJECTS_TITLE),
      body: RefreshIndicator(
        onRefresh: () async {
          allProjects = getProjectList(true);
          setState(() {});
        },
        child: FutureBuilder(
          future: allProjects,
          builder: (context, AsyncSnapshot<List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return buildContent(snapshot.data!);
              }
              return Center(
                child: Text(
                  EMPTY_LIST.format("projects"),
                  style: const TextStyle(fontSize: 24),
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
          EMPTY_LIST.format("projects"),
          style: const TextStyle(fontSize: 24),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        ProjectModel projectModel = items[index];
        return AdvancedCardWidget(
            title: projectModel.name,
            subTitle: projectModel.id.toString(),
            circleAvatar: CircleAvatar(
              child: Text(projectModel.name[0],
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            iconButton: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () async {
                  showInfoSheet(projectModel);
                  return;
                }),
            onTap: () async {
              await GotoPage(context,
                  TabProjectPage(detaAPI: detaAPI, projectModel: projectModel));
              return;
            },
            onHold: () async {
              showInfoSheet(projectModel);
              return;
            });
      },
    );
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColorDark,
      onPressed: () async {
        await addProjectSheet();
      },
      tooltip: TOOLTIP_ADD_USER,
      child: const Icon(Icons.add),
    );
  }

  void showInfoSheet(dynamic projectModel) {
    final TextEditingController projectName_controller =
        TextEditingController();
    final TextEditingController projectId_controller = TextEditingController();
    final TextEditingController description_controller =
        TextEditingController();
    final TextEditingController region_controller = TextEditingController();

    projectName_controller.text = (projectModel.name.toString());
    projectId_controller.text = projectModel.id.toString();
    description_controller.text = projectModel.description.toString();
    region_controller.text = projectModel.region.toString();

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
                PROJECT_DETAILS_TXT,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_NAME_TXT,
                hintTxt: PROJECT_NAME_TXT,
                shouldHide: false,
                textController: projectName_controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_ID_TXT,
                hintTxt: PROJECT_ID_TXT,
                shouldHide: false,
                textController: projectId_controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_DESP_TXT,
                hintTxt: PROJECT_DESP_TXT,
                shouldHide: false,
                textController: description_controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: PROJECT_REGION_TXT,
                hintTxt: PROJECT_REGION_TXT,
                shouldHide: false,
                textController: region_controller,
              ),
            ),
            Row(
              children: [
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

  addProjectSheet() async {
    final TextEditingController projectName_controller =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  PROJECT_DETAILS_TXT,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                  readOnly: false,
                  onChange: null,
                  labelTxt: PROJECT_NAME_TXT,
                  hintTxt: PROJECT_NAME_TXT,
                  shouldHide: false,
                  textController: projectName_controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select A Region',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: REGIONS
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ))
                            .toList(),
                        value: regionVal,
                        onChanged: (value) {
                          setState(() {
                            regionVal = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      String projectName = projectName_controller.text;
                      if ((projectName.isNotEmpty && projectName.length > 4)) {
                        String regCode = REGION_CODE[regionVal];
                        createProject(projectName,regCode);
                      }
                    },
                    child: const Text(BTN_ADD),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((value) => {
          if (createdProject)
            {
              allProjects = getProjectList(true),
              createdProject = false,
              setState(() {}),
            }
        });
  }

  void createProject(String projectName,String regCode) async{
    String text =
        "$PROJECT_WARNING\n${CREATE_WARNING.format(PROJECT_TXT)}";
    final action = await Dialogs.AlertBox(
      context,
      WARNING,
      text,
    );
    if (action == DialogAction.yes) {
      bool suc = false;
      suc = await detaAPI.createProject(projectName, regCode);

      String title, message, contType;
      if (suc) {
        title = SAVED;
        message = CREATE_SUCCESS.format(projectName);
        contType = "SUCCESS";
        createdProject = true;
      } else {
        title = ERROR;
        message = CREATE_ERR.format(projectName);
        contType = "FAIlURE";
      }
      bigSnakbar(context, title, message, contType);
    }
    Navigator.pop(context);
  }
}
