import 'package:flutter/material.dart';

class FloatButton extends StatefulWidget {
  final GestureTapCallback onPressed;
  final bool isPulseAnimator;
  final String value;
  final IconData icon;
  final Color iconColor;

  const FloatButton({
    Key key,
    @required this.onPressed,
    @required this.value,
    this.icon,
    this.iconColor = Colors.white,
    this.isPulseAnimator = false,
  }) : super(key: key);

  @override
  _FloatButtonState createState() => _FloatButtonState();
}

@override
class _FloatButtonState extends State<FloatButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.lightBlueAccent,
      splashColor: Colors.lightBlue[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPulaeAnimator(),
            buildSizedBox(),
            buildTextAnimator(),
          ],
        ),
      ),
      onPressed: widget.onPressed,
      //点击事件
      shape: const StadiumBorder(), //添加圆角
    );
  }

  buildPulaeAnimator() {
    if (null != widget.icon) {
      return RotatedBox(
        //将icon进行了旋转
        quarterTurns: 1,
        child: Icon(
          widget.icon,
          color: widget.iconColor,
        ),
      );
    } else {
      return Container(
        height: 20,
      );
    }
  }

  buildTextAnimator() {
    if (widget.isPulseAnimator) {
      return PulseAnimator(
        /// 动画效果
        child: Text(
          widget.value,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Text(
        widget.value,
        style: TextStyle(color: Colors.white),
      );
    }
  }

  buildSizedBox() {
    if(null != widget.icon){
      return SizedBox(
        width: 8,
      );
    }else{
      return Container(height: 20,);
    }
  }
}

class PulseAnimator extends StatefulWidget {
  final Widget child;

  const PulseAnimator({Key key, this.child}) : super(key: key);

  @override
  _PulseAnimatorState createState() => _PulseAnimatorState();
}

class _PulseAnimatorState extends State<PulseAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.5, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}
