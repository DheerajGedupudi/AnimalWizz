import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class HabitatGamePage extends StatefulWidget {
  const HabitatGamePage({super.key});

  @override
  State<HabitatGamePage> createState() => _HabitatGamePageState();
}

class _HabitatGamePageState extends State<HabitatGamePage> with SingleTickerProviderStateMixin {
  final FlutterTts tts = FlutterTts();
  bool isSpanish = false;

  late AnimationController _controller;
  int currentQuestionIndex = 0;
  int score = 0;

  Map<String, Color> optionColors = {};

  final List<Map<String, dynamic>> questions = [
    {
      'en': 'Which animal lives in the desert?',
      'es': '¿Qué animal vive en el desierto?',
      'enOptions': ['Camel', 'Penguin', 'Eagle', 'Bear'],
      'esOptions': ['Camello', 'Pingüino', 'Águila', 'Oso'],
      'images': [
        'assets/images/camel.jpg',
        'assets/images/penguin.png',
        'assets/images/eagle.jpg',
        'assets/images/bear.jpg'
      ],
      'answer': 'Camel',
    },
    {
      'en': 'Where do polar bears live?',
      'es': '¿Dónde viven los osos polares?',
      'enOptions': ['Arctic', 'Jungle', 'Desert', 'Ocean'],
      'esOptions': ['Ártico', 'Selva', 'Desierto', 'Océano'],
      'images': [
        'assets/images/habitat_arctic.png',
        'assets/images/habitat_forest.png',
        'assets/images/habitat_desert.png',
        'assets/images/habitat_ocean.png'
      ],
      'answer': 'Arctic',
    },
    {
      'en': 'Which animal lives in the ocean?',
      'es': '¿Qué animal vive en el océano?',
      'enOptions': ['Shark', 'Tiger', 'Eagle', 'Zebra'],
      'esOptions': ['Tiburón', 'Tigre', 'Águila', 'Cebra'],
      'images': [
        'assets/images/shark.jpg',
        'assets/images/tiger.jpg',
        'assets/images/eagle.jpg',
        'assets/images/zebra.jpg'
      ],
      'answer': 'Shark',
    },
    {
      'en': 'Which habitat has cacti?',
      'es': '¿Qué hábitat tiene cactus?',
      'enOptions': ['Rainforest', 'Arctic', 'Desert', 'Ocean'],
      'esOptions': ['Selva tropical', 'Ártico', 'Desierto', 'Océano'],
      'images': [
        'assets/images/habitat_forest.png',
        'assets/images/habitat_arctic.png',
        'assets/images/habitat_desert.png',
        'assets/images/habitat_ocean.png'
      ],
      'answer': 'Desert',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _speakCurrentQuestion();
  }

  void _speakCurrentQuestion() async {
    final q = questions[currentQuestionIndex];
    final text = isSpanish ? q['es'] : q['en'];
    await tts.stop();
    await tts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
    await tts.speak(text);
  }

  void _checkAnswer(String selected) {
    final q = questions[currentQuestionIndex];
    final correct = q['answer'];
    final enOptions = q['enOptions'] as List<String>;
    final esOptions = q['esOptions'] as List<String>;

    String selectedEnglish = selected;
    if (isSpanish) {
      final index = esOptions.indexOf(selected);
      if (index != -1) {
        selectedEnglish = enOptions[index];
      }
    }

    final correctOption = isSpanish ? esOptions[enOptions.indexOf(correct)] : correct;
    final isCorrect = selectedEnglish == correct;

    setState(() {
      optionColors.clear();
      optionColors[correctOption] = Colors.green;
      if (!isCorrect) {
        optionColors[selected] = Colors.red;
      }
    });

    if (isCorrect) score++;

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          optionColors.clear();
        });
        _speakCurrentQuestion();
      } else {
        _controller.stop();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Quiz Finished!'),
            content: Text('Your Score: $score / ${questions.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    currentQuestionIndex = 0;
                    score = 0;
                    optionColors.clear();
                    _controller.repeat();
                  });
                  Navigator.of(context).pop();
                  _speakCurrentQuestion();
                },
                child: const Text('Restart'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestionIndex];
    final options = isSpanish ? q['esOptions'] as List<String> : q['enOptions'] as List<String>;
    final images = q['images'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitat Quiz Game'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: isSpanish ? 'Switch to English' : 'Cambiar a Español',
            onPressed: () {
              setState(() {
                isSpanish = !isSpanish;
              });
              _speakCurrentQuestion();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to English',
            onPressed: () {
              setState(() {
                isSpanish = false;
              });
              _speakCurrentQuestion();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/habitat_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 180,
              left: 16,
              right: 16,
              child: Text(
                isSpanish ? q['es'] : q['en'],
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black, offset: Offset(1, 1))],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned.fill(
              top: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(options.length, (index) {
                  final option = options[index];
                  final imagePath = images[index];
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final dy = 100 + sin(_controller.value * 2 * pi + index) * 30;
                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: GestureDetector(
                          onTap: () => _checkAnswer(option),
                          child: BubbleWidget(
                            label: option,
                            imagePath: imagePath,
                            color: optionColors[option],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleWidget extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color? color;

  const BubbleWidget({
    super.key,
    required this.label,
    required this.imagePath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: color == null
            ? const LinearGradient(
                colors: [Colors.lightGreenAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: color,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 195,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}