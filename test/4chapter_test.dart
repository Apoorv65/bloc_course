import 'dart:typed_data';

import 'package:bloc_course/chapter_4(%20multiBloc%20Provider%20)/blocs/app_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Error { dummy }

void main() {
  blocTest(
    'Initial State of the bloc should be empty',
    build: () => AppBloc(urls: []),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );

  blocTest(
    'Test the ability to load a URLs',
    build: () => AppBloc(
      urls: [],
      urlPicker: (allUrls) => '',
      urlLoader: (url) => Future.value(text1Data),
    ),
    act: (bloc) => bloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: text1Data, error: null),
    ],
  );

  blocTest(
    'Throws an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (allUrls) => '',
      urlLoader: (url) => Future.error(Error.dummy),
    ),
    act: (bloc) => bloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      const AppState(isLoading: false, data: null, error: Error.dummy),
    ],
  );

  blocTest(
    'Test ability to load multiple URLs',
    build: () => AppBloc(
      urls: [],
      urlPicker: (allUrls) => '',
      urlLoader: (url) => Future.value(text2Data),
    ),
    act: (bloc) {
      bloc.add(
        const LoadNextUrlEvent(),
      );
      bloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data:text2Data, error: null),
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data:text2Data, error: null),
    ],
  );
}
