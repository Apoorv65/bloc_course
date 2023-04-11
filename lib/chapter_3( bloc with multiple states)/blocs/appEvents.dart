import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvents{
const AppEvents();
}

@immutable
class LoginEvent implements AppEvents{
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });
}

@immutable
class LoadNotesEvents implements AppEvents{
  const LoadNotesEvents();
}
