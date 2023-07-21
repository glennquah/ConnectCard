import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseView extends StatelessWidget {
  const ShowcaseView(
      {Key? key,
      required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      title: title,
      description: description,
      titlePadding: EdgeInsets.all(5),
      tooltipPadding: EdgeInsets.all(10),
      descriptionPadding: EdgeInsets.all(5),
      targetPadding: EdgeInsets.all(13),
      targetShapeBorder: shapeBorder,
      child: child,
    );
  }
}
