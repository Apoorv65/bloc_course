import 'package:bloc_course/chapter_4(%20multiBloc%20Provider%20)/blocs/bottom_bloc.dart';
import 'package:bloc_course/chapter_4(%20multiBloc%20Provider%20)/blocs/upper_bloc.dart';
import 'package:bloc_course/chapter_4(%20multiBloc%20Provider%20)/views/appBlocView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<Upper>(
              create: (_) => Upper(
                waitBeforeLoading: const Duration(seconds: 1),
                urls: images,
              ),
            ),
            BlocProvider<Bottom>(
              create: (_) => Bottom(
                waitBeforeLoading: const Duration(seconds: 1),
                urls: images,
              ),
            )
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              AppBlocView<Upper>(),
              AppBlocView<Bottom>(),
            ],
          ),
        ),
      ),
    );
  }
}
