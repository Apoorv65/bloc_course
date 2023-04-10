import 'package:bloc_course/chapter_2(Intro%20of%20Bloc%20With%20Test%20and%20Specification)/Bloc/person.dart';
import 'package:bloc_course/chapter_2(Intro%20of%20Bloc%20With%20Test%20and%20Specification)/Bloc/person_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPerson1 = [
  Person(name: 'Ram', age: 1000),
  Person(name: 'Ravan', age: 1500),
];

const mockedPerson2 = [
  Person(name: 'Bali', age: 1500),
  Person(name: 'Marich', age: 800),
];

Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPerson1);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group('Testing Bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test for initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state,null),//bloc.state != null,
    );

    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving person from first iterable',
        build: () => bloc,
        act: (bloc) {
         bloc.add(
             const LoadPersonsAction(
                 url:'dummy_url_1',
                 loader: mockGetPerson1
             )
         );
         bloc.add(
             const LoadPersonsAction(
                 url:'dummy_url_1',
                 loader: mockGetPerson1
             )
         );
        },
      expect: () => [
        const FetchResult(persons: mockedPerson1, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPerson1, isRetrievedFromCache: true),
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving person 2 from first iterable',
      build: () => bloc,
      act: (bloc) {
         bloc.add(
             const LoadPersonsAction(
                 url:'dummy_url_2',
                 loader: mockGetPerson2
             )
         );
        bloc.add(
            const LoadPersonsAction(
                url:'dummy_url_2',
                loader: mockGetPerson2
            )
        );
      },
      expect: () => [
        const FetchResult(persons: mockedPerson2, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPerson2, isRetrievedFromCache: true),
      ],
    );

  });
}
