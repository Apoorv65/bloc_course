import 'dart:convert';
import 'dart:io';

import 'package:bloc_course/chapter_2(Intro%20of%20Bloc%20With%20Test%20and%20Specification)/Bloc/person.dart';
import 'package:bloc_course/chapter_2(Intro%20of%20Bloc%20With%20Test%20and%20Specification)/Bloc/person_bloc.dart';
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

Future<Iterable<Person>> getPerson(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));


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
                          .add(const LoadPersonsAction(
                          url:person1Url,
                          loader: getPerson,
                      ));
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
                            .add(const LoadPersonsAction(url: person2Url, loader: getPerson));
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
