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
      title: 'Rotating arc example  a',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rotating arc examplesss'),
        ),
        body: const Center(
          child: ArcWidget(),
        ),
      ),
    );
  }
}

class ArcWidget extends StatefulWidget {
  const ArcWidget({Key? key}) : super(key: key);

  @override
  _ArcWidgetState createState() => _ArcWidgetState();
}

class _ArcWidgetState extends State<ArcWidget> {
  final double width = 600;
  final double height = 600;
  double baseAngle = 1 / 6 * math.pi;
  Offset? lastPosition;
  double lastBaseAngle = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: ArcPainter(300, baseAngle),
        child: GestureDetector(
          onVerticalDragStart: (value) {
            setInitialState(value);
          },
          onHorizontalDragUpdate: (value) {
            updateAngle(value);
          },
          onVerticalDragUpdate: (value) {
            updateAngle(value);
          },
          onHorizontalDragStart: (value) {
            setInitialState(value);
          },
        ),
      ),
    );
  }

  void updateAngle(DragUpdateDetails value) {
    double result = math.atan2(value.localPosition.dy - height/2, value.localPosition.dx - width/2) -
        math.atan2(lastPosition!.dy - height/2, lastPosition!.dx - width/2);
    setState(() {
      baseAngle = lastBaseAngle + result;
    });
  }

  void setInitialState(DragStartDetails value) {
    lastPosition = value.localPosition;
    lastBaseAngle = baseAngle;
  }
}

class ArcPainter extends CustomPainter {
  final double radius;
  double baseAngle;
  final Paint red = createPaintForColor(Colors.redAccent);
  final Paint blue = createPaintForColor(Colors.blue);
  final Paint green = createPaintForColor(Colors.green);

  ArcPainter(this.radius, this.baseAngle);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius);
    canvas.drawArc(rect, baseAngle, sweepAngle(), true, blue);
    canvas.drawArc(rect, baseAngle + 2 / 3 * math.pi, sweepAngle(), true, red);
    canvas.drawArc(rect, baseAngle + 4 / 3 * math.pi, sweepAngle(), true, green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  double sweepAngle() =>  2 / 3 * math.pi;
}

Paint createPaintForColor(Color color) {
  return Paint()
    ..color = color.withOpacity(0.2)
    ..strokeWidth = 2;
}
