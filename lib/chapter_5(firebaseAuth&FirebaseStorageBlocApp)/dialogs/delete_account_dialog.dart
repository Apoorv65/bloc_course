import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/dialogs/dialog_generic.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account',
    description: 'Are you sure you want to delete this account?',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete Account': true,
    },
  ).then((_) => _ ?? false);
}
