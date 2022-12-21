import 'package:deta/assets/Constants.dart';
import 'package:deta/utils/LocalStorage.dart';
import 'package:deta/assets/themeColors.dart';
import 'package:deta/utils/themeNotifier.dart';
import 'package:deta/widgets/AdvancedCardWidget.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:deta/widgets/ThemeAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final secureStorage = LocalStorage();
  late int theme_num = 0;
  late String selectedThemeName;

  getThemeNum() async {
    theme_num = await secureStorage.getNum(KEYNAME_THEME);
    setState(() {});
  }

  void onThemeChange(String value, ThemeNotifier themeNotifier) async {
    switch (value) {
      case "Purple":
        {
          theme_num = 1;
          break;
        }
      default:
        {
          theme_num = 0;
          break;
        }
    }
    themeNotifier = themeNotifier.setTheme(THEME_ARR[theme_num]);
    await secureStorage.setValue(KEYNAME_THEME, theme_num.toString());
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    themeNotifier.getTheme;
    selectedThemeName = THEMES_NAME_ARR[theme_num];
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context, SETTINGS_TITLE),
      body: buildContent(themeNotifier),
    );
  }

  @override
  void initState() {
    getThemeNum();
    super.initState();
  }

  Widget buildContent(ThemeNotifier themeNotifier) {
    return Column(
      children: <Widget>[
        AdvancedCardWidget(
            title: THEME_TXT,
            subTitle: selectedThemeName,
            circleAvatar: const CircleAvatar(child: Icon(Icons.sunny)),
            iconButton: null,
            onTap: () async {
              await themeAlertBox(themeNotifier);
              // ShowThemeSheet();
            },
            onHold: null),
      ],
    );
  }

  themeAlertBox(ThemeNotifier themeNotifier) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(THEME_TXT),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup<String>.builder(
                  groupValue: selectedThemeName,
                  onChanged: (value) {
                    setState(() {
                      selectedThemeName = value!;

                      // Navigator.pop(context);
                    });
                    onThemeChange(selectedThemeName, themeNotifier);
                  },
                  items: THEMES_NAME_ARR,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ],
            );
          }),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(CARD_CLOSE),
            )
          ],
        );
      },
    );
  }
}
