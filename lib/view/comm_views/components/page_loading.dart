
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PageLoading extends StatefulWidget {

  final double size;
  final Color iconColor;
  final String text;
  final TextStyle textStyle;
  final bool isHide;
  final EdgeInsetsGeometry spinKitPadding;
  final EdgeInsetsGeometry textPadding;

  PageLoading({
    this.size=50.0,
    this.text="正在加载中···",
    this.iconColor=Colors.grey,
    this.textStyle,
    this.isHide=false,
    this.spinKitPadding= const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
    this.textPadding=const EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
});
  @override
  _PageLoadingState createState() => _PageLoadingState();
}

class _PageLoadingState extends State<PageLoading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.isHide,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: widget.spinKitPadding,
            child: Center(
              child: SpinKitFadingCircle(
                color: widget.iconColor,
                size: widget.size,
              ),
            ),
          ),
          Padding(
            padding: widget.textPadding,
            child: Center(
              child: Text(widget.text,style: widget.textStyle,),
            ),
          ),
        ],
      ),
    );
  }
}