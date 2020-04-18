import 'package:flutter/cupertino.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget widget;

  SlideRoute({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child,
            ) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              Animation<Offset> custom =
                  Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);

              return SlideTransition(
                position: custom,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
