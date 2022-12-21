import 'package:deta/assets/Constants.dart';
import 'package:deta/models/MicroModel.dart';
import 'package:deta/models/ProgramModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/ExpCardListWidget.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';

class DetailPage extends StatefulWidget {
  DetaAPI detaAPI;
  ProgramModel programModel;
  DetailPage({Key? key, required this.detaAPI, required this.programModel})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<MicroModel?> allList;

  // late List? allList;
  Future<MicroModel?> getMicroDetail(bool refresh) async {
    var data;
    String micro_id = widget.programModel.programId.toString();
    data = await widget.detaAPI.getMicroDetail(micro_id, refresh);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, INFO_TITLE),
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
                return buildContent(snapshot.data!);
              }
              return Center(
                child: Text(
                  EMPTY_LIST.format(DETAILS_TXT),
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }
            return Center(
              child: Text(
                EMPTY_LIST.format(DETAILS_TXT),
                style: const TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildContent(MicroModel? microModel) {
    if (microModel == null) {
      return Center(
        child: Text(
          EMPTY_LIST.format(DETAILS_TXT),
          style: const TextStyle(fontSize: 24),
        ),
      );
    }
    return ListView(
      children: [
        AdvancedCardWidget(
            version: 2,
            title: INFO_ALIAS,
            subTitle: microModel.name.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_ID,
            subTitle: microModel.id.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_CREATED_ON,
            subTitle: formatDate(microModel.created),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_UPD_ON,
            subTitle: formatDate(microModel.updated),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        ExpCardListWidget(
            title: INFO_ENV_VAR, txtList: microModel.envs, onTap: null),
        ExpCardListWidget(
          title: INFO_DEPS,
          txtList: microModel.deps,
          onTap: null,
        ),

        AdvancedCardWidget(
            version: 2,
            title: INFO_LOG_LVL,
            subTitle:
                microModel.logLevel.toString() == "off" ? VISOR_OFF : VISOR_ON,
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_HTTP_A,
            subTitle: microModel.httpAuth.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_PROJECT_ID,
            subTitle: microModel.project.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_REGION,
            subTitle: microModel.region.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_LIBV,
            subTitle: "v${microModel.lib}",
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_RUNTIME,
            subTitle: microModel.runtime.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_MEM,
            subTitle: microModel.memory.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_TIMEOUT,
            subTitle: "${microModel.timeout}s",
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),
        AdvancedCardWidget(
            version: 2,
            title: INFO_REGION,
            subTitle: microModel.region.toString(),
            circleAvatar: null,
            iconButton: null,
            onTap: null,
            onHold: null),

        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: ElevatedButton(
        //           onPressed: () async {
        //             //TODO delete
        //           },
        //           child: const Text(BTN_DELETE),
        //         ),
        //       ),
        //       Container(width: 5.0),
        //       Expanded(
        //         child: ElevatedButton(
        //             onPressed: () async {
        //               //TODO download
        //               return;
        //             },
        //             child: const Text(BTN_DOWNLOAD)),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  @override
  void initState() {
    allList = getMicroDetail(false);
    super.initState();
  }
}
