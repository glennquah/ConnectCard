import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

// ShowcaseView is a widget that wraps around any widget to display a showcase
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
      titlePadding: const EdgeInsets.all(5),
      tooltipPadding: const EdgeInsets.all(10),
      descriptionPadding: const EdgeInsets.all(5),
      targetPadding: const EdgeInsets.all(13),
      targetShapeBorder: shapeBorder,
      child: child,
    );
  }
}
