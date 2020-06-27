import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:createtest/data/quiz.dart';
import 'package:createtest/screens/quizDetail.dart';
import 'package:createtest/widgets/createQuizDialog.dart';
import 'package:createtest/widgets/quizTile.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Test'),
      ),
      body: TestStream(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (_) => CreateQuizDialog());
        },
      ),
    );
  }
}

class TestStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("Tests")
          .orderBy("createdOn", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          );
        }

        if (snapshot.data.documents.isEmpty) {
          return Center(
            child: Text('Add Quiz'),
          );
        }
        return ListView(
          children: [
            for (var test in snapshot.data.documents)
              QuizTile(
                quiz: Quiz.fromDocument(test.data),
                onPressed: (quizId) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizDetail(
                                quiz: Quiz.fromDocument(test.data),
                              )));
                },
              )
          ],
        );
      },
    );
  }
}
