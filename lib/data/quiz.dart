import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Quiz {
  final String name, description, id;
  final int durationMinutes;
  final Timestamp createdOn;
//final  String password;

  Quiz({
    @required this.durationMinutes,
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.createdOn,
//    @required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
//        'password': password,
        'name': name,
        'description': description,
        'createdOn': createdOn,
        'durationMinutes': durationMinutes
      };

  factory Quiz.fromDocument(Map<String, dynamic> doc) {
    return Quiz(
      durationMinutes: doc['durationMinutes'],
      id: doc['id'],
      name: doc['name'],
      description: doc['description'],
      createdOn: doc['createdOn'],
//      password: doc['password'],
    );
  }
}
