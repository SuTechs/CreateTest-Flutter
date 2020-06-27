import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResponseTile extends StatelessWidget {
  final String name, email;
  final int maxMarks, receivedMarks;
  final Timestamp createdOn;

  const ResponseTile(
      {@required this.name,
      @required this.email,
      @required this.maxMarks,
      @required this.receivedMarks,
      @required this.createdOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 15),
      height: 78.0,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xff78849e),
                  height: 1.5714285714285714,
                ),
              ),
              Text(
                '${createdOn.toDate().day}-${createdOn.toDate().month}-${createdOn.toDate().year}   ${createdOn.toDate().hour}:${createdOn.toDate().minute}',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color(0xff8295be),
                  height: 2.2,
                ),
              ),
            ],
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: const Color(0xffefe1e1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$receivedMarks',
                  style: TextStyle(
                    fontSize: 19,
                    color: const Color(0xff05a711),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 5,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                ),
                Text(
                  '$maxMarks',
                  style: TextStyle(
                    fontSize: 19,
                    color: const Color(0xfff30e14),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
