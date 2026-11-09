import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../models/food_item.dart';
import '../utils/game_config.dart';
import 'player_character.dart';

class GameScene extends StatelessWidget {
  const GameScene({
    super.key,
    required this.controller,
    required this.size,
  });

  final GameController controller;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _ScenePainter(),
      foregroundPainter: _FoodPainter(controller.foods),
      child: PlayerCharacter(
        centerX: controller.playerX * size.width,
        stageSize: size,
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF83D5F3),
          Color(0xFFD9F4FF),
          Color(0xFFFFF0D5),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, background);

    _drawCloud(canvas, Offset(size.width * .15, size.height * .20), 1);
    _drawCloud(canvas, Offset(size.width * .78, size.height * .17), .8);
    _drawCloud(canvas, Offset(size.width * .48, size.height * .39), .6);

    final hills = Paint()..color = const Color(0xFF9BD98B);

    canvas.drawOval(
      Rect.fromLTWH(
        -size.width * .15,
        size.height * .67,
        size.width * .72,
        size.height * .25,
      ),
      hills,
    );

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .42,
        size.height * .67,
        size.width * .78,
        size.height * .25,
      ),
      hills,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height - GameConfig.groundHeight,
        size.width,
        GameConfig.groundHeight,
      ),
      Paint()..color = const Color(0xFF9CD66F),
    );

    final grass = Paint()
      ..color = const Color(0xFF79BD5A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 25; i++) {
      final x = i * size.width / 24;

      canvas.drawLine(
        Offset(x, size.height - 85),
        Offset(x - 4, size.height - 95),
        grass,
      );

      canvas.drawLine(
        Offset(x + 3, size.height - 85),
        Offset(x + 9, size.height - 94),
        grass,
      );
    }

    for (int i = 0; i < 8; i++) {
      _drawFlower(
        canvas,
        Offset(
          i * size.width / 7,
          size.height - 32 - (i % 2) * 15,
        ),
      );
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double scale) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.72);

    canvas.drawCircle(
      center.translate(-25 * scale, 4 * scale),
      23 * scale,
      paint,
    );

    canvas.drawCircle(
      center.translate(0, -8 * scale),
      30 * scale,
      paint,
    );

    canvas.drawCircle(
      center.translate(28 * scale, 5 * scale),
      22 * scale,
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, 14 * scale),
          width: 90 * scale,
          height: 27 * scale,
        ),
        Radius.circular(14 * scale),
      ),
      paint,
    );
  }

  void _drawFlower(Canvas canvas, Offset position) {
    final petal = Paint()..color = const Color(0xFFFFF4C7);
    final center = Paint()..color = const Color(0xFFFFC64D);

    for (int i = 0; i < 5; i++) {
      final angle = i * math.pi * 2 / 5;

      canvas.drawCircle(
        position +
            Offset(
              math.cos(angle) * 7,
              math.sin(angle) * 7,
            ),
        5,
        petal,
      );
    }

    canvas.drawCircle(position, 4, center);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) => false;
}

class _FoodPainter extends CustomPainter {
  _FoodPainter(this.foods);

  final List<FoodItem> foods;

  @override
  void paint(Canvas canvas, Size size) {
    for (final food in foods) {
      if (food.collected) continue;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(food.x + 2, food.y + food.size * .48),
          width: food.size * .9,
          height: 8,
        ),
        Paint()..color = const Color(0x22000000),
      );

      final text = TextPainter(
        text: TextSpan(
          text: food.emoji,
          style: TextStyle(fontSize: food.size),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(
        canvas,
        Offset(
          food.x - text.width / 2,
          food.y - text.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FoodPainter oldDelegate) => true;
}
