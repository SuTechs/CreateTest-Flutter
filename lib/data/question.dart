import 'package:flutter/cupertino.dart';

class Question {
  final String id, type;
  String qText, correctAnswer;
  int marks;

  Question({this.id, this.qText, this.correctAnswer, this.type, this.marks});

  Map<String, dynamic> toJson() => {
        'id': id,
        'qText': qText,
        'correctAnswer': correctAnswer,
        'type': type,
        'marks': marks,
      };

  factory Question.fromDocument(Map<String, dynamic> doc) {
    return UploadQuestion(
      id: doc['id'],
      qText: doc['qText'],
      correctAnswer: doc['correctAnswer'],
      marks: doc['marks'],
    );
  }
}

class McqQuestion extends Question {
  List<String> options = [];

  McqQuestion(
      {String id,
      String qText,
      String correctAnswer,
      @required this.options,
      int marks,
      String type = 'MCQ'})
      : super(
          id: id,
          qText: qText,
          correctAnswer: correctAnswer,
          type: type,
          marks: marks,
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> v = super.toJson();
    v['options'] = options;
    return v;
  }

  factory McqQuestion.fromDocument(Map<String, dynamic> doc) {
    return McqQuestion(
      id: doc['id'],
      qText: doc['qText'],
      correctAnswer: doc['correctAnswer'],
      type: doc['type'],
      marks: doc['marks'],
      options: doc['options'].cast<String>(),
    );
  }
}

class TextQuestion extends Question {
  TextQuestion(
      {String id,
      String qText,
      String correctAnswer,
      int marks,
      String type = 'Text'})
      : super(
          id: id,
          qText: qText,
          correctAnswer: correctAnswer,
          type: type,
          marks: marks,
        );

  factory TextQuestion.fromDocument(Map<String, dynamic> doc) {
    return TextQuestion(
      id: doc['id'],
      qText: doc['qText'],
      correctAnswer: doc['correctAnswer'],
      type: doc['type'],
      marks: doc['marks'],
    );
  }
}

class UploadQuestion extends Question {
  UploadQuestion(
      {String id,
      String qText,
      String correctAnswer,
      int marks,
      String type = 'Upload'})
      : super(
          id: id,
          qText: qText,
          correctAnswer: correctAnswer,
          type: type,
          marks: marks,
        );

  factory UploadQuestion.fromDocument(Map<String, dynamic> doc) {
    return UploadQuestion(
      id: doc['id'],
      qText: doc['qText'],
      correctAnswer: doc['correctAnswer'],
      type: doc['type'],
      marks: doc['marks'],
    );
  }
}
