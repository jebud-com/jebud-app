import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedLogoState();
  }
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        upperBound: 1.2,
        lowerBound: 1.0)
      ..addListener(() {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else if (_animationController.isDismissed) {
          _animationController.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: _animationController,
        child: Image.asset("assets/png/logo_transparent.png", width: 120));
  }
}
