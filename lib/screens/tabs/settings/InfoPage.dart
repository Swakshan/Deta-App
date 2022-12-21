import 'package:deta/assets/Constants.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/utils/updateChecker.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/GroupCardList.dart';
import 'package:deta/widgets/LinkTileWidget.dart';
import 'package:deta/widgets/TileWidget.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late Future<PackageInfo> packageInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, INFO_TITLE),
      body: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return buildContent(context, snapshot.data!);
            }
            return Center(
              child: Text(
                EMPTY_LIST.format(""),
                style: const TextStyle(fontSize: 24),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void initState() {
    packageInfo = PackageInfo.fromPlatform();
    super.initState();
  }

  buildContent(BuildContext context, PackageInfo pkgInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: ListView(
        children: [
          GroupCardList(
            title: APP_INFO_TITLE,
            widgetList: [
              Text(ABOUT,style: Theme.of(context).textTheme.caption,),
              TileWidget(
                  leadingIcon: EvaIcons.info,
                  text: "$VERSION: ${pkgInfo.version.toString()}"),
              TileWidget(
                  leadingIcon: EvaIcons.settings,
                  text: "$BUILD: ${pkgInfo.buildNumber.toString()}"),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      await checkVersion(context,true);
                    },
                    child: const Text(BTN_CHANGELOGS),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool cond = await checkVersion(context,false);
                      if (!cond) {
                        toaster(context, NO_UPDATE);
                      }
                    },
                    child: const Text(BTN_CHECK_UPD),
                  ),
                ],
              )
            ],
          ),
          GroupCardList(
            title: DEV_INFO_TITLE,
            widgetList: [
              LinkTileWidget(
                  leadingIcon: Logo(Logos.twitter),
                  text: "@swak_12",
                  link: "https://twitter.com/swak_12",),
              LinkTileWidget(
                leadingIcon: Logo(Logos.instagram),
                text: "@therealswak",
                link: "https://instagram.com/therealswak",),
              LinkTileWidget(
                leadingIcon: Logo(Logos.github),
                text: "Swakshan",
                link: "https://github.com/Swakshan",),
            ],
          ),
          GroupCardList(
            title: DEV_DONO_TITLE,
            widgetList: [
              // LinkTileWidget(
              //   leadingIcon: Logo(Logos.ko_fi),
              //   text: "Ko-Fi",
              //   link: "https://ko-fi.com/swakshan",),
            ],
          )
        ],
      ),
    );
  }
}
