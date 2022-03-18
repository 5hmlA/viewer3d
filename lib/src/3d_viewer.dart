import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '3d_geometry.dart';
import 'animation_reset.dart';

/**
 * When I wrote this, only God and I understood what I was doing
 * Now, God only knows
 */
const String avatar =
    "https://avatars.githubusercontent.com/u/9412501?s=400&u=87dd2fd8ba87dba6a3f7f46a7043e6e2975b79a6&v=4";

class View3D extends StatefulWidget {
  final double width;
  final double height;
  final double thickness;
  final Color backgroundColor;
  final ResetTarget? resetTarget;
  final Reset? reset;

  //front,back,left,right,top,bottom,
  final List<Widget?>? sides;

  const View3D(
    this.width,
    this.height,
    this.thickness, {
    Key? key,
    this.sides,
    this.backgroundColor = Colors.transparent,
    this.resetTarget,
    this.reset = const ResetNormal(),
  }) : super(key: key);

  View3D.autoReset(
    double width,
    double height,
    double thickness, {
    Key? key,
    List<Widget?>? sides,
    Color backgroundColor = Colors.transparent,
  }) : this(width, height, thickness,
            key: key,
            sides: sides,
            backgroundColor: backgroundColor,
            reset: const ResetElasticOut(),
            resetTarget: const ResetTarget2());

  View3D.me()
      : this(
          260,
          260,
          60,
          sides: [
            ColoredBox(
                color: Colors.primaries[0],
                child: CachedNetworkImage(
                  imageUrl: avatar,
                )),
            ColoredBox(
                color: Colors.primaries[1],
                child: CachedNetworkImage(imageUrl: avatar)),
            ColoredBox(
              color: Colors.primaries[2],
              child: Center(
                child: SizedBox(width: 10, child: Text("我叫江祖赟")),
              ),
            ),
            ColoredBox(
              color: Colors.primaries[3],
              child: Center(
                child: SizedBox(width: 10, child: Text("我叫江祖赟")),
              ),
            ),
            ColoredBox(
              color: Colors.primaries[4],
              child: Center(
                child: Text("我叫江祖赟"),
              ),
            ),
            ColoredBox(
              color: Colors.primaries[5],
              child: Center(
                child: Text("我叫江祖赟"),
              ),
            ),
          ],
          reset: const ResetElasticOut(),
          resetTarget: const ResetTarget2(),
        );

  @override
  State<View3D> createState() => _View3DState();
}

class _View3DState extends State<View3D> with SingleTickerProviderStateMixin {
  Offset tOffset = Offset.zero;
  Duration duration = const Duration(seconds: 2);
  late AnimationController _animationControl;
  Tween<Offset> tween = Tween(begin: Offset.zero, end: const Offset(1, 1));
  List<SizedBox> sides = [];
  Function(double x) curve = (x) => x;

  @override
  void initState() {
    super.initState();
    tween = Tween(begin: Offset.zero, end: const Offset(1, 0));
    _animationControl = AnimationController(vsync: this, duration: duration);
    Widget? getSlide(int index) {
      if (widget.sides == null || index >= widget.sides!.length) {
        return null;
      }
      return widget.sides?[index];
    }

    for (var i = 0; i < 6; i++) {
      var child = getSlide(i) ?? ColoredBox(color: Colors.primaries[i]);
      sides.add(SizedBox(
        width: i <= 3 && i > 1 ? widget.thickness : widget.width,
        height: i >= 4 ? widget.thickness : widget.height,
        child: child,
      ));
    }

    _animationControl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        tOffset = Offset.zero;
      }
    });

    curve = (x) {
      x = Curves.elasticInOut.transform(x);
      if (x > 0.5) {
        x = 1 - x;
      }
      return x / 3;
    };
    _animationControl.reverse(from: 1);
    // _animationControl.repeat();
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Widget child = ColoredBox(
      color: widget.backgroundColor,
      child: AnimatedBuilder(
          animation: _animationControl,
          builder: (context, child) {
            var t = curve(_animationControl.value);
            print('$t');
            tOffset = tween.transform(t);
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, -0.001)
                ..rotateY(tOffset.dx * 2 * pi)
                ..rotateX(-tOffset.dy * 2 * pi),
              child: Center(
                child: Tetrahedron(sides[0], sides[1], sides[2], sides[3],
                    sides[4], sides[5], tOffset),
              ),
            );
          }),
    );
    child = Listener(
      onPointerMove: (event) {
        if (_animationControl.isAnimating) {
          return;
        }
        var delta = event.delta;
        curve = (x) => x;
        if (delta.dx.abs() > delta.dy.abs()) {
          //横向
          if (tOffset.dy == 0 || tOffset.dy == 1) {
            tween = Tween(begin: Offset.zero, end: const Offset(1, 0));
            tOffset += Offset(delta.dx / width, 0);
            _animationControl.value = (tOffset %= 1).dx;
          }
        } else {
          //纵向
          if (tOffset.dx == 0 || tOffset.dx == 1) {
            tween = Tween(begin: Offset.zero, end: const Offset(0, 1));
            tOffset += Offset(0, delta.dy / width);
            // tOffset %= 1;
            _animationControl.value = (tOffset %= 1).dy;
          }
        }
        print('${_animationControl.value}');
      },
      onPointerCancel: (event) {
        _restore();
      },
      onPointerUp: (event) {
        _restore();
      },
      child: child,
    );
    // gyroscopeEvents.listen((GyroscopeEvent event) {
    //   print(event.y*360);
    // });
    // userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    //   print("$tOffset  ${event.x}");
    // });
    return child;
  }

  void _restore() {
    if (_animationControl.isAnimating || widget.resetTarget == null) {
      return;
    }
    if (_animationControl.value / 5 == 0) {
      return;
    }
    // 更接近 0 0.25 0.5 0.75 1
    double target = widget.resetTarget!.calculate(_animationControl.value);

    widget.reset?.reset(
      (curve) {
        this.curve = curve;
      },
      _animationControl,
      duration,
      tween,
      tOffset,
      target,
    );
  }
}
