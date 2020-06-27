import 'package:createtest/data/quiz.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class QuizTile extends StatelessWidget {
  final Quiz quiz;
  final void Function(String) onPressed;

  const QuizTile({@required this.quiz, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(quiz.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        quiz.description,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xff78849e),
                          height: 1.5714285714285714,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        /// formatting timeStamp to timeAgo
                        "${timeago.format(quiz.createdOn.toDate())}",
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xff8295be),
                          height: 2.2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
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
//                    Text(
//                      'Pass: ${quiz.password}',
//                      style: TextStyle(
//                        fontSize: 12,
//                        color: const Color(0xff454f63),
//                        fontWeight: FontWeight.w600,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
                    Text(
                      'Time: ${quiz.durationMinutes}m',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xff454f63),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
