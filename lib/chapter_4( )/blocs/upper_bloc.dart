import 'package:bloc_course/chapter_4(%20)/blocs/app_bloc.dart';

class Upper extends AppBloc {
  Upper({
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(urls: urls, waitBeforeLoading: waitBeforeLoading);
}
