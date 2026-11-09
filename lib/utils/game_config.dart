import 'package:flutter/material.dart';

class GameConfig {
  GameConfig._();

  static const int gameDuration = 45;

  // Tốc độ sinh đồ ăn
  static const double initialSpawnInterval = 0.9;
  static const double minimumSpawnInterval = 0.4;

  // Tốc độ rơi
  static const double initialFoodSpeed = 150;
  static const double maximumFoodSpeed = 360;

  // Kích thước nhân vật
  static const double playerWidthRatio = 0.85;
  static const double playerMaxWidth = 420;

  // Ép chiều cao ảnh xuống 50%
  static const double playerHeightCompression = 0.50;

  // Vị trí mặt đất
  static const double groundHeight = 110;

  static const double imageWidthCm = 14.3;
  static const double mouthStartCm = 5.6;
  static const double mouthWidthCm = 1.5;

  // Tọa độ miệng theo tỷ lệ ảnh
  static const double mouthStartXRatio = mouthStartCm / imageWidthCm;

  static const double mouthEndXRatio =
      (mouthStartCm + mouthWidthCm) / imageWidthCm;

  static const double mouthCenterXRatio =
      (mouthStartXRatio + mouthEndXRatio) / 2;

  static const double mouthHalfWidthRatio =
      (mouthEndXRatio - mouthStartXRatio) / 2;

  static const double mouthCenterYRatio = 147 / 488;

  static const double mouthHalfHeightRatio = 35 / 488;

  // Bán kính cộng thêm để tính kích thước đồ ăn
  static const double foodCollisionRadius = 12;

  // Màu sắc giao diện
  static const Color green = Color(0xFF86C96B);
  static const Color darkGreen = Color(0xFF4D914B);
  static const Color cream = Color(0xFFFFF8E8);
  static const Color brown = Color(0xFF75452B);
}
