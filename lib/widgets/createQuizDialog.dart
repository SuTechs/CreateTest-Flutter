import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:createtest/data/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

class CreateQuizDialog extends StatefulWidget {
  @override
  _CreateQuizDialogState createState() => _CreateQuizDialogState();
}

class _CreateQuizDialogState extends State<CreateQuizDialog> {
  final _formKey = GlobalKey<FormState>();
  String name, desc;
//  String  pass;
  bool nameAutoValidate = false;
  bool descAutoValidate = false;
//  bool passAutoValidate = false;
  bool isLoading = false;

  void createQuiz(Quiz q) {
    final _testRef = Firestore.instance.collection("Tests");

    _testRef.document('${q.id}').setData(q.toJson()).then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Color(0xffFAEEEE),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// Name Text Field
                          TextFormField(
                            autofocus: true,
                            autovalidate: nameAutoValidate,
                            onChanged: (v) {
                              setState(() {
                                nameAutoValidate = true;
                              });
                            },
                            decoration: InputDecoration(hintText: 'Name'),
                            maxLength: 30,
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'Name can\'t be empty';
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              if (value.trim().isNotEmpty)
                                FocusScope.of(context).nextFocus();
                              else
                                setState(() {
                                  nameAutoValidate = true;
                                });
                            },
                            onSaved: (value) => name = value.trim(),
                          ),

                          /// Description Text Field
                          TextFormField(
                            autovalidate: descAutoValidate,
                            onChanged: (v) {
                              setState(() {
                                descAutoValidate = true;
                              });
                            },
                            decoration:
                                InputDecoration(hintText: 'Description'),
                            maxLength: 60,
                            maxLines: 2,
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'Description can\'t be empty';
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              if (value.trim().isNotEmpty)
                                FocusScope.of(context).unfocus();
                              else
                                setState(() {
                                  descAutoValidate = true;
                                });
                            },
                            onSaved: (value) => desc = value.trim(),
                          ),

//                          /// Password Text Field
//                          TextFormField(
//                            inputFormatters: [
//                              WhitelistingTextInputFormatter.digitsOnly
//                            ],
//                            autovalidate: passAutoValidate,
//                            onChanged: (v) {
//                              setState(() {
//                                passAutoValidate = true;
//                              });
//                            },
//                            decoration: InputDecoration(hintText: 'Password'),
//                            keyboardType: TextInputType.number,
//                            validator: (value) {
//                              if (value.trim().isEmpty ||
//                                  value.trim().length > 4 ||
//                                  value.trim().length < 4)
//                                return 'Password should be 4 digit long';
//                              return null;
//                            },
//                            textInputAction: TextInputAction.next,
//                            onFieldSubmitted: (value) {
//                              if (value.trim().isNotEmpty &&
//                                  value.trim().length == 4 &&
//                                  _formKey.currentState.validate())
//                                FocusScope.of(context).unfocus();
//                              else
//                                setState(() {
//                                  passAutoValidate = true;
//                                });
//                            },
//                            onSaved: (value) => pass = value.trim(),
//                          ),

                          /// Create Button
                          Center(
                            child: RaisedButton(
                              color: Colors.pink,
                              child: Text(
                                "Set Duration",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  Duration resultingDuration =
                                      await showDurationPicker(
                                    context: context,
                                    initialTime: new Duration(minutes: 30),
                                  );

                                  if (resultingDuration != null) {
                                    createQuiz(Quiz(
                                      durationMinutes:
                                          resultingDuration.inMinutes,
                                      id: randomNumeric(6),
                                      name: name,
                                      description: desc,
                                      createdOn: Timestamp.now(),
//                                      password: pass,
                                    ));

                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
