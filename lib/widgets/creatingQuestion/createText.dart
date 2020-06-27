import 'package:createtest/data/question.dart';
import 'package:createtest/widgets/creatingQuestion/QuestionBox.dart';
import 'package:flutter/material.dart';

class CreateText extends StatefulWidget {
  final TextQuestion textQuestion;
  final int qNo;
  final void Function(TextQuestion) onDone;
  final void Function(String) onDelete;

  const CreateText(
      {@required this.textQuestion,
      @required this.qNo,
      @required this.onDone,
      @required this.onDelete});

  @override
  _CreateTextState createState() => _CreateTextState();
}

class _CreateTextState extends State<CreateText> {
  bool isEditing;
  String newQtext;
  String newAnswerText;
  int newMarks;

  @override
  void initState() {
    super.initState();
    newMarks = widget.textQuestion.marks;
    newQtext = widget.textQuestion.qText;
    newAnswerText = widget.textQuestion.correctAnswer;
    isEditing = widget.textQuestion.qText == null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return QuestionBox(
      isEditing: isEditing,
      qNo: widget.qNo,
      qText: widget.textQuestion.qText,
      marks: widget.textQuestion.marks,
      onDone: () {
        widget.textQuestion.qText = newQtext;
        widget.textQuestion.correctAnswer = newAnswerText;
        widget.textQuestion.marks = newMarks;

        widget.onDone(widget.textQuestion);
        setState(() {
          isEditing = false;
        });
      },
      onDelete: () {
        widget.onDelete(widget.textQuestion.id);
      },
      onQchange: (v) {
        newQtext = v;
        setState(() {
          isEditing = true;
        });
      },
      onMarksChange: (v) {
        newMarks = v;
      },
      child: TextFormField(
        initialValue: widget.textQuestion.correctAnswer,
        decoration: InputDecoration(
          hintText: 'Enter Answer',
        ),
        maxLines: null,
        textInputAction: TextInputAction.done,
        onChanged: (v) {
          newAnswerText = v;
          setState(() {
            isEditing = true;
          });
        },
      ),
    );
  }
}
