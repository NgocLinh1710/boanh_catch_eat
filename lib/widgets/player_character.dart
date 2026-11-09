import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/game_config.dart';

class PlayerCharacter extends StatelessWidget {
  const PlayerCharacter({
    super.key,
    required this.centerX,
    required this.stageSize,
  });

  final double centerX;
  final Size stageSize;

  @override
  Widget build(BuildContext context) {
    final imageWidth = math.min(
      stageSize.width * GameConfig.playerWidthRatio,
      GameConfig.playerMaxWidth,
    );

    final imageHeight =
        imageWidth * 488 / 741 * GameConfig.playerHeightCompression;

    final safeCenterX = centerX
        .clamp(
          imageWidth / 2,
          stageSize.width - imageWidth / 2,
        )
        .toDouble();

    final left = safeCenterX - imageWidth / 2;

    final top = stageSize.height - GameConfig.groundHeight - imageHeight;

    return SizedBox(
      width: stageSize.width,
      height: stageSize.height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: left,
            top: top,
            width: imageWidth,
            height: imageHeight,
            child: Image.asset(
              'assets/images/test_1.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
