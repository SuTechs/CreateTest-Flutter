import 'package:flutter/material.dart';

class QuestionBox extends StatefulWidget {
  final int qNo;
  final String qText;
  final int marks;
  final void Function() onDone, onDelete;
  final void Function(String) onQchange;
  final void Function(int) onMarksChange;
  final bool isEditing;
  final Widget child;

  const QuestionBox({
    this.qNo,
    this.qText,
    this.marks = 0,
    @required this.onDone,
    @required this.onDelete,
    @required this.onQchange,
    @required this.onMarksChange,
    @required this.isEditing,
    @required this.child,
  });

  @override
  _QuestionBoxState createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  int marks;
  bool isEditing;
  @override
  void initState() {
    super.initState();
    marks = widget.marks ?? 0;
    isEditing = widget.isEditing ?? widget.qText == null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: const Color(0xffffffff),
          border: Border.all(width: 1.0, color: const Color(0xff707070)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.qNo == 0 ? '' : '${widget.qNo}  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    autofocus: isEditing,
                    initialValue: widget.qText,
                    decoration: InputDecoration(
                      hintText: 'Enter Question',
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) {
                      widget.onQchange(v);
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: widget.child,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Marks '),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              size: 20,
                            ),
                            onTap: () {
                              setState(() {
                                isEditing = true;
                                marks += 1;
                              });
                              widget.onMarksChange(marks);
                            },
                          ),
                          Text(
                            '$marks',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                            ),
                            onTap: () {
                              setState(() {
                                isEditing = true;
                                if (marks > 0) marks -= 1;
                              });
                              widget.onMarksChange(marks);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  isEditing || widget.isEditing
                      ? GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isEditing = false;
                            });
                            widget.onDone();
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => widget.onDelete(),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
