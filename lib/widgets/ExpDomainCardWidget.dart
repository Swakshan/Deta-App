import 'package:deta/assets/Constants.dart';
import 'package:deta/models/MicroModel.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/widgets/ExpCardLinkWidget.dart';
import 'package:deta/widgets/LinkText.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpDomainCardWidget extends StatefulWidget {
  int grp;
  CustomDomains customDomains;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  ExpDomainCardWidget(
      {Key? key,
      required this.grp,
      required this.customDomains,
      required this.onTap,
      required this.onEdit,
      required this.onDelete})
      : super(key: key);

  @override
  State<ExpDomainCardWidget> createState() => _ExpDomainCardWidgetState();

  ElevatedButton addBtn(String btnName, VoidCallback? ontap) {
    late ElevatedButton btn;
    switch (btnName) {
      case BTN_COPY:
        {
          btn = ElevatedButton(
            onPressed: ontap,
            child: Text(btnName),
          );
          break;
        }

      case BTN_ADD:
        {
          btn = ElevatedButton(
            onPressed: ontap,
            child: Text(btnName),
          );
          break;
        }
      case BTN_EDIT:
        {
          btn = ElevatedButton(
            onPressed: ontap,
            child: Text(btnName),
          );
          break;
        }
      case BTN_DETAILS:
        {
          btn = ElevatedButton(
            onPressed: ontap,
            child: Text(btnName),
          );
          break;
        }
      case BTN_QR:
        {
          btn = ElevatedButton(
            onPressed: ontap,
            child: Text(btnName),
          );
          break;
        }

      case BTN_DELETE:
        {
          btn = ElevatedButton(
            onPressed: ontap,
            child: Text(btnName),
          );
          break;
        }
    }
    return btn;
  }
}

class _ExpDomainCardWidgetState extends State<ExpDomainCardWidget> {
  @override
  Widget build(BuildContext context) {
    CustomDomains custD = widget.customDomains;
    List<Widget> btnBar = [];

    // no subdomain
    if (custD.domainName == NO_DOMAIN) {
      btnBar.add(widget.addBtn(BTN_ADD, widget.onEdit));
    } else {
      String domainName = widget.customDomains.domainName.toString();
      btnBar.add(widget.addBtn(BTN_COPY, () {
        copy2Clipboard(context, domainName);
      }));
      btnBar.add(widget.addBtn(BTN_QR, () {
        showQR(context, domainName);
      }));
      if (widget.grp != 1) {
        //domain does have edit & del
        if (widget.grp == 2) {
          btnBar.add(widget.addBtn(BTN_EDIT, widget.onEdit));
        } else {
          //custom domain btn has details btn
          btnBar.add(widget.addBtn(BTN_DETAILS, widget.onEdit));
        }
        btnBar.add(widget.addBtn(BTN_DELETE, widget.onDelete));
      }
    }

    return ExpCardLinkWidget(
      title: LinkText(link: custD.domainName.toString()),
      subTitle: Text(
        custD.active.toString(),
        style: Theme.of(context).textTheme.caption,
      ),
      buttonBar: ButtonBar(
        children: btnBar,
      ),
    );
  }
}

void showQR(BuildContext context, String domainName) {
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
            padding: const EdgeInsets.all(30),
            child: InkWell(
              child: Text(domainName),
              onTap: () {
                copy2Clipboard(context, domainName);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: QrImage(
              data: domainName,
              version: QrVersions.auto,
              size: 320,
              gapless: true,
              embeddedImage: const AssetImage(DETA_LOGO),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(50, 50),
              ),
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      err.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
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
