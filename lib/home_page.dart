// import 'dart:math';

import 'package:drawing_test/models/draw_lines.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<DrawLines> _lines;
  // late double _top;
  // late double _left;

  @override
  void initState() {
    super.initState();
    _lines = [];
    // _top = 0;
    // _left = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(
        children: [
          _buildCurrentPath(),
        ],
      ),

      // Stack(
      //   children: [
      //     Positioned(
      //       top: _top,
      //       left: _left,
      //       child: GestureDetector(
      //         onPanUpdate: (details) {
      //           setState(() {
      //             _top = max(0, _top + details.delta.dy);
      //             _left = max(0, _left + details.delta.dx);
      //           });
      //         },
      //         child: Container(
      //           width: 100,
      //           height: 100,
      //           color: Colors.red,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  GestureDetector _buildCurrentPath() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
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
    _lines.add(DrawLines(path: path));
  }

  void _updateLine(Offset point) {
    _lines.last.path.add(point);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _createLine([details.localPosition]);
    });
    // print('User started drawing');
    // final box = context.findRenderObject() as RenderBox?;
    // final point = box?.globalToLocal(details.localPosition);
    // if (point != null) {
    //   setState(() {
    //     _createLine([point]);
    //   });
    //   print(point);
    // }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _updateLine(details.localPosition);
    });
    // final box = context.findRenderObject() as RenderBox?;
    // final point = box?.globalToLocal(details.localPosition);
    // if (point != null) {
    //   setState(() {
    //     _updateLine(point);
    //   });
    //   print(point);
    // }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _updateLine(_lines.last.path.last);
    });
  }
}

class _Drawing extends CustomPainter {
  _Drawing(this.lines);

  final List<DrawLines> lines;

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
