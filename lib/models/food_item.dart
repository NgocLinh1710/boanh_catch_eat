import 'dart:math';

enum FoodType {
  instantNoodles,
  greekYogurt,
  kimchi,
  cake,
  avocado,
}

class FoodItem {
  FoodItem({
    required this.type,
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });

  final FoodType type;

  double x;
  double y;
  double speed;
  double size;

  bool collected = false;

  String get emoji {
    switch (type) {
      case FoodType.instantNoodles:
        return '🍜';
      case FoodType.greekYogurt:
        return '🥛';
      case FoodType.kimchi:
        return '🥬';
      case FoodType.cake:
        return '🍰';
      case FoodType.avocado:
        return '🥑';
    }
  }

  String get name {
    switch (type) {
      case FoodType.instantNoodles:
        return 'Mì tôm';
      case FoodType.greekYogurt:
        return 'Sữa chua Hy Lạp';
      case FoodType.kimchi:
        return 'Kim chi';
      case FoodType.cake:
        return 'Bánh ngọt';
      case FoodType.avocado:
        return 'Bơ';
    }
  }

  // Sinh đồ ăn trong khoảng tọa độ được chỉ định
  static FoodItem random(
    Random random,
    double minX,
    double maxX,
    double speed,
  ) {
    const types = FoodType.values;

    final left = min(minX, maxX);
    final right = max(minX, maxX);

    return FoodItem(
      type: types[random.nextInt(types.length)],
      x: left + random.nextDouble() * (right - left),
      y: -50,
      speed: speed,
      size: 36 + random.nextDouble() * 8,
    );
  }
}
