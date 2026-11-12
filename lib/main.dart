import 'package:flutter/material.dart';
import 'widgets/limansa_home.dart';

void main() {
  runApp(LimansaApp());
}

// GOD CURSE DART & FLUTTER

class LimansaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
      home: LimansaHome(),
    );
  }
}

