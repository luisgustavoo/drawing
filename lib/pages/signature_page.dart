import 'dart:convert';
import 'dart:ui';

import 'package:drawing_test/models/draw_line.dart';
import 'package:drawing_test/widgets/horizontal_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({super.key});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  late List<DrawLine> _lines;
  late GlobalKey _renderObjectKey;

  @override
  void initState() {
    super.initState();
    _lines = [];
    _renderObjectKey = GlobalKey();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assinatura'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildCurrentPath(),
          const HorizontalLine(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSignature,
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }

  Future<void> _saveSignature() async {
    final nav = Navigator.of(context);
    final boundary = _renderObjectKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;

    if (boundary != null) {
      final image = await boundary.toImage(
        pixelRatio: 3,
      );

      final byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final bs64 = base64Encode(pngBytes);
        debugPrint(bs64.length.toString());
        nav.pop(pngBytes);
      }
    }
  }

  GestureDetector _buildCurrentPath() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      child: RepaintBoundary(
        key: _renderObjectKey,
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: CustomPaint(
            painter: _Signature(_lines),
          ),
        ),
      ),
    );
  }

  void _createLine(List<Offset> point) {
    _lines.add(DrawLine(points: point));
  }

  void _updateLine(Offset point) {
    _lines.last.points.add(point);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _createLine([details.localPosition]);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _updateLine(details.localPosition);
    });
  }
}

class _Signature extends CustomPainter {
  _Signature(this.lines);

  final List<DrawLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final line in lines) {
      for (var i = 0; i < line.points.length - 1; i++) {
        final point = line.points[i];
        if (i > 0) {
          final previousPoint = line.points[i - 1];
          canvas.drawLine(previousPoint, point, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
