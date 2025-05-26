import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame/input.dart';
import 'dart:math' as math;
import 'dart:math';

class BurnAnimationScreen extends StatelessWidget {
  final String emotion;
  final String text;

  const BurnAnimationScreen({
    super.key,
    required this.emotion,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: BurnAnimationGame(
          emotion: emotion,
          text: text,
          onComplete: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}

class BurnAnimationGame extends FlameGame {
  final String emotion;
  final String text;
  final VoidCallback onComplete;
  late TextComponent emotionText;
  late TextComponent contentText;
  late List<FireParticleComponent> fireParticles;
  final Random random = Random();

  BurnAnimationGame({
    required this.emotion,
    required this.text,
    required this.onComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 감정 이모지 텍스트
    emotionText = TextComponent(
      text: emotion,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 80,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.32),
      anchor: Anchor.center,
    );
    add(emotionText);

    // 감정 내용 텍스트
    contentText = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          height: 1.6,
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.52),
      anchor: Anchor.center,
    );
    add(contentText);

    // 이모지에만 스케일/페이드 효과 적용
    emotionText.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2(1.2, 1.2),
          EffectController(duration: 0.5, curve: Curves.easeOut),
        ),
        ScaleEffect.to(
          Vector2(0.8, 0.8),
          EffectController(duration: 0.5, curve: Curves.easeIn),
        ),
        ScaleEffect.to(
          Vector2(1.0, 1.0),
          EffectController(duration: 0.5, curve: Curves.easeInOut),
        ),
        OpacityEffect.fadeOut(
          EffectController(duration: 1.0),
          onComplete: () {
            Future.delayed(const Duration(seconds: 1), onComplete);
          },
        ),
      ]),
    );

    // 불꽃 파티클 효과 추가
    fireParticles = List.generate(24, (index) {
      final particle = FireParticleComponent(
        position: Vector2(
          random.nextDouble() * size.x,
          size.y * 0.65 + random.nextDouble() * (size.y * 0.25),
        ),
        gameSize: size,
      );
      add(particle);
      return particle;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var particle in fireParticles) {
      particle.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    // 배경 그라데이션
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black,
          Colors.red.withOpacity(0.4),
          Colors.orange.withOpacity(0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
    super.render(canvas);
  }
}

class FireParticleComponent extends PositionComponent {
  final Random random = Random();
  final Vector2 gameSize;
  double particleSize = 0;
  double opacity = 1.0;
  Color color = Colors.orange;
  double speed = 0;

  FireParticleComponent({
    required Vector2 position,
    required this.gameSize,
  }) : super(position: position) {
    speed = random.nextDouble() * 120 + 60;
    particleSize = random.nextDouble() * 12 + 8;
    color = Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(0.8);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= speed * dt;
    position.x += (random.nextDouble() - 0.5) * 30 * dt;
    particleSize *= 0.985;
    opacity *= 0.97;
    if (position.y < gameSize.y * 0.2 || opacity < 0.1) {
      position.y = gameSize.y * 0.65 + random.nextDouble() * (gameSize.y * 0.25);
      position.x = random.nextDouble() * gameSize.x;
      opacity = 1.0;
      particleSize = random.nextDouble() * 12 + 8;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, position.y),
      particleSize,
      paint,
    );
  }
} 