import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

/// 变形
abstract class Deform {
  const Deform();

  Widget menuDeform(Widget menu, double aniValue, double menuWidth);

  Widget menuTranslate(
      Widget menu, double menuWidth, double width, double aniTranslate);

  Widget homeDeform(Widget home, double aniValue);

  Widget homeTranslate(Widget home, double aniTranslate);

  double moving(Offset delta, double width, height);

  double calculateTranslate(aniPercent, width, height);
}

class CubeDeform extends Deform {
  final double endAngle;

  final bool left;

  const CubeDeform({this.left = true, this.endAngle = pi / 2.2});

  @override
  Widget homeDeform(Widget home, double aniValue) {
    if (left) {
      return Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, -0.001)
          ..rotateY(endAngle * aniValue),
        // ..setEntry(3, 2, 0.001)
        // ..rotateY(pi / -2 * _animation.value),
        child: home,
      );
    } else {
      return Transform(
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(endAngle * aniValue),
        // ..setEntry(3, 2, 0.001)
        // ..rotateY(pi / -2 * _animation.value),
        child: home,
      );
    }
  }

  @override
  Widget menuDeform(Widget menu, double aniValue, menuWidth) {
    if (left) {
      return Transform(
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(pi / 2 - pi / 2 * aniValue),
        child: menu,
      );
    } else {
      return Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, -0.001)
          ..rotateY(pi / 2 - pi / 2 * aniValue),
        child: menu,
      );
    }
  }

  @override
  Widget homeTranslate(Widget home, double aniTranslate) {
    return Transform.translate(
      offset: Offset((left ? 1 : -1) * aniTranslate, 0),
      child: home,
    );
  }

  @override
  Widget menuTranslate(
      Widget menu, double menuWidth, double width, double aniTranslate) {
    return Transform.translate(
      offset: Offset(left ? aniTranslate - menuWidth : width - aniTranslate, 0),
      child: menu,
    );
  }

  @override
  double moving(Offset delta, double width, height) {
    if (delta.dy < 0.5) {
      return (left ? 1 : -1) * delta.dx / width;
    }
    return 0;
  }

  @override
  double calculateTranslate(aniPercent, width, height) {
    return aniPercent * width;
  }
}
