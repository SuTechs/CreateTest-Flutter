import 'package:createtest/data/question.dart';
import 'package:createtest/widgets/creatingQuestion/QuestionBox.dart';
import 'package:flutter/material.dart';

class CreateMCQ extends StatefulWidget {
  final McqQuestion mcqQuestion;
  final int qNo;
  final void Function(McqQuestion) onDone;
  final void Function(String) onDelete;

  const CreateMCQ(
      {@required this.mcqQuestion,
      @required this.qNo,
      @required this.onDone,
      @required this.onDelete});

  @override
  _CreateMCQState createState() => _CreateMCQState();
}

class _CreateMCQState extends State<CreateMCQ> {
  bool isAddingOption = false;
  bool isEditing;
  String newQtext;
  int marks;

  Widget getOptions(List<String> optionsText) {
    if (optionsText.isEmpty) return Text('');

    List<Option> optionsWidgets = [];

    for (String optionText in optionsText) {
      optionsWidgets.add(Option(
        initialOptionText: optionText,
        onDone: (newOptionText) {
          widget.mcqQuestion.options[optionsText.indexOf(optionText)] =
              newOptionText;
          widget.onDone(widget.mcqQuestion);
        },
        onChange: (newCorrectAnswer) {
          setState(() {
            widget.mcqQuestion.correctAnswer = newCorrectAnswer;
            isEditing = true;
          });
        },
        onRemove: () {
          widget.mcqQuestion.options.removeAt(optionsText.indexOf(optionText));
          widget.onDone(widget.mcqQuestion);
          optionsWidgets.removeAt(optionsText.indexOf(optionText));

          setState(() {});
        },
        groupValue: widget.mcqQuestion.correctAnswer,
      ));
    }

    return Column(children: optionsWidgets);
  }

  @override
  void initState() {
    super.initState();
    newQtext = widget.mcqQuestion.qText;
    marks = widget.mcqQuestion.marks;
  }

  @override
  Widget build(BuildContext context) {
    return QuestionBox(
      isEditing: isEditing ?? widget.mcqQuestion.qText == null ? true : false,
      qNo: widget.qNo,
      qText: widget.mcqQuestion.qText,
      marks: widget.mcqQuestion.marks,
      onDone: () {
        widget.mcqQuestion.marks = marks;
        widget.mcqQuestion.qText = newQtext;
        widget.onDone(widget.mcqQuestion);
        setState(() {
          isEditing = false;
        });
      },
      onDelete: () {
        widget.onDelete(widget.mcqQuestion.id);
      },
      onQchange: (v) {
        newQtext = v;
        setState(() {
          isEditing = true;
        });
      },
      onMarksChange: (newMarks) {
        marks = newMarks;
      },
      child: Column(
        children: [
          getOptions(widget.mcqQuestion.options),
          Visibility(
            visible: isAddingOption,
            child: EnterOptionTile(
              onDone: (newOption) {
                widget.mcqQuestion.options.add(newOption);
                widget.onDone(widget.mcqQuestion);

                setState(() {
                  isAddingOption = false;
                });
              },
              onRemove: () {
                setState(() {
                  isAddingOption = false;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: !isAddingOption,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isAddingOption = true;
                });
              },
              child: Text('Add Options'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Option widget
class Option extends StatefulWidget {
  final void Function(String) onDone;
  final void Function(String) onChange;
  final void Function() onRemove;
  final String groupValue;
  final String initialOptionText;

  const Option({
    @required this.onDone,
    @required this.onChange,
    @required this.onRemove,
    @required this.groupValue,
    this.initialOptionText,
  });

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  bool isEditing;
  String optionText;
  @override
  void initState() {
    super.initState();
    optionText = widget.initialOptionText;

    isEditing = optionText == null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: isEditing
              ? EnterOptionTile(
                  onRemove: () {
                    widget.onRemove();
                    setState(() {
                      isEditing = false;
                    });
                  },
                  initialValue: optionText,
                  onDone: (value) {
                    widget.onDone(value);
                    optionText = value;
                    isEditing = false;
                    setState(() {});
                  },
                )
              : OptionBoolTile(
                  value: optionText,
                  groupValue: widget.groupValue,
                  onTextEditTap: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  onChanged: (value) {
                    //setState(() {});
                    widget.onChange(value);
                  },
                ),
        ),
      ],
    );
  }
}

/// Enter Option Text Field
class EnterOptionTile extends StatelessWidget {
  final String initialValue;
  final void Function(String) onDone;
  final void Function() onRemove;

  const EnterOptionTile(
      {this.initialValue, @required this.onDone, @required this.onRemove});

  @override
  Widget build(BuildContext context) {
    String optionText = initialValue ?? '';

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.done,
          ),
          onPressed: () {
            if (optionText.trim().length > 0) onDone(optionText);
          },
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            autofocus: true,
            initialValue: initialValue,
            decoration: InputDecoration(
              hintText: 'Option',
            ),
            maxLines: null,
            textInputAction: TextInputAction.done,
            onChanged: (v) {
              optionText = v;
            },
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () {
            onRemove();
          },
        ),
      ],
    );
  }
}

/// Option Bool tile
class OptionBoolTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final void Function(String) onChanged;
  final void Function() onTextEditTap;

  const OptionBoolTile(
      {@required this.value,
      @required this.groupValue,
      @required this.onChanged,
      @required this.onTextEditTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            activeColor: Colors.green,
            value: value,
            groupValue: groupValue,
            onChanged: (newValue) {
              onChanged(newValue);
            },
            title: InkWell(
                onTap: () {
                  onTextEditTap();
                },
                child: Text('$value')),
          ),
        ),
      ],
    );
  }
}
