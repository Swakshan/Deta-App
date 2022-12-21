import 'package:deta/assets/Constants.dart';
import 'package:deta/models/DomainGroupModel.dart';
import 'package:deta/models/MicroModel.dart';
import 'package:deta/models/ProgramModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/widgets/AlertDialog.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/ExpCardListWidget.dart';
import 'package:deta/widgets/ExpDomainCardWidget.dart';
import 'package:deta/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:format/format.dart';
import 'package:grouped_list/grouped_list.dart';

class DomainPage extends StatefulWidget {
  DetaAPI detaAPI;
  ProgramModel programModel;
  DomainPage({Key? key, required this.detaAPI, required this.programModel})
      : super(key: key);

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  late Future<MicroModel?> allList;
  late List groupElements = [];
  late CustomDomains? mainDomainData = CustomDomains(),
      subDomainData = CustomDomains();
  late List<CustomDomains> cusDomainData = [];

  Future<MicroModel?> getMicroDetail(bool refresh) async {
    var data;
    String microId = widget.programModel.programId.toString();
    data = await widget.detaAPI.getMicroDetail(microId, refresh);
    if (data != null) {
      groupMaker(data);
    }
    return data;
  }

  List groupMaker(MicroModel listData) {
    groupElements.clear();
    late DomainGroupModel data;

    String mainDomain = DETA_DOMAIN_URL.format(listData.path.toString());
    CustomDomains mainDomainD =
        CustomDomains(active: true, domainName: mainDomain, ipAddress: "0");
    data = DomainGroupModel(group: 1, customDomains: mainDomainD);
    groupElements.add(data.toJson());

    String? subDomain = listData.pathAlias.toString();
    bool act = subDomain.isEmpty ? false : true;
    subDomain =
        subDomain.isEmpty ? NO_DOMAIN : DETA_DOMAIN_URL.format(subDomain);
    CustomDomains subDomainD =
        CustomDomains(active: act, domainName: subDomain, ipAddress: "0");
    data = DomainGroupModel(group: 2, customDomains: subDomainD);
    groupElements.add(data.toJson());

    List<CustomDomains> cusDomainD = listData.customDomains!;
    if (cusDomainD.isEmpty) {
      CustomDomains domainData =
          CustomDomains(active: act, domainName: NO_DOMAIN, ipAddress: "0");
      data = DomainGroupModel(group: 3, customDomains: domainData);
      groupElements.add(data.toJson());
    } else {
      for (CustomDomains cusd in cusDomainD) {
        data = DomainGroupModel(group: 3, customDomains: cusd);
        groupElements.add(data.toJson());
      }
    }

    setState(() {
      mainDomainData = mainDomainD;
      subDomainData = subDomainD;
      cusDomainData = cusDomainD;
    });

    return groupElements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, DOMAIN_TITLE),
      body: RefreshIndicator(
        onRefresh: () async {
          // allProjects = getProjectList(true);
          allList = getMicroDetail(true);
          setState(() {});
        },
        child: FutureBuilder(
          future: allList,
          builder: (context, AsyncSnapshot<MicroModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return buildContent(groupElements);
              }
              return Center(
                child: Text(
                  EMPTY_LIST.format(DETAILS_TXT),
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: fab(context),
    );
  }

  Widget buildContent(List groupElements) {
    if (groupElements.isEmpty) {
      return Center(
        child: Text(
          EMPTY_LIST.format(DETAILS_TXT),
          style: const TextStyle(fontSize: 24),
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: GroupedListView(
          elements: groupElements,
          groupBy: (groupElements) => groupElements['group'],
          groupSeparatorBuilder: (value) {
            {
              late String title;
              switch (value) {
                case 1:
                  {
                    title = DOMAIN_TXT;
                    break;
                  }
                case 2:
                  {
                    title = SUBDOMAIN_TXT;
                    break;
                  }
                case 3:
                  {
                    title = CUSTOM_DOMAIN_TXT;
                    break;
                  }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(title),
              );
            }
          },
          itemBuilder: (context, groupElements) {
            CustomDomains customDomain = groupElements['value'];
            int grp = groupElements['group'];
            return ExpDomainCardWidget(
                grp: grp,
                customDomains: customDomain,
                onTap: null,
                onEdit: () {
                  domainBottomSheet(grp, customDomain);
                },
                onDelete: () async {
                  await deleteDomain(grp, customDomain);
                });
          },
        ));
  }

  Widget fab(BuildContext context) {
    bool hasSubD = false;
    if (subDomainData != null) {
      hasSubD = subDomainData?.active ?? false;
    }
    return SpeedDial(
      backgroundColor: Theme.of(context).primaryColorDark,
      icon: Icons.add,
      children: [
        SpeedDialChild(
            child: Icon(Icons.add_link_rounded,
                color: Theme.of(context).primaryColorDark),
            label: (hasSubD) ? TOOLTIP_EDIT_SUBDOMAIN : TOOLTIP_ADD_SUBDOMAIN,
            onTap: () async {
              subDomainSheet(subDomainData);
            }),
        SpeedDialChild(
            child: Icon(
              Icons.add_link_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
            label: TOOLTIP_ADD_CUSDOMAIN,
            onTap: () async {
              CustomDomains emptyCusDomain =
                  CustomDomains(domainName: "", ipAddress: "0", active: false);
              cusDomainSheet(emptyCusDomain);
            }),
      ],
    );
  }

  void domainBottomSheet(int grp, CustomDomains? customDomain) {
    if (grp == 2) {
      subDomainSheet(customDomain);
    } else {
      cusDomainSheet(customDomain!);
    }
  }

  deleteDomain(int grp, CustomDomains? customDomain) async {
    String alias = customDomain!.domainName.toString();
    final action = await Dialogs.AlertBox(
      context,
      WARNING,
      DELETE_WARNING.format("\n$alias"),
    );
    if (action == DialogAction.yes) {
      if (grp == 2) {
        updateSubD("");
      } else {
        deleteCusD(alias);
      }
    }
  }

  void subDomainSheet(CustomDomains? customDomain) {
    String subDomainTxt = "";
    if (customDomain != null) {
      subDomainTxt = customDomain.active! == false
          ? ""
          : customDomain.domainName.toString();
    }
    final regex = RegExp(r'^(https://){1}(.*)(\.deta\.dev/){1}$');
    final match = regex.firstMatch(subDomainTxt);
    String? alias = match?.group(2);
    final TextEditingController domainNameController = TextEditingController();
    domainNameController.text = alias ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "$SUBDOMAIN_TXT $DETAILS_TXT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFieldWidget(
                  readOnly: false,
                  labelTxt: SUBDOMAIN_TXT,
                  hintTxt: SUBDOMAIN_TXT,
                  shouldHide: false,
                  textController: domainNameController,
                  onChange: null),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    String alias = domainNameController.text;
                    if (alias != subDomainTxt) {
                      await updateSubD(alias);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(BTN_SAVE),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    await updateSubD("");
                  },
                  child: const Text(BTN_DELETE),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  updateSubD(String alias) async {
    String program_id = widget.programModel.programId.toString();
    bool sts = await widget.detaAPI.updateSubDomain(program_id, alias);

    String title, message, contTyp;
    if (sts) {
      title = UPDATED;
      message = UPDATED_MSG.format(SUBDOMAIN_TXT);
      if (alias.isEmpty) {
        title = DELETED;
        message = DELETED_MSG;
      }

      contTyp = "SUCCESS";
    } else {
      title = ERROR;
      message = UPDATED_ERR.format(SUBDOMAIN_TXT);
      if (alias.isEmpty) {
        message = DELETED_ERR;
      }
      contTyp = "FAILURE";
    }
    bigSnakbar(context, title, message, contTyp);

    allList = getMicroDetail(true);
    setState(() {});
  }

  void cusDomainSheet(CustomDomains customDomain) {
    String cusDomainTxt = customDomain.domainName.toString();
    String ipAddr = customDomain.ipAddress.toString();
    String active = customDomain.active == true ? "Active" : "Inactive";

    final TextEditingController domainNameController = TextEditingController();
    domainNameController.text = cusDomainTxt;

    final TextEditingController ipController = TextEditingController();
    ipController.text = ipAddr;

    List<Widget> btns = [];

    if (ipAddr == "0") {
      domainNameController.text = "";
      btns.add(
        Expanded(
            child: ElevatedButton(
          onPressed: () async {
            String alias = domainNameController.text;
            if (alias.isNotEmpty) {
              String ip = await createCusD(alias);
              if (ip != "0") {
                ipController.text = ip;
                allList = getMicroDetail(true);
              }
            }
            setState(() {});
            Navigator.pop(context);
          },
          child: Text(BTN_SAVE),
        )),
      );
    } else {
      btns.add(
        Expanded(
            child: ElevatedButton(
          onPressed: () async {
            String alias = domainNameController.text;
            await deleteCusD(alias);
            Navigator.pop(context);
          },
          child: const Text(BTN_DELETE),
        )),
      );
      //close btn
    }
    btns.add(
      Expanded(
          child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text(BTN_CLOSE),
      )),
    );

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "$CUSTOM_DOMAIN_TXT $DETAILS_TXT",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFieldWidget(
                      readOnly: false,
                      labelTxt: SUBDOMAIN_TXT,
                      hintTxt: SUBDOMAIN_TXT,
                      shouldHide: false,
                      textController: domainNameController,
                      onChange: null),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFieldWidget(
                      readOnly: true,
                      labelTxt: IP_ADD_TXT,
                      hintTxt: IP_ADD_TXT,
                      shouldHide: false,
                      textController: ipController,
                      onChange: null),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(active),
                    )),
                Row(children: btns),
              ],
            ),
          );
        });
  }

  Future<String> createCusD(String alias) async {
    String title, message, contTyp;
    String program_id = widget.programModel.programId.toString();

    List rd = await widget.detaAPI.createCusDomain(program_id, alias);
    int sts = rd[0];
    message = rd[1];

    if (sts == 2) {
      return message;
    } else {
      title = ERROR;
      message = UPDATED_ERR.format(SUBDOMAIN_TXT);
      if (alias.isEmpty) {
        message = DELETED_ERR;
      }
      contTyp = "FAILURE";
      bigSnakbar(context, title, message, contTyp);
    }
    return "0";
  }

  deleteCusD(String alias) async {
    String title, message, contTyp;
    String program_id = widget.programModel.programId.toString();

    bool sts = await widget.detaAPI.deleteCusDomain(program_id, alias);

    if (sts) {
      title = DELETED;
      message = DELETED_MSG;
      contTyp = "SUCCESS";
    } else {
      title = ERROR;
      message = DELETED_ERR;
      contTyp = "FAILURE";
    }
    bigSnakbar(context, title, message, contTyp);
    allList = getMicroDetail(true);
    setState(() {});
  }

  @override
  void initState() {
    allList = getMicroDetail(false);
    super.initState();
  }
}
