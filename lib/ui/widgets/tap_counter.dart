import 'package:flutter/material.dart';

class TapCounter extends StatefulWidget {
  final String? label;
  final int targetCount;
  final VoidCallback onTapCountReached;
  final Widget? child;

  const TapCounter({super.key, this.label, this.targetCount = 10, required this.onTapCountReached, this.child});

  @override
  TapCounterState createState() => TapCounterState();
}

class TapCounterState extends State<TapCounter> {
  int tapCount = 0;
  DateTime? lastTapTime;

  void handleTap() {
    if (tapCount > 10) return;

    final now = DateTime.now();
    if (lastTapTime == null || now.difference(lastTapTime!) > Duration(seconds: 1)) {
      tapCount = 0;
    }
    lastTapTime = now;
    tapCount++;
    if (tapCount == 10) {
      widget.onTapCountReached();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: handleTap, child: Center(child: widget.child ?? Text(widget.label ?? 'Tap me')));
  }
}
