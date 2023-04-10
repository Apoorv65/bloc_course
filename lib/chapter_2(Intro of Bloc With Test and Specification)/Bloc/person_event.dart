part of 'person_bloc.dart';

const person1Url = 'http://127.0.0.1:5500/api/person1.json';
const person2Url = 'http://127.0.0.1:5500/api/person2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadActionEvent {
  const LoadActionEvent();
}

@immutable
class LoadPersonsAction extends LoadActionEvent {
  final String url;
  final PersonLoader loader;
  const LoadPersonsAction({
    required this.url,
    required this.loader,
  });
}
