import 'package:bloc_course/chapter_4(%20)/blocs/app_bloc.dart';

class Bottom extends AppBloc {
  Bottom({
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(urls: urls, waitBeforeLoading: waitBeforeLoading);
}
