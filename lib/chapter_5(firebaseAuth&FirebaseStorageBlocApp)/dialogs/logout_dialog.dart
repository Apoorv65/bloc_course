import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/dialogs/dialog_generic.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    description: 'Are you sure you want to logout?',
    optionsBuilder: () => {
      'Cancel': false,
      'Logout': true,
    },
  ).then((_) => _ ?? false);
}
