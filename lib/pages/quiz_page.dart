import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

class JungleQuizPage extends StatefulWidget {
  final String? sectionName;
  const JungleQuizPage({super.key, this.sectionName});

  @override
  State<JungleQuizPage> createState() => _JungleQuizPageState();
}

class _JungleQuizPageState extends State<JungleQuizPage> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  bool showSpanish = false;
  int _currentIndex = 0;
  int _score = 0;
  String _selectedOption = '';
  bool _showFeedback = false;
  int _timeLeft = 15;
  Timer? _timer;
  String _currentSection = '';
  int _sectionIndex = 0;

  late List<String> _sections;
  late List<Map<String, dynamic>> _currentQuestions;

  // Sections with questions
  final Map<String, List<Map<String, dynamic>>> _sectionedQuestions = {
    'Animals': [
      {
        'question_en': 'What animal is known as the king of the jungle?',
        'question_es': '¿Qué animal es conocido como el rey de la jungla?',
        'options_en': ['Elephant', 'Tiger', 'Lion', 'Bear'],
        'options_es': ['Elefante', 'Tigre', 'León', 'Oso'],
        'answer': 'Lion',
      },
      {
        'question_en': 'Which animal is a herbivore?',
        'question_es': '¿Qué animal es un herbívoro?',
        'options_en': ['Tiger', 'Elephant', 'Snake', 'Eagle'],
        'options_es': ['Tigre', 'Elefante', 'Serpiente', 'Águila'],
        'answer': 'Elephant',
      },
      {
        'question_en': 'What do carnivores eat?',
        'question_es': '¿Qué comen los carnívoros?',
        'options_en': ['Fruits', 'Plants', 'Meat', 'Leaves'],
        'options_es': ['Frutas', 'Plantas', 'Carne', 'Hojas'],
        'answer': 'Meat',
      },
    ],

    'Life Cycles': [
      {
        'question_en': 'What is the first stage of a butterfly life cycle?',
        'question_es': '¿Cuál es la primera etapa del ciclo de vida de una mariposa?',
        'options_en': ['Egg', 'Caterpillar', 'Pupa', 'Adult'],
        'options_es': ['Huevo', 'Oruga', 'Crisálida', 'Adulto'],
        'answer': 'Egg',
      },
      {
        'question_en': 'What stage comes after the caterpillar?',
        'question_es': '¿Qué etapa viene después de la oruga?',
        'options_en': ['Egg', 'Pupa', 'Adult', 'None'],
        'options_es': ['Huevo', 'Crisálida', 'Adulto', 'Ninguno'],
        'answer': 'Pupa',
      },
      {
        'question_en': 'Which stage is when the butterfly emerges?',
        'question_es': '¿En qué etapa emerge la mariposa?',
        'options_en': ['Egg', 'Caterpillar', 'Pupa', 'Adult'],
        'options_es': ['Huevo', 'Oruga', 'Crisálida', 'Adulto'],
        'answer': 'Adult',
      },
    ],

    'Food Chain': [
      {
        'question_en': 'Which one is a producer in the food chain?',
        'question_es': '¿Cuál es un productor en la cadena alimentaria?',
        'options_en': ['Grass', 'Snake', 'Frog', 'Lion'],
        'options_es': ['Hierba', 'Serpiente', 'Rana', 'León'],
        'answer': 'Grass',
      },
      {
        'question_en': 'Who eats the grass in this chain?',
        'question_es': '¿Quién come la hierba en esta cadena?',
        'options_en': ['Grasshopper', 'Frog', 'Snake', 'Tiger'],
        'options_es': ['Saltamontes', 'Rana', 'Serpiente', 'Tigre'],
        'answer': 'Grasshopper',
      },
      {
        'question_en': 'Who eats the grasshopper?',
        'question_es': '¿Quién come al saltamontes?',
        'options_en': ['Snake', 'Frog', 'Lion', 'Bear'],
        'options_es': ['Serpiente', 'Rana', 'León', 'Oso'],
        'answer': 'Frog',
      },
      {
        'question_en': 'Who eats the frog?',
        'question_es': '¿Quién come a la rana?',
        'options_en': ['Snake', 'Tiger', 'Eagle', 'Elephant'],
        'options_es': ['Serpiente', 'Tigre', 'Águila', 'Elefante'],
        'answer': 'Snake',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _sections = _sectionedQuestions.keys.toList();
    if (widget.sectionName != null) {
      final sectionIndex = _sections.indexOf(widget.sectionName!);
      if (sectionIndex != -1) {
        _sections = [widget.sectionName!];
        _loadSection(0);
      }
    } else {
      _loadSection(0);
    }
  }

  void _loadSection(int sectionIndex) {
    if (sectionIndex >= _sections.length) return;
    setState(() {
      _sectionIndex = sectionIndex;
      _currentSection = _sections[sectionIndex];
      _currentQuestions = _sectionedQuestions[_currentSection] ?? [];
      _currentIndex = 0;
      _selectedOption = '';
      _showFeedback = false;
    });
    if (_currentQuestions.isNotEmpty) _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    flutterTts.stop();
    _confettiController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
        setState(() {
          _showFeedback = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _nextQuestion();
        });
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _speak(String text) {
    flutterTts.stop();
    flutterTts.speak(text);
  }

  Future<void> _playSound(bool correct) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(
        AssetSource('sounds/${correct ? 'correct' : 'wrong'}.mp3'));
  }

  void _selectOption(String selectedOption) {
    if (_showFeedback) return;
    final question = _currentQuestions[_currentIndex];
    final options = showSpanish ? question['options_es'] : question['options_en'];
    final selectedIndex = options.indexOf(selectedOption);
    if (selectedIndex == -1) return;
    final correspondingEnglishOption = question['options_en'][selectedIndex];
    final correct = correspondingEnglishOption == question['answer'];

    setState(() {
      _selectedOption = selectedOption;
      _showFeedback = true;
      if (correct) {
        _score++;
        _confettiController.play();
      }
    });
    _playSound(correct);
  }

  void _nextQuestion() {
    if (_currentIndex < _currentQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = '';
        _showFeedback = false;
      });
      _startTimer();
    } else {
      _showFinalResults();
    }
  }

  void _showFinalResults() {
    final totalQuestions = _currentQuestions.length;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text('Your Score: $_score / $totalQuestions',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to quiz selection
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMultipleChoiceQuestion(Map<String, dynamic> question) {
    final displayedQuestion = showSpanish ? question['question_es'] : question['question_en'];
    final options = showSpanish ? question['options_es'] : question['options_en'];
    final correctAnswer = question['answer'];

    return [
      Text(displayedQuestion,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      ...options.map<Widget>((option) {
        final selectedIndex = options.indexOf(option);
        final correspondingEnglishOption = question['options_en'][selectedIndex];

        Color? color;
        if (_showFeedback) {
          if (_selectedOption == option) {
            color = correspondingEnglishOption == correctAnswer
                ? Colors.green.shade300
                : Colors.red.shade300;
          } else if (correspondingEnglishOption == correctAnswer) {
            color = Colors.green.shade100;
          } else {
            color = Colors.grey.shade200;
          }
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          child: ListTile(
              title: Text(option, style: const TextStyle(fontSize: 18)),
              onTap: _showFeedback ? null : () => _selectOption(option)),
        );
      }).toList(),
      const SizedBox(height: 20),
      if (_showFeedback)
        Center(
          child: ElevatedButton(
            onPressed: _nextQuestion,
            child: const Text('Next'),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestions.isEmpty ||
        _currentIndex >= _currentQuestions.length) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    final question = _currentQuestions[_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/quiz_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Section ${_sectionIndex + 1}: $_currentSection',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Question ${_currentIndex + 1}/${_currentQuestions.length}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Text('⏱️ $_timeLeft s',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () => _speak(showSpanish
                                ? question['question_es']
                                : question['question_en'])),
                        const SizedBox(width: 8),
                        const Text('English / Español'),
                        const SizedBox(width: 8),
                        Switch(
                            value: showSpanish,
                            onChanged: (val) =>
                                setState(() => showSpanish = val)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Column(
                          children: _buildMultipleChoiceQuestion(question)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 30),
          ),
        ],
      ),
    );
  }
}
