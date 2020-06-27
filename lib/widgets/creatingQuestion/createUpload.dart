import 'package:createtest/data/question.dart';
import 'package:createtest/widgets/creatingQuestion/QuestionBox.dart';
import 'package:flutter/material.dart';

String _newQtext;

class CreateUpload extends StatelessWidget {
  final UploadQuestion uploadQuestion;
  final int qNo;
  final void Function(UploadQuestion) onDone;
  final void Function(String) onDelete;

  const CreateUpload(
      {@required this.uploadQuestion,
      @required this.qNo,
      @required this.onDone,
      @required this.onDelete});

  @override
  Widget build(BuildContext context) {
    int newMarks = uploadQuestion.marks;

    return QuestionBox(
      isEditing: uploadQuestion.qText == null ? true : false,
      qNo: qNo,
      qText: uploadQuestion.qText,
      marks: uploadQuestion.marks,
      onDone: () {
        uploadQuestion.qText = _newQtext ?? uploadQuestion.qText;
        print('New q text = $_newQtext and upload q = ${uploadQuestion.qText}');

        uploadQuestion.marks = newMarks;
        onDone(uploadQuestion);
      },
      onDelete: () => onDelete(uploadQuestion.id),
      onMarksChange: (v) {
        newMarks = v;
      },
      onQchange: (v) {
        _newQtext = v;
        print('New q text = $_newQtext');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Upload',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
