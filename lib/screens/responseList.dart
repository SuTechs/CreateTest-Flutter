import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:createtest/screens/responseDetails.dart';
import 'package:flutter/material.dart';
import 'package:createtest/widgets/responseTile.dart';

class ResponsesList extends StatefulWidget {
  final CollectionReference questionsRef;
  final CollectionReference responsesRef;

  const ResponsesList(
      {@required this.questionsRef, @required this.responsesRef});

  @override
  _ResponsesListState createState() => _ResponsesListState();
}

class _ResponsesListState extends State<ResponsesList> {
  int maxMarks;

  void calculateMaxMarks() async {
    var qDocuments = await widget.questionsRef.getDocuments();
    int totalMarks = 0;
    for (var documents in qDocuments.documents) {
      totalMarks += documents.data['marks'];
    }

    setState(() {
      maxMarks = totalMarks;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateMaxMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.responsesRef
              .orderBy("createdOn", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            /// while fetching show circularProgressIndicator
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              );
            }

            /// if quiz has no question
            if (snapshot.data.documents.isEmpty) {
              return Center(
                child: Text('No Responses Received'),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, index) {
                  //snapshot.data.documents[index].documentID

                  return GestureDetector(
                    child: Hero(
                      tag: 'ResponseTile$index',
                      child: ResponseTile(
                        name: snapshot.data.documents[index].data['name'],
                        email: snapshot.data.documents[index].data['email'],
                        createdOn:
                            snapshot.data.documents[index].data['createdOn'],
                        receivedMarks: snapshot
                                .data.documents[index].data['receivedMarks'] ??
                            0,
                        maxMarks: maxMarks,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResponseDetail(
                                    heroTag: 'ResponseTile$index',
                                    questionsRef: widget.questionsRef,
                                    responsesRef: widget.responsesRef.document(
                                        snapshot
                                            .data.documents[index].documentID),
                                    maxMarks: maxMarks,
                                  )));
                    },
                  );
                });
          }),
    );
  }
}
