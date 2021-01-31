import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  final String slideAction;
  SlideRightRoute({this.widget, this.slideAction})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: slideAction == "horizontal"
                  ? const Offset(1, 0.0)
                  : const Offset(0.0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}
