import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';

class PopUpButton extends StatefulWidget {
  final void Function(String) onPressed;

  const PopUpButton({@required this.onPressed});

  @override
  _PopUpButtonState createState() => _PopUpButtonState();
}

class _PopUpButtonState extends State<PopUpButton> {
  bool _isShowDial = false;
  @override
  Widget build(BuildContext context) {
    return SpeedDialMenuButton(
      //if needed to close the menu after clicking sub-FAB
      isShowSpeedDial: _isShowDial,
      //manually open or close menu
      updateSpeedDialStatus: (isShow) {
        //return any open or close change within the widget
        this._isShowDial = isShow;
      },
      //general init
      isMainFABMini: true,
      isSpeedDialFABsMini: false,

      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          mini: true,
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
          onPressed: () {},
          closeMenuChild: Icon(Icons.close),
          closeMenuForegroundColor: Colors.white,
          closeMenuBackgroundColor: Colors.green),
      floatingActionButtonWidgetChildren: [
        FloatingActionButton(
          heroTag: 'su',
          child: Text('MCQ'),
          onPressed: () {
            //if need to toggle menu after click

            setState(() {
              _isShowDial = !_isShowDial;
            });
            widget.onPressed('MCQ');
          },
          backgroundColor: Colors.black,
        ),
        FloatingActionButton(
          heroTag: 'su1',
          child: Text('Text'),
          onPressed: () {
            //if need to toggle menu after click
            setState(() {
              _isShowDial = !_isShowDial;
            });
            widget.onPressed('Text');
          },
          backgroundColor: Colors.black,
        ),
        FloatingActionButton(
          heroTag: 'su2',
          child: Text('Upload'),
          onPressed: () {
            //if need to toggle menu after click
            setState(() {
              _isShowDial = !_isShowDial;
            });

            /// Disabled Upload Button
            //widget.onPressed('Upload');
          },
          backgroundColor: Colors.black,
        ),
      ],

      paddingBtwSpeedDialButton: 10.0,
    );
  }
}
