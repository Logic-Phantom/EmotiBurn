import 'package:flutter/material.dart';
import 'burn_animation_screen.dart';

class WriteEmotionScreen extends StatefulWidget {
  const WriteEmotionScreen({super.key});

  @override
  State<WriteEmotionScreen> createState() => _WriteEmotionScreenState();
}

class _WriteEmotionScreenState extends State<WriteEmotionScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedEmotion = '😢'; // 기본값: 슬픔

  final List<String> _emotions = [
    '😢', // 슬픔
    '😡', // 분노
    '😰', // 불안
    '😔', // 우울
    '😤', // 짜증
    '😫', // 스트레스
    '😭', // 울고 싶음
    '😩', // 지침
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _burnEmotion() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('감정을 작성해주세요')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BurnAnimationScreen(
          emotion: _selectedEmotion,
          text: _textController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('감정 버리기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '지금 어떤 감정이 드나요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: _emotions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmotion = _emotions[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedEmotion == _emotions[index]
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _emotions[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '감정을 자유롭게 작성해주세요',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: '지금 느끼는 감정을 자유롭게 작성해주세요...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _burnEmotion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text(
                '감정 버리기',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 