import 'package:flutter/material.dart';

class ControlsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white30,
        ),
        child: SizedBox(width: 0.1, height: 56),
      ),
    );
  }
}
