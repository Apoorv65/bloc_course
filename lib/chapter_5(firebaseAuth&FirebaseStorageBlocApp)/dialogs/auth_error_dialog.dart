import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/auth/auth_error.dart';
import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/dialogs/dialog_generic.dart';
import 'package:flutter/material.dart';

Future<void> showAuthErrorDialog({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: authError.dialogTitle,
    description: authError.dialogText,
    optionsBuilder: () => {
      'Ok': true,
    },
  );
}
