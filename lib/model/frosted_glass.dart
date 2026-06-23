import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  const FrostedGlass({
    super.key,
  required this.width,
  required this.height,
  required this.child});
  final width;
  final height;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:BorderRadius.circular(30),
      child: Container(
        width: width,
        height: height,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15.0,
                sigmaY: 15.0,
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.05),
                  ],
                )
              ),
            ),
          Center(
            child: child,
          )
          ],
        ),
      ),

    );
  }
}
