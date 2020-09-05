import 'package:flutter/material.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      const Center(child: CircularProgressIndicator());
    }
    return Center(
        child: SizedBox(
      width: size,
      height: size,
      child: const FittedBox(child: CircularProgressIndicator()),
    ));
  }
}
