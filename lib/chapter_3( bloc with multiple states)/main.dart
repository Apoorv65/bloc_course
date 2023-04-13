import 'blocs/appEvents.dart';
import 'dialog/dialogGeneric.dart';
import 'dialog/loadingScreen.dart';
import 'models.dart';
import 'views/iterableListView.dart';
import 'views/loginView.dart';
import 'apis/loginApi.dart';
import 'blocs/appBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'apis/notesApi.dart';
import 'blocs/appStates.dart';
import 'strings.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(), acceptedLoginHandle: const LoginHandle.fooBar(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                  context: context,
                  text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                description: loginErrorDescription,
                optionsBuilder: () => {ok: true},
              );
            }
            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(
                  const LoadNotesEvents(),
              );
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                    LoginEvent(
                      email: email,
                      password: password,
                  ),
                  );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
