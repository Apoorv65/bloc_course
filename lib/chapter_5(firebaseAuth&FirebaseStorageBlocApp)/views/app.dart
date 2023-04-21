import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../loading/loading_screen.dart';
import '../views/login_view.dart';
import '../views/photo_gallery_view.dart';
import '../views/register_view.dart';
import '../bloc/app_bloc.dart';
import '../dialogs/auth_error_dialog.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
          title: 'Photo Library',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xffc70a41),
          ),
          home: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              if (appState.isLoading) {
                LoadingScreen.instance()
                    .show(context: context, text: 'Loading...');
              } else {
                LoadingScreen.instance().hide();
              }
              final authError = appState.authError;
              if (authError != null) {
                showAuthErrorDialog(
                  authError: authError,
                  context: context,
                );
              }
            },
            builder: (context, appState) {
              if (appState is AppStateLoggedOut) {
                return const LoginView();
              } else if (appState is AppStateLoggedIn) {
                return const PhotoGalleryView();
              } else if (appState is AppStateInRegistrationView) {
                return const RegisterView();
              } else {
                return Container();
              }
            },
          ),),
    );
  }
}
