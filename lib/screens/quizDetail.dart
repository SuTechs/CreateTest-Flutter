import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:createtest/data/quiz.dart';
import 'package:createtest/screens/responseList.dart';
import 'package:flutter/material.dart';
import 'addQuestionList.dart';

class QuizDetail extends StatelessWidget {
  final _testRef = Firestore.instance.collection("Tests");

  final Quiz quiz;

  QuizDetail({@required this.quiz});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                titleSpacing: 0,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    padding: EdgeInsets.only(left: 20),
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xff454F63),
                    ),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Row(
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Deleting this Quiz...'),
                          ],
                        ),
                      ));
                      _testRef
                          .document(quiz.id)
                          .delete()
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                ],
                bottom: TabBar(
                  unselectedLabelColor: const Color(0xff0F0E0F),
                  labelColor: const Color(0xff06ff1f),
                  indicatorColor: const Color(0xff06ff1f),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Text(
                      'Question',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Response',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            quiz.name,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 22,
                              color: const Color(0xff454f63),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${quiz.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xff454f63),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
//                          Text(
//                            'Pass: ${quiz.password}',
//                            style: TextStyle(
//                              fontSize: 12,
//                              color: const Color(0xff454f63),
//                              fontWeight: FontWeight.w600,
//                            ),
//                            textAlign: TextAlign.center,
//                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                floating: true,
                snap: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              AddQuestionList(
                questionsCollectionRef:
                    _testRef.document(quiz.id).collection('Questions'),
              ),
              ResponsesList(
                questionsRef:
                    _testRef.document(quiz.id).collection('Questions'),
                responsesRef:
                    _testRef.document(quiz.id).collection('Responses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Widget build(BuildContext context) {
//  return DefaultTabController(
//    length: 2,
//    child: Scaffold(
//      appBar: AppBar(
//        titleSpacing: 0,
//        backgroundColor: Colors.white,
//        automaticallyImplyLeading: false,
//        actions: [
//          IconButton(
//            icon: Icon(
//              Icons.more_vert,
//              color: Color(0xff454F63),
//            ),
//            onPressed: () {},
//          )
//        ],
//        bottom: TabBar(
//          unselectedLabelColor: const Color(0xff0F0E0F),
//          labelColor: const Color(0xff06ff1f),
//          indicatorColor: const Color(0xff06ff1f),
//          indicatorSize: TabBarIndicatorSize.label,
//          tabs: [
//            Text(
//              'Question',
//              style: TextStyle(
//                fontFamily: 'Poppins',
//                fontSize: 16,
//              ),
//              textAlign: TextAlign.center,
//            ),
//            Text(
//              'Response',
//              style: TextStyle(
//                fontFamily: 'Poppins',
//                fontSize: 16,
//              ),
//              textAlign: TextAlign.center,
//            ),
//          ],
//        ),
//        title: Padding(
//          padding: const EdgeInsets.only(left: 5),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Text(
//                'Math Test Qualification...',
//                softWrap: true,
//                maxLines: 1,
//                style: TextStyle(
//                  fontSize: 22,
//                  color: const Color(0xff454f63),
//                  fontWeight: FontWeight.w600,
//                ),
//                textAlign: TextAlign.center,
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    'ID: 123456',
//                    style: TextStyle(
//                      fontSize: 12,
//                      color: const Color(0xff454f63),
//                      fontWeight: FontWeight.w600,
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                  Text(
//                    'Pass: 0055',
//                    style: TextStyle(
//                      fontSize: 12,
//                      color: const Color(0xff454f63),
//                      fontWeight: FontWeight.w600,
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ],
//              ),
//            ],
//          ),
//        ),
//      ),
//      body: TabBarView(
//        children: [
//          Icon(Icons.directions_car),
//          ListView(
//            children: [for (var i = 0; i < 20; i++) ResponseTile()],
//          ),
//        ],
//      ),
//    ),
//  );
//}
