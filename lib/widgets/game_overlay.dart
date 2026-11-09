import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay({
    super.key,
    required this.status,
    required this.score,
    required this.bestScore,
    required this.onStart,
    required this.onResume,
  });

  final GameStatus status;
  final int score;
  final int bestScore;
  final VoidCallback onStart;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    if (status == GameStatus.playing) {
      return const SizedBox.shrink();
    }

    final isReady = status == GameStatus.ready;
    final isPaused = status == GameStatus.paused;

    return Container(
      color: const Color(0x883A4A42),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: 420,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E8),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFE6B76B),
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isReady
                    ? '🍽️ BƠANH'
                    : isPaused
                        ? '⏸ TẠM DỪNG'
                        : '🎉 HẾT GIỜ!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF75452B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isReady
                    ? 'CATCH & EAT'
                    : isPaused
                        ? 'Bạn muốn chơi tiếp không?'
                        : 'Bạn đã ghi được $score điểm!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF9B693F),
                ),
              ),
              const SizedBox(height: 14),
              if (isReady) ...[
                const Text(
                  'Hứng đồ ăn bằng miệng để ghi điểm!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF775B45),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '🍜 Mì tôm     🥛 Sữa chua Hy Lạp\n'
                  '🥬 Kim chi     🍰 Bánh ngọt     🧋 Sữa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'CHỈ MIỆNG MỚI ĐƯỢC +1 ĐIỂM\n'
                  'Chạm vào thân người không tính điểm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3C984D),
                    fontWeight: FontWeight.w900,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Máy tính: ← → hoặc A / D\n'
                  'Điện thoại: chạm hoặc kéo ngang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF775B45),
                  ),
                ),
              ],
              if (isPaused) ...[
                const Text(
                  'Trò chơi đang tạm dừng.',
                  style: TextStyle(color: Color(0xFF775B45)),
                ),
              ],
              if (status == GameStatus.finished) ...[
                const SizedBox(height: 10),
                Text(
                  'Kỷ lục: $bestScore điểm',
                  style: const TextStyle(
                    color: Color(0xFFB87826),
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isPaused ? onResume : onStart,
                  icon: Icon(
                    isPaused ? Icons.play_arrow : Icons.replay,
                  ),
                  label: Text(
                    isReady
                        ? 'BẮT ĐẦU CHƠI'
                        : isPaused
                            ? 'CHƠI TIẾP'
                            : 'CHƠI LẠI',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF80C96B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
