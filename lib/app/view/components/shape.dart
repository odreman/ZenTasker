import 'package:flutter/material.dart';

class Shape extends StatelessWidget {
  const Shape({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 141,
      height: 129,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/shape.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
