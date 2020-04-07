import 'package:flutter/foundation.dart';

class User {
  final int id;

  final String firstName;

  final String lastName;

  User({
    @required this.id,
    @required this.firstName,
    this.lastName,
  });
}
