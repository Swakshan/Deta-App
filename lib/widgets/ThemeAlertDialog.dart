// import 'package:deta/assets/Constants.dart';
// import 'package:flutter/material.dart';
// import 'package:group_radio_button/group_radio_button.dart';
//
//
// enum menuitems { pink, purple }
//
// class Dialogs {
//   static Future<menuitems> AlertBox(
//       BuildContext context,
//       ) async {
//     final action = await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           title: Text(THEME_TXT),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RadioGroup<String>.builder(
//                 groupValue: _verticalGroupValue,
//                 onChanged: (value) => setState(() {
//                   _verticalGroupValue = value;
//                 }),
//                 items: _status,
//                 itemBuilder: (item) => RadioButtonBuilder(
//                   item,
//                 ),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Theme.of(context).primaryColor,
//               ),
//               onPressed: () => Navigator.of(context).pop(DialogAction.no),
//               child: const Text('No'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Theme.of(context).primaryColor,
//               ),
//               onPressed: () => Navigator.of(context).pop(DialogAction.yes),
//               child: const Text(
//                 'Yes',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//     return (action != null) ? action : DialogAction.no;
//   }
// }
