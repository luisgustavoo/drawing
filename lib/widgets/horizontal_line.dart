import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.6,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(),
          ),
        ),
      ),
    );
  }
}
