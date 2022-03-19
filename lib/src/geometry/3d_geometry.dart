
import 'dart:math';

import 'package:flutter/widgets.dart';

/// 六面体
class Tetrahedron extends StatelessWidget {
  final SizedBox front;
  final SizedBox back;
  final SizedBox left;
  final SizedBox right;
  final SizedBox top;
  final SizedBox bottom;
  final Offset offset;

  Tetrahedron(this.front, this.back, SizedBox left, this.right, SizedBox top,
      this.bottom, this.offset,
      {Key? key})
      : top = SizedBox(
    width: top.width,
    height: top.height,
    child: Transform(
      transform: Matrix4.rotationX(pi),
      alignment: Alignment.center,
      child: top,
    ),
  ),
        left = SizedBox(
          width: left.width,
          height: left.height,
          child: Transform(
            transform: Matrix4.rotationY(pi),
            alignment: Alignment.center,
            child: left,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [];
    if (offset.dx >= 270 / 360.0) {
      if (offset.dx >= 290 / 360.0) {
        childs.add(buildRight());
        childs.add(front);
      } else {
        childs.add(front);
        childs.add(buildRight());
      }
    } else if (offset.dx < 270 / 360.0 && offset.dx >= 185 / 360.0) {
      if (offset.dx < 235 / 360.0) {
        childs.add(buildRight());
        childs.add(buildBack());
      } else {
        childs.add(buildBack());
        childs.add(buildRight());
      }
    } else if (offset.dx < 185 / 360.0 && offset.dx >= 90 / 360.0) {
      if (offset.dx < 145 / 360.0) {
        childs.add(buildBack());
        childs.add(buildLeft());
      } else {
        childs.add(buildLeft());
        childs.add(buildBack());
      }
    } else if (offset.dx <= 90 / 360.0) {
      if (offset.dx <= 45 / 360.0) {
        childs.add(buildLeft());
        childs.add(front);
      } else {
        childs.add(front);
        childs.add(buildLeft());
      }
    }
    if (offset.dy >= 270 / 360.0) {
      if (offset.dy >= 310 / 360.0) {
        childs.insert(1, buildBottom());
      } else {
        childs.add(buildBottom());
      }
    } else if (offset.dy < 270 / 360.0 && offset.dy >= 175 / 360.0) {
      if (offset.dy < 235 / 360.0) {
        childs.add(buildBottom());
        childs.add(buildBack());
      } else {
        childs.add(buildBack());
        childs.add(buildBottom());
      }
    } else if (offset.dy < 175 / 360.0 && offset.dy >= 90 / 360.0) {
      childs.add(buildBack());
      childs.add(buildTop());
    } else if (offset.dy < 90 / 360.0 && offset.dy > 0 / 360.0) {
      if (offset.dy > 45 / 360.0) {
        childs.add(buildTop());
      } else {
        childs.insert(1, buildTop());
      }
    }

    return Transform(
      transform: Matrix4.translationValues(0, 0, bottom.height! / 2),
      child: Stack(
        children: childs,
      ),
    );
  }

  Transform buildBack() {
    // Transform(
    //   transform: Matrix4.rotationX(pi),
    //   alignment: Alignment.center,
    //   child: back,
    // ),
    // )
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.translationValues(.0, 0, -bottom.height!)
        ..rotateY(offset.dx > 0 ? pi : 0)
        ..rotateX(offset.dy > 0 ? pi : 0),
      child: back,
    );
  }

  Transform buildLeft() {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.identity()..rotateY(pi / 2),
      child: left,
    );
  }

  Transform buildRight() {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.identity()
      // ..setEntry(3, 2, -0.001)
        ..translate(front.width!, .0, 0)
        ..rotateY(pi / 2),
      child: right,
    );
  }

  Transform buildTop() {
    return Transform(
      alignment: Alignment.topCenter,
      transform: Matrix4.identity()..rotateX(-pi / 2),
      child: top,
    );
  }

  Transform buildBottom() {
    return Transform(
      alignment: Alignment.topCenter,
      transform: Matrix4.identity()
        ..translate(.0, front.height!)
        ..rotateX(-pi / 2),
      child: bottom,
    );
  }
}