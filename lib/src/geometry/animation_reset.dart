import 'dart:math';

import 'package:flutter/widgets.dart';

abstract class Reset {
  const Reset();
  reset(
    productCurve(Function(double x)),
    AnimationController animationController,
    Duration duration,
    Tween<Offset> tween,
    Offset current,
    double target,
  );
}

class ResetElasticOut extends Reset {
  final Curve curve;

  const ResetElasticOut({this.curve = Curves.elasticOut});

  @override
  reset(
    productCurve(Function(double x)),
    AnimationController animationController,
    Duration duration,
    Tween<Offset> tween,
    Offset current,
    double target,
  ) {
    // value-target
    // value -0/1
    tween.begin = current;
    tween.end =
        Offset(current.dx > 0 ? target : 0, current.dy > 0 ? target : 0);
    productCurve((x) {
      return curve.transform(x);
    });

    double value = animationController.value;
    animationController.duration = duration * (max(value - target, .5));
    animationController.forward(from: 0);
  }
}

class ResetNormal extends Reset {
  const ResetNormal();
  @override
  reset(
    productCurve(Function(double x)),
    AnimationController animationController,
    Duration duration,
    Tween<Offset> tween,
    Offset current,
    double target,
  ) {
    double value = animationController.value;
    // value-target
    // value -0/1
    if (value < target) {
      // value-target
      // value -1
      productCurve((x) {
        return (target - value) / (1 - value) * (x - 1) + target;
      });
      animationController.duration = duration * (target - value);
      animationController.forward();
    } else {
      // value-target
      // value -0
      productCurve((x) {
        return (value - target) / value * x + target;
      });
      animationController.duration = duration * (value - target);
      animationController.reverse();
    }
  }
}

abstract class ResetTarget {
  const ResetTarget();

  /// 找到更接近 0 0.25 0.5 0.75 1
  double calculate(double value) {
    Map<double, double> map = targetMap(value);
    var list = map.keys.toList();
    list.sort((a, b) => a.compareTo(b));
    return map[list[0]]!;
  }

  Map<double, double> targetMap(double value);
}

class ResetTarget4 extends ResetTarget {
  const ResetTarget4();

  @override
  Map<double, double> targetMap(double value) {
    return {
      (value - 0).abs(): 0,
      (value - 0.25).abs(): 0.25,
      (value - 0.5).abs(): 0.5,
      (value - 0.75).abs(): 0.75,
      (value - 1).abs(): 1,
    };
  }
}

class ResetTarget2 extends ResetTarget {
  const ResetTarget2();

  @override
  Map<double, double> targetMap(double value) {
    return {
      (value - 0).abs(): 0,
      (value - 0.5).abs(): 0.5,
      (value - 1).abs(): 1,
    };
  }
}
