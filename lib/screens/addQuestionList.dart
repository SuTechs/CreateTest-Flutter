import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:createtest/data/question.dart';
import 'package:createtest/widgets/creatingQuestion/createMCQ.dart';
import 'package:createtest/widgets/creatingQuestion/createText.dart';
import 'package:createtest/widgets/creatingQuestion/createUpload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/creatingQuestion/PopUpButtonAddQ.dart';

class AddQuestionList extends StatefulWidget {
  final CollectionReference questionsCollectionRef;
  AddQuestionList({this.questionsCollectionRef});

  @override
  _AddQuestionListState createState() => _AddQuestionListState();
}

class _AddQuestionListState extends State<AddQuestionList> {
  List<Widget> questionsList = [];
  bool keyboardIsOpened = false;
  void onDone(dynamic v) {
    print('Question is ${v.toJson()} and id = ${v.id}');
    widget.questionsCollectionRef
        .document('${v.id}')
        .setData(v.toJson())
        .then((value) => print('Success Su Mit'));
  }

  void onDelete(String id) {
    print('Delete q of $id id');
    widget.questionsCollectionRef.document(id).delete().then(
      (value) {
        print('Question of id = $id deleted');
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Question Deleted'),
        ));
      },
    );
  }

  void onNewQuestionButtonPressed(String v) {
    String id = '${DateTime.now().millisecondsSinceEpoch}';
    void onComplete(dynamic v) {
      if (v.qText != null) onDone(v);
      Navigator.pop(context);
    }

    Widget newQuestionWidget;
    if (v == 'MCQ')
      newQuestionWidget = CreateMCQ(
        qNo: 0,
        onDelete: null,
        onDone: onComplete,
        mcqQuestion: McqQuestion(
          options: [],
          id: id,
        ),
      );
    else if (v == 'Upload')
      newQuestionWidget = CreateUpload(
        qNo: 0,
        onDelete: null,
        onDone: onComplete,
        uploadQuestion: UploadQuestion(
          id: id,
        ),
      );
    else
      newQuestionWidget = CreateText(
        qNo: 0,
        onDone: onComplete,
        onDelete: null,
        textQuestion: TextQuestion(
          id: id,
        ),
      );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => Dialog(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [newQuestionWidget],
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        setState(() {
          keyboardIsOpened = visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !keyboardIsOpened,
        child: PopUpButton(onPressed: onNewQuestionButtonPressed),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.questionsCollectionRef.snapshots(),
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
              child: Text('Add Question'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.documents.length + 1,
            itemBuilder: (context, index) {
              /// creating widget at end of questions
              if (index == snapshot.data.documents.length)
                return Container(
                  height: 200,
                );

              /// creating Question
              else {
                var v = snapshot.data.documents[index].data;
                if (v['type'] == 'MCQ')
                  return CreateMCQ(
                    qNo: index + 1,
                    mcqQuestion: McqQuestion.fromDocument(v),
                    onDone: onDone,
                    onDelete: onDelete,
                  );
                else if (v['type'] == 'Text')
                  return CreateText(
                    qNo: index + 1,
                    onDone: onDone,
                    onDelete: onDelete,
                    textQuestion: TextQuestion.fromDocument(v),
                  );

                // if (v['type'] == 'Upload')
                else
                  return CreateUpload(
                    qNo: index + 1,
                    onDelete: onDelete,
                    onDone: onDone,
                    uploadQuestion: UploadQuestion.fromDocument(v),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

/// A base class to handle the subscribing events
class KeyboardVisibilitySubscriber {
  /// Called when a keyboard visibility event occurs
  /// Is only called when the state changes
  /// The [visible] parameter reflects the new visibility
  final Function(bool visible) onChange;

  /// Called when the keyboard appears
  final Function onShow;

  /// Called when the keyboard closes
  final Function onHide;

  /// Constructs a new [KeyboardVisibilitySubscriber]
  KeyboardVisibilitySubscriber({this.onChange, this.onShow, this.onHide});
}

/// The notification class that handles all information
class KeyboardVisibilityNotification {
  static const EventChannel _keyboardVisibilityStream =
      const EventChannel('github.com/adee42/flutter_keyboard_visibility');
  static Map<int, KeyboardVisibilitySubscriber> _list =
      Map<int, KeyboardVisibilitySubscriber>();
  static StreamSubscription _keyboardVisibilitySubscription;
  static int _currentIndex = 0;

  /// The current state of the keyboard visibility. Can be used without subscribing
  bool isKeyboardVisible = false;

  /// Constructs a new [KeyboardVisibilityNotification]
  KeyboardVisibilityNotification() {
    _keyboardVisibilitySubscription ??= _keyboardVisibilityStream
        .receiveBroadcastStream()
        .listen(onKeyboardEvent);
  }

  /// Internal function to handle native code channel communication
  void onKeyboardEvent(dynamic arg) {
    isKeyboardVisible = (arg as int) == 1;

    // send a message to all subscribers notifying them about the new state
    _list.forEach((subscriber, s) {
      try {
        if (s.onChange != null) {
          s.onChange(isKeyboardVisible);
        }
        if ((s.onShow != null) && isKeyboardVisible) {
          s.onShow();
        }
        if ((s.onHide != null) && !isKeyboardVisible) {
          s.onHide();
        }
      } catch (_) {}
    });
  }

  /// Subscribe to a keyboard visibility event
  /// [onChange] is called when a change of the visibility occurs
  /// [onShow] is called when the keyboard appears
  /// [onHide] is called when the keyboard disappears
  /// Returns a subscribing id that can be used to unsubscribe
  int addNewListener(
      {Function(bool) onChange, Function onShow, Function onHide}) {
    _list[_currentIndex] = KeyboardVisibilitySubscriber(
        onChange: onChange, onShow: onShow, onHide: onHide);
    return _currentIndex++;
  }

  /// Subscribe to a keyboard visibility event using a subscribing class [subscriber]
  /// Returns a subscribing id that can be used to unsubscribe
  int addNewSubscriber(KeyboardVisibilitySubscriber subscriber) {
    _list[_currentIndex] = subscriber;
    return _currentIndex++;
  }

  /// Unsubscribe from the keyboard visibility events
  /// [subscribingId] has to contain an id previously returned on add
  void removeListener(int subscribingId) {
    _list.remove(subscribingId);
  }

  /// Internal function to clear class on dispose
  dispose() {
    if (_list.length == 0) {
      _keyboardVisibilitySubscription?.cancel()?.catchError((e) {});
      _keyboardVisibilitySubscription = null;
    }
  }
}
