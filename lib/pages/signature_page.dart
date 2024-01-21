import 'dart:convert';
import 'dart:ui';

import 'package:drawing_test/models/draw_lines.dart';
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
          Positioned(
            bottom: 100,
            child: Container(
              // height: thickness,
              width: MediaQuery.sizeOf(context).width * 0.6,
              // margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nav = Navigator.of(context);
          final boundary = _renderObjectKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

          if (boundary != null) {
            final image = await boundary.toImage(
              pixelRatio: 3,
            );

            final byteData =
                await image.toByteData(format: ImageByteFormat.png);

            if (byteData != null) {
              final pngBytes = byteData.buffer.asUint8List();
              final bs64 = base64Encode(pngBytes);
              debugPrint(bs64.length.toString());
              nav.pop(pngBytes);
            }
          }
        },
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }

  GestureDetector _buildCurrentPath() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
        key: _renderObjectKey,
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: CustomPaint(
            painter: _Drawing(_lines),
          ),
        ),
      ),
    );
  }

  void _createLine(List<Offset> path) {
    _lines.add(DrawLine(path: path));
  }

  void _updateLine(Offset point) {
    _lines.last.path.add(point);
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

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _updateLine(_lines.last.path.last);
    });
  }
}

class _Drawing extends CustomPainter {
  _Drawing(this.lines);

  final List<DrawLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final line in lines) {
      for (var i = 0; i < line.path.length - 1; i++) {
        final point = line.path[i];
        if (i > 0) {
          final previousPoint = line.path[i - 1];
          canvas.drawLine(previousPoint, point, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
