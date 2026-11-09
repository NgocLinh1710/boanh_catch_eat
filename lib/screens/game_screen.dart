import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/game_controller.dart';
import '../utils/game_config.dart';
import '../widgets/game_hud.dart';
import '../widgets/game_overlay.dart';
import '../widgets/game_scene.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController controller;

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = GameController();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyboard(
    FocusNode node,
    KeyEvent event,
  ) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.keyA) {
      controller.movePlayer(-24);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.keyD) {
      controller.movePlayer(24);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.space) {
      controller.togglePause();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        autofocus: true,
        focusNode: focusNode,
        onKeyEvent: _handleKeyboard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            controller.setStageSize(size);

            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    controller.movePlayer(details.delta.dx);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      GameScene(
                        controller: controller,
                        size: size,
                      ),
                      GameHud(
                        score: controller.score,
                        bestScore: controller.bestScore,
                        remainingTime: controller.remainingTime,
                        onPause: controller.togglePause,
                      ),
                      if (controller.status == GameStatus.playing)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            top: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _directionButton(
                                  Icons.arrow_left_rounded,
                                  () => controller.movePlayer(-35),
                                ),
                                _directionButton(
                                  Icons.arrow_right_rounded,
                                  () => controller.movePlayer(35),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (controller.messageDuration > 0 &&
                          controller.status == GameStatus.playing)
                        Positioned(
                          top: size.height * 0.22,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Center(
                              child: Text(
                                controller.message,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF238C45),
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      GameOverlay(
                        status: controller.status,
                        score: controller.score,
                        bestScore: controller.bestScore,
                        onStart: () {
                          controller.startGame();
                          focusNode.requestFocus();
                        },
                        onResume: () {
                          controller.resumeGame();
                          focusNode.requestFocus();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _directionButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Material(
      color: const Color(0xFFFFD36A),
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: SizedBox(
          width: 76,
          height: 58,
          child: Icon(
            icon,
            size: 46,
            color: GameConfig.brown,
          ),
        ),
      ),
    );
  }
}
