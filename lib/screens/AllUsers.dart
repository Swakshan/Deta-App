import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UpdateModel.dart';
import 'package:deta/screens/TabUserPage.dart';
import 'package:deta/models/UserModel.dart';
// import 'package:deta/unused/AddUser.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/utils/HiveHelper.dart';
import 'package:deta/utils/updateChecker.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/TextFieldWidget.dart';
import 'package:deta/widgets/UpdateDialog.dart';
import 'package:flutter/material.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:format/format.dart';
import 'package:once/once.dart';

class AllUsers extends StatefulWidget {
  final UserModel? userModel;
  const AllUsers({Key? key, this.userModel}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();


}

class _AllUsersState extends State<AllUsers> {
  bool updatedUser = false;
  late final TextEditingController accessToken_controller;
  late final TextEditingController detaname_controller;
  late final TextEditingController spaceid_controller;
  late final TextEditingController role_controller;

  @override
  Widget build(BuildContext context) {
    // checkVersion(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, ALL_USER_TITLE),
      body: FutureBuilder(
        future: UserDB(userModel: emptyUserModel()).getAllUser(),
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
                EMPTY_LIST.format(USER_TXT),
                style: const TextStyle(fontSize: 24),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: fab(context),
    );
  }

  @override
  void initState() {
    accessToken_controller = TextEditingController();
    detaname_controller = TextEditingController();
    spaceid_controller = TextEditingController();
    role_controller = TextEditingController();
    Once.runOnce(
      'update-checker',
      callback: () {
        checkVersion(context,true);
      },
    );

    super.initState();
  }

  Widget buildContent(List items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          EMPTY_LIST.format(USER_TXT),
          style: const TextStyle(fontSize: 24),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        UserModel userModel = items[index];

        return AdvancedCardWidget(
            title: userModel.name,
            subTitle: userModel.spaceId.toString(),
            circleAvatar: CircleAvatar(
              child: Text(userModel.name[0],
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            iconButton: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  // await GotoPage(context,AddUser(userModel: userModel));
                  userSheet(userModel);
                  return;
                }),
            onTap: () async {
              await GotoPage(context, TabUserPage(userModel: userModel));
              return;
            },
            onHold: () async {
              userSheet(userModel);
              // await GotoPage(context,AddUser(userModel: userModel));
              return;
            });
      },
    );
  }

  FloatingActionButton fab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColorDark,
      onPressed: () async {
        UserModel um = emptyUserModel();
        userSheet(um);
        // GotoPage(context, AddUser(userModel: um));
      },
      tooltip: TOOLTIP_ADD_USER,
      child: const Icon(Icons.add),
    );
  }

  userSheet(UserModel userModel) async {
    String title = ADD_USER_TITLE;
    String btnName = BTN_CHECK;
    bool existingUser = false;
    accessToken_controller.text = "";
    detaname_controller.text = "";
    spaceid_controller.text = "";
    role_controller.text = "";

    if (userModel.spaceId != 0) {
      title = UPDATE_USER_TITLE;
      btnName = BTN_SAVE;
      existingUser = true;

      accessToken_controller.text = userModel.accessToken.toString();
      detaname_controller.text = userModel.name.toString();
      spaceid_controller.text = userModel.spaceId.toString();
      role_controller.text = userModel.role.toString();
    }

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                  readOnly: false,
                  onChange: null,
                  labelTxt: ACCESS_TOKEN_TXT,
                  hintTxt: ACCESS_TOKEN_TXT,
                  shouldHide: true,
                  textController: accessToken_controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                  readOnly: true,
                  onChange: null,
                  labelTxt: SPACE_ID_TXT,
                  hintTxt: SPACE_ID_TXT,
                  shouldHide: false,
                  textController: spaceid_controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                  readOnly: true,
                  onChange: null,
                  labelTxt: DETA_NAME_TXT,
                  hintTxt: DETA_NAME_TXT,
                  shouldHide: false,
                  textController: detaname_controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                  readOnly: true,
                  onChange: null,
                  labelTxt: ROLE_TXT,
                  hintTxt: ROLE_TXT,
                  shouldHide: false,
                  textController: role_controller,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      String acessToken = accessToken_controller.text;
                      if (acessToken.contains("_") &&
                          !acessToken.contains(" ")) {
                        if (btnName == BTN_CHECK) {
                          UserModel? user = await findUser(acessToken);
                          if (user == null) {
                            bigSnakbar(context, UNAUTHORZIED,
                                ACCESSTOKEN_NOT_FOUND, 'FAILURE');
                          } else {
                            spaceid_controller.text = user.spaceId.toString();
                            detaname_controller.text = user.name.toString();
                            role_controller.text = user.role.toString();
                            updatedUser = true;

                            setState(() {
                              btnName = BTN_ADD;
                              userModel = user;
                            });


                          }
                        }
                        else if (btnName == BTN_SAVE || btnName == BTN_ADD) {
                          int cond = 0;
                          int spaceId = userModel.spaceId;
                          if(spaceId!=0) {
                            cond = await saveUser(userModel, existingUser);
                          }
                          String action = SAVED;
                          if (!existingUser) {
                            action = SAVED;
                          } else {
                            action = UPDATED;
                          }

                          String name = userModel.name;
                          late String cont;
                          if (cond == 1) {
                            cont = "$action $name";
                          } else if (cond == 2) {
                            action = EXISTS;
                            cont = "$name already $action";
                          }
                          else{
                            action = ERROR;
                            cont = ERROR;
                          }
                          bigSnakbar(context, action, cont, "SUCCESS");
                          Navigator.pop(context);
                        }
                      }


                    },
                    child: Text(btnName),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((value) => {
          if (updatedUser)
            {
              // UserDB(userModel: emptyUserModel()).getAllUser(),
              updatedUser = false,
              setState(() {}),
            }
        });
  }

  @override
  void dispose() {
    accessToken_controller.dispose();
    detaname_controller.dispose();
    spaceid_controller.dispose();
    role_controller.dispose();

    super.dispose();
  }
}



findUser(String accessToken) async {
  UserModel dummyUser = UserModel(
      spaceId: 0, name: "name", role: "role", accessToken: accessToken);
  DetaAPI detaAPI = DetaAPI(userModel: dummyUser);

  UserModel data = await detaAPI.findUser();
  // print(data);
  return data;
}

saveUser(UserModel userModel, bool existingUser) async {
  int id = 0;
  String name = userModel.name.toString();
  int spaceId = userModel.spaceId;
  String role = userModel.role.toString();
  String accessToken = userModel.accessToken.toString();
  UserDB userDB = UserDB(userModel: userModel);

  int cond = await userDB.addUser(upd: existingUser);
  return cond;
}
