import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'dart:math' as math;

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
        game: BurnGame(emotion: emotion, text: text),
      ),
    );
  }
}

class BurnGame extends FlameGame {
  final String emotion;
  final String text;

  BurnGame({required this.emotion, required this.text});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // 종이 컴포넌트 추가
    final paper = PaperComponent(
      emotion: emotion,
      text: text,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(paper);

    // 불꽃 파티클 추가
    final fireParticles = FireParticleComponent(
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(fireParticles);
  }
}

class PaperComponent extends PositionComponent {
  final String emotion;
  final String text;
  late final TextComponent emotionText;
  late final TextComponent contentText;

  PaperComponent({
    required this.emotion,
    required this.text,
    required Vector2 position,
  }) : super(position: position, size: Vector2(200, 300));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;

    // 감정 이모지 텍스트
    emotionText = TextComponent(
      text: emotion,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Colors.black,
        ),
      ),
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
    );
    add(emotionText);

    // 감정 내용 텍스트
    contentText = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      position: Vector2(size.x / 2, 150),
      anchor: Anchor.center,
    );
    add(contentText);

    // 불타는 애니메이션 효과
    add(
      SequenceEffect(
        [
          ScaleEffect(
            scale: Vector2.all(1.2),
            duration: 0.5,
            curve: Curves.easeOut,
          ),
          ScaleEffect(
            scale: Vector2.all(0.8),
            duration: 0.5,
            curve: Curves.easeIn,
          ),
          ScaleEffect(
            scale: Vector2.all(0),
            duration: 1.0,
            curve: Curves.easeIn,
          ),
        ],
        onComplete: () {
          removeFromParent();
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    // 종이 배경
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.white,
    );
    super.render(canvas);
  }
}

class FireParticleComponent extends PositionComponent {
  final List<FireParticle> particles = [];
  final Random random = Random();

  FireParticleComponent({required Vector2 position}) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    
    // 새로운 파티클 생성
    if (particles.length < 50) {
      particles.add(
        FireParticle(
          position: Vector2(
            random.nextDouble() * 100 - 50,
            random.nextDouble() * 100 - 50,
          ),
          velocity: Vector2(
            random.nextDouble() * 2 - 1,
            -random.nextDouble() * 2 - 1,
          ),
          size: random.nextDouble() * 10 + 5,
          life: 1.0,
        ),
      );
    }

    // 파티클 업데이트
    particles.removeWhere((particle) {
      particle.update(dt);
      return particle.life <= 0;
    });
  }

  @override
  void render(Canvas canvas) {
    for (final particle in particles) {
      canvas.drawCircle(
        Offset(particle.position.x, particle.position.y),
        particle.size,
        Paint()
          ..color = Colors.orange.withOpacity(particle.life)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }
}

class FireParticle {
  Vector2 position;
  Vector2 velocity;
  double size;
  double life;

  FireParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.life,
  });

  void update(double dt) {
    position += velocity * dt;
    life -= dt;
    size *= 0.95;
  }
} 