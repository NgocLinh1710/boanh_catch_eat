import 'package:flutter/material.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.score,
    required this.bestScore,
    required this.remainingTime,
    required this.onPause,
  });

  final int score;
  final int bestScore;
  final int remainingTime;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _item('⭐ $score', 'ĐIỂM'),
            const Spacer(),
            _item('⏱ $remainingTime', 'GIÂY'),
            const Spacer(),
            _item('🏆 $bestScore', 'KỶ LỤC'),
            const SizedBox(width: 8),
            Material(
              color: const Color(0xFFFFD36A),
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPause,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.pause_rounded,
                    color: Color(0xFF75452B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8B86E),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF75452B),
              fontSize: 15,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
              color: Color(0xFFB27A45),
            ),
          ),
        ],
      ),
    );
  }
}
