import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_course/chapter_2(Intro%20of%20Bloc%20With%20Test%20and%20Specification)/Bloc/person.dart';
import 'package:flutter/material.dart';

part 'person_event.dart';


extension IsEqualToIgnoringOrdering<T> on Iterable<T>{
  bool isEqualToIgnoringOrdering(Iterable<T>other) =>
      length == other.length && {...this}.intersection({...other}).length == length;
}


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
  @override
  bool operator == (covariant FetchResult other)  =>
      persons.isEqualToIgnoringOrdering(other.persons) && isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode =>Object.hash(persons, isRetrievedFromCache);

}


class PersonsBloc extends Bloc<LoadActionEvent, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;
        final result = FetchResult(isRetrievedFromCache: true, persons: cachedPersons);
        emit(result);//result from cache
      } else {
        final loader = event.loader;
        final persons = await loader(url);
        _cache[url] = persons;
        final result =
        FetchResult(persons: persons, isRetrievedFromCache: false);
        emit(result);
      }
    });
  }
}