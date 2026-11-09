import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../utils/game_config.dart';

enum GameStatus {
  ready,
  playing,
  paused,
  finished,
}

class GameController extends ChangeNotifier {
  final Random _random = Random();

  Timer? _timer;

  GameStatus status = GameStatus.ready;

  final List<FoodItem> foods = [];

  int score = 0;
  int bestScore = 0;
  int remainingTime = GameConfig.gameDuration;

  double playerX = 0.5;
  double elapsedTime = 0;
  double spawnTimer = 0;

  Size stageSize = Size.zero;

  String message = '';
  double messageDuration = 0;

  static const double _deltaTime = 0.016;

  // Chiều rộng ảnh đang hiển thị
  double get playerWidth {
    if (stageSize.width <= 0) return 0;

    return min(
      stageSize.width * GameConfig.playerWidthRatio,
      GameConfig.playerMaxWidth,
    );
  }

  // Chiều cao ảnh sau khi ép
  double get playerHeight {
    return playerWidth * 488 / 741 * GameConfig.playerHeightCompression;
  }

  // Tọa độ giới hạn tâm nhân vật
  double get minimumPlayerCenter => playerWidth / 2;

  double get maximumPlayerCenter => stageSize.width - playerWidth / 2;

  // Khoảng cách từ tâm ảnh đến tâm miệng
  double get mouthOffsetFromCenter {
    return playerWidth * (GameConfig.mouthCenterXRatio - 0.5);
  }

  void setStageSize(Size size) {
    stageSize = size;

    if (size.width <= 0 || playerWidth <= 0) return;

    final center = (playerX * size.width)
        .clamp(
          minimumPlayerCenter,
          maximumPlayerCenter,
        )
        .toDouble();

    playerX = center / size.width;
  }

  void startGame() {
    _timer?.cancel();

    foods.clear();

    score = 0;
    remainingTime = GameConfig.gameDuration;

    playerX = 0.5;

    elapsedTime = 0;
    spawnTimer = 0;

    message = 'Bắt đầu!';
    messageDuration = 1.2;

    status = GameStatus.playing;

    _timer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _update(),
    );

    notifyListeners();
  }

  void pauseGame() {
    if (status != GameStatus.playing) return;

    _timer?.cancel();

    status = GameStatus.paused;

    notifyListeners();
  }

  void resumeGame() {
    if (status != GameStatus.paused) return;

    status = GameStatus.playing;

    _timer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _update(),
    );

    notifyListeners();
  }

  void togglePause() {
    if (status == GameStatus.playing) {
      pauseGame();
    } else if (status == GameStatus.paused) {
      resumeGame();
    }
  }

  // Di chuyển trái/phải bằng nút điều khiển
  void movePlayer(double delta) {
    if (status != GameStatus.playing) return;
    if (stageSize.width <= 0) return;

    final currentCenter = playerX * stageSize.width;

    final nextCenter = (currentCenter + delta)
        .clamp(
          minimumPlayerCenter,
          maximumPlayerCenter,
        )
        .toDouble();

    playerX = nextCenter / stageSize.width;

    notifyListeners();
  }

  // Di chuyển miệng về phía vị trí ngón tay
  void movePlayerTo(double x) {
    if (status != GameStatus.playing) return;
    if (stageSize.width <= 0) return;

    final targetCenter = x - mouthOffsetFromCenter;

    final nextCenter = targetCenter
        .clamp(
          minimumPlayerCenter,
          maximumPlayerCenter,
        )
        .toDouble();

    playerX = nextCenter / stageSize.width;

    notifyListeners();
  }

  // Tọa độ miệng theo ảnh thực tế
  Offset get mouthPosition {
    final width = playerWidth;
    final height = playerHeight;

    final centerX = stageSize.width * playerX;
    final left = centerX - width / 2;

    final top = stageSize.height - GameConfig.groundHeight - height;

    return Offset(
      left + width * GameConfig.mouthCenterXRatio,
      top + height * GameConfig.mouthCenterYRatio,
    );
  }

  void _update() {
    if (status != GameStatus.playing) return;

    if (stageSize.width <= 0 || stageSize.height <= 0) {
      return;
    }

    elapsedTime += _deltaTime;
    spawnTimer += _deltaTime;

    if (messageDuration > 0) {
      messageDuration -= _deltaTime;
    }

    _spawnFood();
    _updateFoods();
    _checkCollision();

    remainingTime = max(
      0,
      GameConfig.gameDuration - elapsedTime.floor(),
    );

    if (elapsedTime >= GameConfig.gameDuration) {
      finishGame();
      return;
    }

    notifyListeners();
  }

  // Sinh đồ ăn trong phạm vi miệng có thể tiếp cận
  void _spawnFood() {
    final interval = max(
      GameConfig.minimumSpawnInterval,
      GameConfig.initialSpawnInterval - elapsedTime * 0.008,
    );

    if (spawnTimer < interval) return;

    spawnTimer = 0;

    final speed = min(
      GameConfig.maximumFoodSpeed,
      GameConfig.initialFoodSpeed + elapsedTime * 2.0,
    );

    final minMouthX = minimumPlayerCenter + mouthOffsetFromCenter;

    final maxMouthX = maximumPlayerCenter + mouthOffsetFromCenter;

    final minFoodX = minMouthX.clamp(18.0, stageSize.width - 18).toDouble();

    final maxFoodX = maxMouthX.clamp(18.0, stageSize.width - 18).toDouble();

    foods.add(
      FoodItem.random(
        _random,
        minFoodX,
        maxFoodX,
        speed,
      ),
    );
  }

  // Cập nhật vị trí đồ ăn
  void _updateFoods() {
    for (final food in foods) {
      food.y += food.speed * _deltaTime;
    }

    foods.removeWhere(
      (food) => food.y > stageSize.height + 60 || food.collected,
    );
  }

  // Chỉ tính điểm khi đồ ăn đi vào vùng miệng
  void _checkCollision() {
    final mouth = mouthPosition;

    final radiusX = playerWidth * GameConfig.mouthHalfWidthRatio +
        GameConfig.foodCollisionRadius;

    final radiusY = playerHeight * GameConfig.mouthHalfHeightRatio +
        GameConfig.foodCollisionRadius;

    for (final food in foods) {
      if (food.collected) continue;

      final dx = food.x - mouth.dx;
      final dy = food.y - mouth.dy;

      final distance =
          (dx * dx) / (radiusX * radiusX) + (dy * dy) / (radiusY * radiusY);

      if (distance <= 1) {
        food.collected = true;

        score++;

        message = '+1  ${food.name}';
        messageDuration = 0.7;
      }
    }
  }

  void finishGame() {
    _timer?.cancel();

    status = GameStatus.finished;

    if (score > bestScore) {
      bestScore = score;
    }

    notifyListeners();
  }

  void resetGame() {
    _timer?.cancel();

    foods.clear();

    score = 0;
    remainingTime = GameConfig.gameDuration;

    elapsedTime = 0;
    spawnTimer = 0;

    playerX = 0.5;

    message = '';
    messageDuration = 0;

    status = GameStatus.ready;

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
