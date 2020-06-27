import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:createtest/data/question.dart';
import 'package:createtest/widgets/responseTile.dart';
import 'package:flutter/material.dart';

class ResponseDetail extends StatefulWidget {
  final CollectionReference questionsRef;
  final DocumentReference responsesRef;
  final int maxMarks;
  final String heroTag;

  const ResponseDetail({
    @required this.heroTag,
    @required this.questionsRef,
    @required this.responsesRef,
    @required this.maxMarks,
  });

  @override
  _ResponseDetailState createState() => _ResponseDetailState();
}

class _ResponseDetailState extends State<ResponseDetail> {
  Map<String, dynamic> answers = {};
  int totalReceivedMarks = 0;

  @override
  void dispose() {
    widget.responsesRef
        .setData({'receivedMarks': totalReceivedMarks}, merge: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.responsesRef.snapshots(),
      builder: (_, snapshot) {
        /// while fetching show circularProgressIndicator
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          );
        }

        answers = snapshot.data['answers'];

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: ResponseTile(
                    name: snapshot.data['name'],
                    email: snapshot.data['email'],
                    createdOn: snapshot.data['createdOn'],
                    maxMarks: widget.maxMarks,
                    receivedMarks:
                        snapshot.data['receivedMarks'] ?? totalReceivedMarks,
                  ),
                ),
                SizedBox(height: 10),
                // Divider(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: widget.questionsRef.snapshots(),
                    builder: (context, snapshot) {
                      /// while fetching show circularProgressIndicator
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      /// if response has no answer
                      if (snapshot.data.documents.isEmpty) {
                        return Center(
                          child: Text('No Answers'),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (_, index) {
                            Question question = Question.fromDocument(
                                snapshot.data.documents[index].data);
                            if (answers['${question.id}'] ==
                                question.correctAnswer)
                              totalReceivedMarks += question.marks;
                            return AnswerResponse(
                              qNo: index + 1,
                              qText: question.qText,
                              maxMarks: question.marks,
                              correctAnswer: question.correctAnswer,
                              givenAnswer: answers['${question.id}'],
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Response widget
class AnswerResponse extends StatelessWidget {
  final String correctAnswer, givenAnswer, qText;
  final int maxMarks, qNo;

  const AnswerResponse(
      {@required this.correctAnswer,
      @required this.maxMarks,
      @required this.qNo,
      @required this.givenAnswer,
      @required this.qText});

  @override
  Widget build(BuildContext context) {
    int marks = correctAnswer == givenAnswer ? maxMarks : 0;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: const Color(0xffffffff),
          border: Border.all(width: 1.0, color: const Color(0xff707070)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('$qNo.'),
                Expanded(
                  child: Text(
                    qText ?? 'No Question',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                correctAnswer ?? 'No Correct answer was provided',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                givenAnswer ?? 'Not Answered',
                style: TextStyle(
                    color: correctAnswer == givenAnswer
                        ? Colors.green
                        : Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Marks '),
                  Text(
                    '$marks/',
                    style: TextStyle(
                        color: marks == maxMarks ? Colors.green : Colors.red),
                  ),
                  Text('$maxMarks')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
