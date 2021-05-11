import 'package:flutter/material.dart';

class MainFrame extends StatelessWidget {
  final Widget child;

  const MainFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: HSLColor.fromColor(Colors.white).withLightness(0.8).toColor(),
        child: Center(
          child: Container(
            width: 1000,
            child: Material(
              elevation: 6,
              color: Colors.white,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
