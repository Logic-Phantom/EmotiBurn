import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame/input.dart';
import 'dart:math';

class BurnAnimationScreen extends StatelessWidget {
  final String text;

  const BurnAnimationScreen({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: BurnAnimationGame(
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
  final String text;
  final VoidCallback onComplete;
  late SpriteComponent letterBg;
  late TextComponent contentText;
  late LetterBurnMaskComponent burnMask;
  late List<FireParticleComponent> fireParticles;
  late List<AshParticleComponent> ashParticles;
  late List<FireEmojiComponent> fireEmojis;
  final Random random = Random();
  double _fadeOutTime = 0.0;
  bool _isFading = false;
  double _burnProgress = 0.0;
  bool _ashStarted = false;

  BurnAnimationGame({
    required this.text,
    required this.onComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // 편지지 배경 (화면 중앙에 고정)
    final bgSprite = await loadSprite('letter_bg.png');
    final bgWidth = size.x * 0.85;
    final bgHeight = size.y * 0.75;
    final bgX = (size.x - bgWidth) / 2;
    final bgY = (size.y - bgHeight) / 2;
    
    letterBg = SpriteComponent(
      sprite: bgSprite,
      position: Vector2(bgX, bgY),
      size: Vector2(bgWidth, bgHeight),
      anchor: Anchor.topLeft,
      priority: 1,
    );
    add(letterBg);

    // 감정 내용 텍스트 (편지지 중앙)
    contentText = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black87,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(bgX + bgWidth/2, bgY + bgHeight/2),
      priority: 2,
    );
    add(contentText);

    // 불꽃 이모티콘 (편지지 상단 경계에 배치)
    fireEmojis = List.generate(8, (index) {
      final x = bgX + (bgWidth * (index + 1) / 9);
      final emoji = FireEmojiComponent(
        position: Vector2(x, bgY),
        gameSize: size,
      );
      add(emoji);
      return emoji;
    });

    // 타들어가는 마스킹 컴포넌트
    burnMask = LetterBurnMaskComponent(
      rect: Rect.fromLTWH(bgX, bgY, bgWidth, bgHeight),
      getProgress: () => _burnProgress,
      priority: 3,
    );
    add(burnMask);

    // 불꽃 파티클 효과
    fireParticles = List.generate(20, (index) {
      final x = bgX + random.nextDouble() * bgWidth;
      final y = bgY + random.nextDouble() * 20; // 상단에 집중
      final particle = FireParticleComponent(
        position: Vector2(x, y),
        gameSize: size,
      );
      add(particle);
      return particle;
    });

    // 2초 후 타들어감 시작
    Future.delayed(const Duration(seconds: 2), () {
      _isFading = true;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // 불꽃 이모티콘 업데이트
    for (var emoji in fireEmojis) {
      emoji.update(dt);
    }
    
    // 불꽃 파티클 업데이트
    for (var particle in fireParticles) {
      particle.update(dt);
    }

    // 타들어가는 효과
    if (_isFading && _burnProgress < 1.0) {
      _fadeOutTime += dt;
      _burnProgress = (_fadeOutTime / 2.0).clamp(0.0, 1.0);
      
      if (_burnProgress >= 1.0 && !_ashStarted) {
        _ashStarted = true;
        // 재 파티클 생성
        ashParticles = List.generate(30, (i) {
          final x = letterBg.position.x + random.nextDouble() * letterBg.size.x;
          final y = letterBg.position.y + letterBg.size.y;
          final particle = AshParticleComponent(
            position: Vector2(x, y),
            gameSize: size,
          );
          add(particle);
          return particle;
        });
        // 1초 후 홈으로 이동
        Future.delayed(const Duration(seconds: 1), onComplete);
      }
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

class FireEmojiComponent extends PositionComponent {
  final Random random = Random();
  final Vector2 gameSize;
  double _time = 0;
  double _amplitude = 5;
  double _frequency = 2;
  late double _baseY;

  FireEmojiComponent({
    required Vector2 position,
    required this.gameSize,
  }) : super(position: position) {
    _baseY = position.y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y = _baseY + sin(_time * _frequency) * _amplitude;
    position.x += (random.nextDouble() - 0.5) * 20 * dt;
  }

  @override
  void render(Canvas canvas) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🔥',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(position.x, position.y));
  }
}

class LetterBurnMaskComponent extends PositionComponent {
  final Rect rect;
  final double Function() getProgress;
  final Random random = Random();

  LetterBurnMaskComponent({
    required this.rect,
    required this.getProgress,
    super.priority,
  });

  @override
  void render(Canvas canvas) {
    final progress = getProgress();
    if (progress <= 0) return;

    final maskHeight = rect.height * progress;
    final maskTop = rect.top;
    
    // 불규칙한 경계 생성
    final path = Path();
    path.moveTo(rect.left, maskTop);
    
    final steps = 40;
    for (int i = 0; i <= steps; i++) {
      final x = rect.left + rect.width * (i / steps);
      final noise = sin(i * 0.5 + progress * 10) * 8 * (0.7 + random.nextDouble() * 0.6);
      final y = maskTop + maskHeight - 8 + noise;
      path.lineTo(x, y);
    }
    
    path.lineTo(rect.right, maskTop);
    path.lineTo(rect.right, maskTop + maskHeight);
    path.lineTo(rect.left, maskTop + maskHeight);
    path.close();

    // 불에 탄 효과 (그라데이션)
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.9),
          Colors.black.withOpacity(0.7),
          Colors.black.withOpacity(0.5),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(rect.left, maskTop, rect.width, maskHeight))
      ..blendMode = BlendMode.srcOver;
    
    canvas.drawPath(path, paint);
  }
}

class FireParticleComponent extends PositionComponent {
  final Random random = Random();
  final Vector2 gameSize;
  double particleSize = 0;
  double opacity = 1.0;
  Color color = Colors.orange;
  double speed = 0;
  double _time = 0;

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
    _time += dt;
    
    position.y -= speed * dt;
    position.x += sin(_time * 5) * 30 * dt;
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

class AshParticleComponent extends PositionComponent {
  final Random random = Random();
  final Vector2 gameSize;
  double particleSize = 0;
  double opacity = 1.0;
  double speed = 0;
  double _time = 0;

  AshParticleComponent({
    required Vector2 position,
    required this.gameSize,
  }) : super(position: position) {
    speed = random.nextDouble() * 40 + 20;
    particleSize = random.nextDouble() * 8 + 4;
    opacity = 0.7;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    
    position.y -= speed * dt;
    position.x += sin(_time * 3) * 20 * dt;
    particleSize *= 0.98;
    opacity *= 0.96;
    
    if (opacity < 0.1) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, position.y),
      particleSize,
      paint,
    );
  }
} 