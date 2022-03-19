import 'dart:math';

import 'package:flutter/material.dart';

import 'menu_deform.dart';

/**
 * When I wrote this, only God and I understood what I was doing
 * Now, God only knows
 */

class MenuLayoutj extends StatefulWidget {
  final WidgetBuilder home;
  final WidgetBuilder menu;
  final double offsetPercent;
  final bool dragable;
  final int duration;
  final Deform deform;

  /// 临界值 动画啥时候自动到1
  final double critical;

  const MenuLayoutj({
    required this.home,
    required this.menu,
    this.offsetPercent = .6,
    this.dragable = false,
    this.duration = 300,
    this.deform = const CubeDeform(),
    this.critical = .7,
    Key? key,
  }) : super(key: key);

  static void toggle(BuildContext context) {
    _MenuLayoutjState? state =
        context.findAncestorStateOfType<_MenuLayoutjState>();
    print('$state');
    state?.toggle();
  }

  @override
  State<MenuLayoutj> createState() => _MenuLayoutjState();
}

class _MenuLayoutjState extends State<MenuLayoutj>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationControl = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    _animation = CurvedAnimation(
      parent: _animationControl,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  void toggle() {
    if (_animationControl.value == 1) {
      _animationControl.reverse(from: 1);
    } else if (_animationControl.value == 0) {
      _animationControl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_animationControl.value == 0) {
          return Future.value(true);
        } else {
          _animationControl.reverse();
          return Future.value(false);
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        var height = constraints.maxHeight;
        final child = buildShelf(context, width, height);
        if (!widget.dragable) {
          return child;
        }
        return buildDragable(width, height, child);
      }),
    );
  }

  Widget buildDragable(double width, height, Widget child) {
    return Listener(
      onPointerMove: (event) {
        _animationControl.value +=
            widget.deform.moving(event.delta, width, height);
      },
      onPointerUp: (event) {
        if (_animationControl.value == 0 || _animationControl.value == 1) {
          return;
        }
        _animationControl.duration = Duration(
            milliseconds:
                (widget.duration * (1 - _animationControl.value)).round());
        if (_animationControl.value > widget.critical) {
          _animationControl.forward();
        } else {
          _animationControl.reverse();
        }
      },
      child: child,
    );
  }

  Widget buildShelf(context, width, height) {
    double menuWidth = widget.offsetPercent * width;
    Widget menu = SizedBox(width: menuWidth, child: widget.menu(context));
    Widget home = widget.home(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        double translate = widget.deform.calculateTranslate(
          _animation.value * widget.offsetPercent,
          width,
          height,
        );
        return Stack(
          children: [
            widget.deform.homeTranslate(
              widget.deform.homeDeform(
                home,
                _animation.value,
              ),
              translate,
            ),
            widget.deform.menuTranslate(
              widget.deform.menuDeform(
                menu,
                _animation.value,
                menuWidth,
              ),
              menuWidth,
              width,
              translate,
            ),
          ],
        );
      },
    );
  }
}
