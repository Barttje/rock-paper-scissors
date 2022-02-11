import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Coloured Rock Paper Scissors',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Coloured Rock Paper Scissors'),
            ),
            body: Center(child: ImageWrapper())));
  }
}

class ImageWrapper extends StatefulWidget {
  const ImageWrapper({Key? key}) : super(key: key);

  @override
  _ImageWrapperState createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {
  ui.Image? image;
  bool isImageloaded = false;
  double baseAngle = 0;
  Offset? lastPosition;
  double lastBaseAngle = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final ByteData data = await rootBundle.load('assets/images/picard-why.png');
    final imageResult = decodeImageFromList(Uint8List.view(data.buffer));
    imageResult.then((value) => {
          setState(() {
            image = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const CircularProgressIndicator();
    }
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: CirclePainter(100, image, baseAngle),
        child: GestureDetector(
          onVerticalDragStart: (value) {
            lastPosition = value.localPosition;
            lastBaseAngle = baseAngle;
          },
          onHorizontalDragUpdate: (value) {
            double result = math.atan2(value.localPosition.dy - 100, value.localPosition.dx - 100) -
                math.atan2(lastPosition!.dy- 100, lastPosition!.dx - 100);
            setState(() {
              baseAngle = lastBaseAngle + result;
            });
          },
          onVerticalDragUpdate: (value) {
            double result = math.atan2(value.localPosition.dy - 100, value.localPosition.dx - 100) -
                math.atan2(lastPosition!.dy- 100, lastPosition!.dx - 100);
            setState(() {
              baseAngle = lastBaseAngle + result;
            });          },
          onHorizontalDragStart: (value) {
            lastPosition = value.localPosition;
            lastBaseAngle = baseAngle;
          },
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;
  double baseAngle;
  final double strokeWidth = 15;
  final ui.Image? image;

  CirclePainter(this.radius, this.image, this.baseAngle);

  updateBaseAngle(double angle) {
    baseAngle = angle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    Paint red = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    Paint green = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    Rect rect = Rect.fromCircle(center: const Offset(100, 100), radius: radius);
    canvas.drawArc(rect, baseAngle, 0.8 * 2 / 3 * math.pi, false, paint);
    canvas.drawArc(rect, baseAngle + 2 / 3 * math.pi, 0.8 * 2 / 3 * math.pi, false, red);
    canvas.drawArc(rect, baseAngle + 4 / 3 * math.pi, 0.8 * 2 / 3 * math.pi, false, green);
    // canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
