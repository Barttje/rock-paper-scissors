import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotating arc example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rotating arc example'),
        ),
        body: const Center(
          child: ArcWidget(),
        ),
      ),
    );
  }
}

class ArcWidget extends StatelessWidget {
  const ArcWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: ArcPainter(100),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double radius;
  final Paint red = createPaintForColor(Colors.red);
  final Paint blue = createPaintForColor(Colors.blue);
  final Paint green = createPaintForColor(Colors.green);

  ArcPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius);
    canvas.drawArc(rect, 0, sweepAngle(), false, blue);
    canvas.drawArc(rect, 2 / 3 * math.pi, sweepAngle(), false, red);
    canvas.drawArc(rect, 4 / 3 * math.pi, sweepAngle(), false, green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  double sweepAngle() => 0.8 * 2 / 3 * math.pi;
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Paint createPaintForColor(Color color) {
  return Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15;
}
