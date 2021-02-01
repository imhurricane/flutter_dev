
import 'dart:math';

import 'package:flutter/widgets.dart';

class LeftToRightPageRoute extends PageRouteBuilder {
  final Widget newPage;

  LeftToRightPageRoute(this.newPage)
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    newPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(animation),
          child: child,
        ),
  );
}


class CustomPageRoute extends PageRouteBuilder {
  final Widget currentPage;
  final Widget newPage;

  CustomPageRoute(this.currentPage, this.newPage)
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    currentPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0, 0),
                end: const Offset(0, -1),
              ).animate(animation),
              child: currentPage,
            ),
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset(0, 0),
              ).animate(animation),
              child: newPage,
            )
          ],
        ),
  );
}

class CirclePageRoute extends PageRoute {

  //Navigator.of(context).push(CirclePageRoute(builder: (context) {return PageB();}));

  CirclePageRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: CirclePath(animation.value),
          child: child,
        );
      },
      child: builder(context),
    );
  }
}

class CirclePath extends CustomClipper<Path> {
  CirclePath(this.value);

  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    double radius =
        value * sqrt(size.height * size.height + size.width * size.width);
    path.addOval(Rect.fromLTRB(
        size.width - radius, -radius, size.width + radius, radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}