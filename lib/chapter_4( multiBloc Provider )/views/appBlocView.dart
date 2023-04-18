import 'package:bloc_course/chapter_4(%20multiBloc%20Provider%20)/extension/stream/startWith.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/app_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((element) {
      context.read<T>().add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    startUpdatingBloc(context);
    return BlocBuilder<T, AppState>(
      builder: (context, state) {
        if (state.error != null) {
          return const Center(
              child: Text('An error occurred, please try again.'));
        } else if (state.data != null) {
          return Center(
            child: Card(
              shadowColor: Colors.black38,
              elevation: 50,
              child: Image.memory(
                state.data!,
                height: h * .4,
                fit: BoxFit.fitHeight,
              ),
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        }
      },
    );
  }
}
