import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BoAnhApp());
}

class BoAnhApp extends StatelessWidget {
  const BoAnhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BơAnh - Catch & Eat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF86C96B),
        ),
      ),
      home: const GameScreen(),
    );
  }
}