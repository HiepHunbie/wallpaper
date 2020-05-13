import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/utils/Colors.dart';

class ButtonTop extends StatelessWidget {
  final bool typeClick;
  final VoidCallback onCloseSelected;
  final String imagePath;
  final String text;

  const ButtonTop({this.typeClick, this.onCloseSelected, this.imagePath, this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(6.0),
          side: BorderSide(color: Color(TAB_HIDE))),
      onPressed: () => onCloseSelected,
      color: typeClick?Color(BACK_MAIN):Color(TAB_HIDE),
      padding: EdgeInsets.all(6.0),
      child: Row( // Rep
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 5),
              child: SvgPicture.asset(imagePath,
                  color: Color(WHITE))
          ),
          Text(text,
              style: TextStyle(color: Color(WHITE),
                  fontSize: 13,
                  fontStyle: FontStyle.normal)),

        ],
      ),);
  }
}