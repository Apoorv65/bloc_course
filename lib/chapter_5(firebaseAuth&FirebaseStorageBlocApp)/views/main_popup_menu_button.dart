import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/bloc/app_bloc.dart';
import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/dialogs/delete_account_dialog.dart';
import 'package:bloc_course/chapter_5(firebaseAuth&FirebaseStorageBlocApp)/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    bool isLogout = false;
    bool isDelete = false;
    void logoutFun() async {
      await showLogoutDialog(context).then((value) {
        isLogout = value;
      });
    }

    void deleteFun() async {
      await showDeleteAccountDialog(context).then((value) {
        isDelete = value;
      });
    }
*/
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value)  {
          case MenuAction.logout:
             final log = await showLogoutDialog(context);
            //logoutFun();
            if (log) {
              context.read<AppBloc>().add(
                    const AppEventLogout(),
                  );
            }
            break;
          case MenuAction.deleteAccount:
            final log = await showDeleteAccountDialog(context);
            //deleteFun();
            if (log) {
              context.read<AppBloc>().add(
                    const AppEventDeleteAccount(),
                  );
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Logout'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
