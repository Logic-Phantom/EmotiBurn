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
  late List<FireParticleComponent> fireParticles;
  late List<AshParticleComponent> ashParticles;
  late List<FireEmojiComponent> fireEmojis;
  final Random random = Random();
  double _fadeOutTime = 0.0;
  bool _isFading = false;
  double _burnProgress = 0.0;
  bool _ashStarted = false;
  bool _showMessage = false;
  String _message = "모든 감정은 잠시뿐, 당신은 더 강해질 거예요.";
  double _messageOpacity = 0.0;
  double _messageY = 0.0;
  bool _isFadingOut = false;  // 페이드 아웃 상태를 추적하는 변수 추가
  
  // 불타는 이미지 관련 변수 추가
  int _currentImageIndex = 0;
  double _imageChangeTimer = 0.0;
  static const double _imageChangeInterval = 0.5; // 이미지 변경 간격을 0.5초로 늘림
  static const int _totalImages = 7; // letter_bg0 ~ letter_bg6
  bool _isImageSequenceComplete = false; // 이미지 시퀀스 완료 여부

  BurnAnimationGame({
    required this.text,
    required this.onComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // 초기 편지지 배경 (화면 중앙에 고정)
    final bgWidth = size.x;
    final bgHeight = size.y;
    final bgX = 0.0;
    final bgY = 0.0;
    
    // 첫 번째 이미지 로드
    final initialSprite = await loadSprite('letter_bg0.png');
    letterBg = SpriteComponent(
      sprite: initialSprite,
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
      position: Vector2(bgWidth/2, bgHeight/2),
      priority: 2,
    );
    add(contentText);

    // 불꽃 이모티콘 (편지지 상단 경계에 배치)
    fireEmojis = List.generate(8, (index) {
      final x = bgX + (bgWidth * (index + 1) / 9);
      final emoji = FireEmojiComponent(
        position: Vector2(x, bgY + bgHeight - 32),
        gameSize: size,
      );
      add(emoji);
      return emoji;
    });

    // 불꽃 파티클 효과
    fireParticles = List.generate(20, (index) {
      final x = bgX + random.nextDouble() * bgWidth;
      final y = bgY + bgHeight - 20 - random.nextDouble() * 20;
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
    if (_isFading && !_isImageSequenceComplete) {
      _fadeOutTime += dt;
      _burnProgress = (_fadeOutTime / 2.0).clamp(0.0, 1.0);
      
      // 이미지 변경 타이머 업데이트
      _imageChangeTimer += dt;
      if (_imageChangeTimer >= _imageChangeInterval) {
        _imageChangeTimer = 0.0;
        if (_currentImageIndex < _totalImages - 1) {
          _currentImageIndex++;
          _updateLetterImage();
        } else {
          _isImageSequenceComplete = true;
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
          // 1초 후 메시지 표시
          Future.delayed(const Duration(seconds: 1), () {
            _showMessage = true;
            _messageY = size.y / 2;
            _messageOpacity = 0.0;
          });
        }
      }
    }

    // 메시지 애니메이션
    if (_showMessage) {
      if (!_isFadingOut) {
        _messageOpacity += dt;
        if (_messageOpacity >= 1.0) {
          _messageOpacity = 1.0;
          // 2초 후 페이드 아웃 시작
          Future.delayed(const Duration(seconds: 2), () {
            _isFadingOut = true;
          });
        }
      } else {
        _messageOpacity -= dt * 0.5;  // 페이드 아웃 속도 조절
        if (_messageOpacity <= 0.0) {
          _messageOpacity = 0.0;
          onComplete();  // 페이드 아웃이 완료되면 홈으로 이동
        }
      }
    }
  }

  // 이미지 업데이트 함수
  Future<void> _updateLetterImage() async {
    final newSprite = await loadSprite('letter_bg$_currentImageIndex.png');
    letterBg.sprite = newSprite;
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

    // 메시지 렌더링
    if (_showMessage) {
      // 검은색 배경
      final bgPaint = Paint()..color = Colors.black;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        bgPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: _message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withOpacity(_messageOpacity),
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset((size.x - textPainter.width) / 2, _messageY));
    }
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
    final maskBottom = rect.bottom;
    
    // 불규칙한 경계 생성
    final path = Path();
    path.moveTo(rect.left, maskBottom);
    
    final steps = 40;
    for (int i = 0; i <= steps; i++) {
      final x = rect.left + rect.width * (i / steps);
      final noise = sin(i * 0.5 + progress * 10) * 8 * (0.7 + random.nextDouble() * 0.6);
      final y = maskBottom - maskHeight + 8 + noise;
      path.lineTo(x, y);
    }
    
    path.lineTo(rect.right, maskBottom);
    path.lineTo(rect.left, maskBottom);
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
      ).createShader(Rect.fromLTWH(rect.left, rect.top, rect.width, maskHeight))
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