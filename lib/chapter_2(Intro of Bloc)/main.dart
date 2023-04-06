import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:developer'as devtools show log;

extension Log on Object{
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
} //Start Live Server from vscode before run this application

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          BlocProvider(child: const MyHomePage(), create: (_) => PersonsBloc()),
    );
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction extends LoadAction {
  final PersonUrl url;
  const LoadPersonsAction({required this.url});
}

enum PersonUrl { person1, person2 }

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'http://127.0.0.1:5500/api/person1.json';
      case PersonUrl.person2:
        return 'http://127.0.0.1:5500/api/person2.json';
    }
  }
}     //Event



@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
  @override
  String toString() => '$name';
}

Future<Iterable<Person>> getPerson(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;
  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult ( isRetrievedFromCache = $isRetrievedFromCache, Person = $persons)';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;
        final result =
            FetchResult(isRetrievedFromCache: true, persons: cachedPersons);
        emit(result);
      } else {
        final persons = await getPerson(url.urlString);
        _cache[url] = persons;
        final result =
            FetchResult(persons: persons, isRetrievedFromCache: false);
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<PersonsBloc>()
                          .add(const LoadPersonsAction(url: PersonUrl.person1));
                    },
                    child: const Text('Male'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<PersonsBloc>()
                            .add(const LoadPersonsAction(url: PersonUrl.person2));
                      },
                      child: const Text('Female')),
                ),
              ],
            ),
          ),
          BlocBuilder<PersonsBloc,FetchResult?>(
            buildWhen: (previous, current) {
              return previous?.persons != current?.persons;
            },
            builder:(context, state) {
              state?.log();
              final persons = state?.persons;
              if (persons == null) {
                return const SizedBox();
              }else {
                return Expanded(
                  child: ListView.builder(itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(title: Text(person.name),trailing: Text('${person.age}'),
                    );

                  },itemCount: persons.length,),
                );
              }
            },
          ),


        ],
      ),
    );
  }
}
