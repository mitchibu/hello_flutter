import 'package:flutter/material.dart';

class SlideTransitionRoute<T> extends MaterialPageRoute<T> {
	SlideTransitionRoute({
		WidgetBuilder builder,
	}): super(builder: builder);

	@override
	Widget buildTransitions(BuildContext context,
		Animation<double> animation,
		Animation<double> secondaryAnimation,
		Widget child)
	{
		if (settings.isInitialRoute)
			return child;

		return new SlideTransition(
			position: new Tween(
				begin: const Offset(1.0, 0.0),
				end: Offset.zero,
			)
				.animate(
				new CurvedAnimation(
					parent: animation,
					curve: Curves.ease,
				)
			),
			child: child,
		);
	}

	@override Duration get transitionDuration => const Duration(milliseconds: 1000);
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget enterWidget;
  final Widget exitWidget;

  SlideLeftRoute({this.enterWidget, this.exitWidget}) : super(
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, Animation<double> secondaryAnimation) => enterWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => Stack(
      children: <Widget>[
        SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(-1.0, 0.0),
            ).animate(animation),
            child: exitWidget),
        SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: enterWidget)
      ],
    ));
}

class SlideLeftRoute2 extends PageTransitionRouteBuilder {
  SlideLeftRoute2({Widget enterWidget, Widget exitWidget}) : super(
    enterWidget: enterWidget,
    enterTransition: SlideTransitionBuilder(from: Offset(1.0, 0.0), to: Offset.zero),
//    enterTransition: FadeTransitionBuilder(),
    exitWidget: exitWidget,
//    exitTransition: SlideTransitionBuilder(from: Offset.zero, to: Offset(-1.0, 0.0)),
    exitTransition: FadeTransitionBuilder(),
  );
}

class PageTransitionRouteBuilder extends PageRouteBuilder {
  final Widget enterWidget;
  final Widget exitWidget;

  PageTransitionRouteBuilder({this.enterWidget, @required TransitionBuilder enterTransition, this.exitWidget, @required TransitionBuilder exitTransition}) : super(
    transitionDuration: Duration(milliseconds: 1000),
    pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => Stack(
      children: <Widget>[
        exitTransition.build(animation, exitWidget),
        enterTransition.build(animation, enterWidget),
      ],
    ),
  );
}

abstract class TransitionBuilder {
  Widget build(Animation animation, Widget widget);
}

class SlideTransitionBuilder extends TransitionBuilder {
  final Offset from;
  final Offset to;

  SlideTransitionBuilder({this.from, this.to});

  @override
  Widget build(Animation animation, Widget widget) => SlideTransition(
    position: new Tween<Offset>(
      begin: from,
      end: to,
    ).animate(animation),
    child: widget);
}

class FadeTransitionBuilder extends TransitionBuilder {
  @override
  Widget build(Animation animation, Widget widget) => FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut, reverseCurve: Curves.easeIn),
    child: widget);
}
