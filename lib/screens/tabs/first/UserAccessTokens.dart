import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UserAccessTokenModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/widgets/AlertDialog.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:format/format.dart';

import 'package:deta/models/UserModel.dart';

class UserAccessTokens extends StatefulWidget {
  final UserModel userModel;
  const UserAccessTokens({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UserAccessTokens> createState() => _ProjectsState();
}

class _ProjectsState extends State<UserAccessTokens> {
  late Future<List?> allList;
  late int allList_len;
  late DetaAPI detaAPI;

  Future<List?> allUserAccessTokenList(bool refresh) async {
    List data;
    UserModel um = widget.userModel;
    detaAPI = DetaAPI(userModel: um);
    data = await detaAPI.getUserTokens(refresh);
    allList_len = data.length;
    return data;
  }

  @override
  initState() {
    allList = allUserAccessTokenList(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, USER_ACCESS_TOKEN_TITLE),
      body: RefreshIndicator(
        onRefresh: () async {
          allList = allUserAccessTokenList(true);
          setState(() {});
        },
        child: FutureBuilder(
          future: allList,
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
                  EMPTY_LIST.format(USER_ACCESS_TOKEN_TITLE),
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: fab(),
    );
  }

  Widget buildContent(List items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          EMPTY_LIST.format("user access token"),
          style: const TextStyle(fontSize: 24),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        UserAccessTokenModel userAccessTokenModel = items[index];
        // print(items[index].runtimeType);
        return AdvancedCardWidget(
            title: userAccessTokenModel.accessKeyId.toString(),
            subTitle:
                "$ACCESS_TOKEN_EXPIN_TXT: ${dateDifference(userAccessTokenModel.expires)}",
            circleAvatar: CircleAvatar(
              child: Text(userAccessTokenModel.accessKeyId.toString()[0],
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            iconButton: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () async {
                  // print(userAccessTokenModel);
                  await ShowInfoSheet(userAccessTokenModel);
                  return;
                }),
            onTap: () async {
              await ShowInfoSheet(userAccessTokenModel);
            },
            onHold: () async {
              await ShowInfoSheet(userAccessTokenModel);
            });
      },
    );
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColorDark,
      onPressed: () async {
        String limit = (TOTAL_ACCESSTOKEN_KEYS - allList_len).toString();
        if (limit != "0") {
          String text =
              "${LIMIT_WARNING.format(limit, KEYS_TXT)}\n${CREATE_WARNING.format(ACCESS_TOKEN_TXT)}";
          final action = await Dialogs.AlertBox(
            context,
            WARNING,
            text,
          );
          if (action == DialogAction.yes) {
            bool rd = await detaAPI.createUserToken();
            if (rd) {
              allList = allUserAccessTokenList(true);
              bigSnakbar(context, SAVED, ACCESSTOKEN_CREATED, "SUCCESS");
            } else {
              bigSnakbar(context, ERROR, ACCESSTOKEN_LIMIT, "FAILURE");
            }
          }
        } else {
          bigSnakbar(context, ERROR, ACCESSTOKEN_LIMIT, "FAILURE");
        }
        setState(() {});
      },
      tooltip: TOOLTIP_ADD_USER,
      child: const Icon(Icons.add),
    );
  }

  ShowInfoSheet(UserAccessTokenModel userAccessTokenModel) async {
    userAccessTokenModel = await detaAPI.getUserTokenKey(userAccessTokenModel);
    final TextEditingController id_controller = TextEditingController();
    final TextEditingController access_token_controller =
        TextEditingController();
    final TextEditingController created_on_controller = TextEditingController();
    final TextEditingController expires_on_controller = TextEditingController();
    final TextEditingController active_controller = TextEditingController();

    id_controller.text = (userAccessTokenModel.accessKeyId.toString());
    created_on_controller.text = formatDate(userAccessTokenModel.created);
    expires_on_controller.text = formatDate(userAccessTokenModel.expires);
    active_controller.text = (userAccessTokenModel.active == true)
        ? ACCESS_TOKEN_ACTIVE_TXT
        : ACCESS_TOKEN_EXP_TXT;
    access_token_controller.text = userAccessTokenModel.accessToken == null
        ? ""
        : userAccessTokenModel.accessToken.toString();

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
                USER_ACCESS_TOKEN_DETAILS_TXT,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                readOnly: true,
                onChange: null,
                labelTxt: ACCESS_TOKEN_ID_TXT,
                hintTxt: ACCESS_TOKEN_ID_TXT,
                shouldHide: false,
                textController: id_controller,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFieldWidget(
                    readOnly: false,
                    onChange: null,
                    hintTxt: ACCESS_TOKEN_TXT,
                    labelTxt: ACCESS_TOKEN_TXT,
                    shouldHide: true,
                    textController: access_token_controller)),
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
                labelTxt: ACCESS_TOKEN_EXPDATE_TXT,
                hintTxt: ACCESS_TOKEN_EXPDATE_TXT,
                shouldHide: false,
                textController: expires_on_controller,
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
                  onPressed: ()async {
                    userAccessTokenModel.accessToken = access_token_controller.text;
                    bool rd =
                        await detaAPI.saveUserToken(userAccessTokenModel);
                    if(rd){
                      toaster(context, SAVED);
                    }
                    else{
                      toaster(context, ERROR);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(CARD_SAVE),
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
                      bool rd =
                          await detaAPI.deleteUserToken(id_controller.text);
                      if (rd) {
                        allList = allUserAccessTokenList(true);
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
}
