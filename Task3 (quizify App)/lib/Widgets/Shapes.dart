import 'package:flutter/material.dart';
import 'package:flutter_shapes/flutter_shapes.dart';

class Star1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.green.shade800;
    Shapes shapes = Shapes(
        canvas: canvas,
        radius: 30,
        paint: paint,
        center: Offset(size.width / 2, size.height / 2),
        angle: 0);

    shapes.drawType(ShapeType.Star5); // enum
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}

class Star2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.yellow.shade800;
    Shapes shapes = Shapes(
        canvas: canvas,
        radius: 30,
        paint: paint,
        center: Offset(size.width / 2, size.height / 2),
        angle: 0);

    shapes.drawType(ShapeType.Star5); // enum
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}

class Star3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.deepOrange;
    Shapes shapes = Shapes(
        canvas: canvas,
        radius: 30,
        paint: paint,
        center: Offset(size.width / 2, size.height / 2),
        angle: 0);

    shapes.drawType(ShapeType.Star5); // enum
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}
