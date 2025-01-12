import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String email;
  final String name;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final List<String> linkedAccounts;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.dateOfBirth,
    this.phoneNumber,
    this.linkedAccounts = const [],
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? dateOfBirth,
    String? phoneNumber,
    List<String>? linkedAccounts,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
    );
  }
}
