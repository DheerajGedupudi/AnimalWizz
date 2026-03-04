import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../services/tts_service.dart';
import '../widgets/food_card.dart';

class FeedHungryAnimalGamePage extends StatefulWidget {
  const FeedHungryAnimalGamePage({super.key});

  @override
  State<FeedHungryAnimalGamePage> createState() => _FeedHungryAnimalGamePageState();
}

class _FeedHungryAnimalGamePageState extends State<FeedHungryAnimalGamePage>
    with TickerProviderStateMixin {
  final TtsService _tts = TtsService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final ConfettiController _confettiController;
  late final AnimationController _idleController;
  late final AnimationController _shakeController;
  late final AnimationController _happyController;

  final List<AnimalModel> _gameAnimals = [];
  bool _isSpanish = false;
  int _currentIndex = 0;
  int _score = 0;
  int _currentLevel = 1;
  bool _isHappy = false;
  bool _isSad = false;
  bool _isProcessing = false;
  FoodType? _draggingFood;
  bool _questionSpoken = false;
  late List<FoodOption> foodOptions;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _happyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _setupGame();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDisplay());
  }

  void _setupGame() {
    final shuffled = List<AnimalModel>.from(animalData)..shuffle();
    _gameAnimals
      ..clear()
      ..addAll(shuffled.take(5));
    _currentIndex = 0;
    _questionSpoken = false;
    foodOptions = _generateFoodOptions();
  }

  List<FoodOption> _generateFoodOptions() {
    final baseOptions = const [
      FoodOption(
        type: FoodType.meat,
        englishName: 'Meat',
        spanishName: 'Carne',
        emoji: '🥩',
        color: Colors.red,
      ),
      FoodOption(
        type: FoodType.grass,
        englishName: 'Grass',
        spanishName: 'Hierba',
        emoji: '🌿',
        color: Colors.green,
      ),
      FoodOption(
        type: FoodType.fish,
        englishName: 'Fish',
        spanishName: 'Pescado',
        emoji: '🐟',
        color: Colors.blue,
      ),
      FoodOption(
        type: FoodType.fruits,
        englishName: 'Fruits',
        spanishName: 'Frutas',
        emoji: '🍎',
        color: Colors.orange,
      ),
    ];

    if (_currentLevel == 1) {
      return baseOptions;
    } else {
      // Level 2: Add 2 extra decoy foods
      return [
        ...baseOptions,
        const FoodOption(
          type: FoodType.meat,
          englishName: 'Bones',
          spanishName: 'Huesos',
          emoji: '🦴',
          color: Colors.grey,
        ),
        const FoodOption(
          type: FoodType.grass,
          englishName: 'Leaves',
          spanishName: 'Hojas',
          emoji: '🍃',
          color: Colors.lightGreen,
        ),
      ];
    }
  }

  AnimalModel get _currentAnimal => _gameAnimals[_currentIndex];

  String _speechBubbleText() {
    return _isSpanish
        ? '¡Tengo hambre! ¡Dame de comer!'
        : "I'm hungry! Feed me!";
  }

  String _questionText() {
    final name = _isSpanish ? _currentAnimal.spanishName : _currentAnimal.englishName;
    return _isSpanish ? '¿Qué come $name?' : 'What does $name eat?';
  }

  Future<void> _configureTts() async {
    await _tts.configure(languageCode: _isSpanish ? 'es-ES' : 'en-US');
  }

  Future<void> _initializeDisplay() async {
    await _configureTts();
    final animalName = _isSpanish ? _currentAnimal.spanishName : _currentAnimal.englishName;
    await _tts.speak(animalName);
    await Future.delayed(const Duration(milliseconds: 800));
    await _speakQuestion();
  }

  Future<void> _speakQuestion() async {
    if (_questionSpoken) return;
    _questionSpoken = true;
    await _configureTts();
    await _tts.speak(_questionText());
  }

  Future<void> _speakFoodName(FoodOption option) async {
    await _configureTts();
    await _tts.speak(_isSpanish ? option.spanishName : option.englishName);
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (_) {}
  }

  Future<void> _handleCorrect() async {
    if (_isProcessing) return;
    _isProcessing = true;

    print('✅ Correct answer! Score before: $_score');

    setState(() {
      _isHappy = true;
      _isSad = false;
      _score += 10;
    });

    print('✅ Score after increment: $_score');
    print('🎉 Playing confetti...');
    
    _happyController.forward(from: 0);
    _confettiController.play();

    await _playSound(_currentAnimal.sound);
    await _playSound('assets/sounds/correct.mp3');

    await _configureTts();
    await _tts.speak(_isSpanish ? '¡Qué rico! ¡Gracias!' : 'Yummy! Thank you!');

    print('📋 Showing animal summary...');
    await _showAnimalSummary();

    _isProcessing = false;
    print('✅ Correct handler completed');
  }

  Future<void> _handleWrong() async {
    if (_isProcessing) return;
    _isProcessing = true;

    setState(() {
      _isSad = true;
      _isHappy = false;
    });

    _shakeController.forward(from: 0);

    await _playSound('assets/sounds/wrong.mp3');
    await _configureTts();
    await _tts.speak(
      _isSpanish ? '¡Oh no! Yo no como eso.' : "Oh no! I don't eat that.",
    );

    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isSad = false;
      });
    }

    _isProcessing = false;
  }

  Future<void> _showAnimalSummary() async {
    print('📋 _showAnimalSummary called for ${_currentAnimal.englishName}');
    final animal = _currentAnimal;
    final fact = _isSpanish ? animal.factSpanish : animal.factEnglish;
    final name = _isSpanish ? animal.spanishName : animal.englishName;
    final title = _isSpanish ? '¡Información del Animal!' : 'Animal Information!';
    final buttonText = _isSpanish ? 'Siguiente' : 'Next';

    if (!mounted) {
      print('❌ Not mounted, returning');
      return;
    }

    print('📋 Showing dialog...');

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 400)).then((_) async {
          await _configureTts();
          await _tts.speakSequence([title, name, fact]);
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.green, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.celebration, color: Colors.orange, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        animal.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.pets,
                              size: 100,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      fact,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                    label: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (mounted) {
      print('📋 Dialog closed, moving to next animal');
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _isHappy = false;
      });
      _nextAnimal();
    } else {
      print('❌ Not mounted after dialog');
    }
  }

  void _nextAnimal() {
    print('➡️ _nextAnimal called. Current index: $_currentIndex / ${_gameAnimals.length - 1}');
    _happyController.reset();
    _isHappy = false;
    _questionSpoken = false;

    if (_currentIndex < _gameAnimals.length - 1) {
      setState(() {
        _currentIndex += 1;
      });
      print('➡️ Moving to question ${_currentIndex + 1}');
      WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDisplay());
    } else {
      print('🏁 All questions answered, showing game over');
      _showGameOver();
    }
  }

  void _showGameOver() {
    final title = _isSpanish ? '¡Nivel Completado!' : 'Level Complete!';
    final scoreLabel = _isSpanish ? 'Tu Puntuación' : 'Your Score';
    final levelLabel = _isSpanish ? 'Nivel' : 'Level';
    final maxScore = _gameAnimals.length * 10;
    final percentage = ((_score / maxScore) * 100).round();
    final isPerfectScore = _score % 50 == 0 && _currentIndex == 4; // All 5 correct

    String performance = '';
    if (percentage >= 80) {
      performance = _isSpanish ? '¡Excelente! 🌟' : 'Excellent! 🌟';
    } else if (percentage >= 60) {
      performance = _isSpanish ? '¡Buen trabajo! 👏' : 'Good job! 👏';
    } else {
      performance = _isSpanish ? '¡Sigue practicando! 💪' : 'Keep practicing! 💪';
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 72),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$levelLabel ${_currentLevel}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                performance,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                scoreLabel,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_score / $maxScore',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isPerfectScore && _currentLevel < 2)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _nextLevel();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_upward, color: Colors.white),
                      label: Text(
                        _isSpanish ? 'Siguiente Nivel' : 'Next Level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _restartGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.replay, color: Colors.white),
                      label: Text(
                        _isSpanish ? 'Jugar de Nuevo' : 'Play Again',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.home, color: Colors.white),
                    label: Text(
                      _isSpanish ? 'Inicio' : 'Home',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _currentLevel = 1;
      _isHappy = false;
      _isSad = false;
      _questionSpoken = false;
    });
    _setupGame();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDisplay());
  }

  void _nextLevel() {
    setState(() {
      _currentIndex = 0;
      _currentLevel = 2;
      _isHappy = false;
      _isSad = false;
      _questionSpoken = false;
    });
    _setupGame();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDisplay());
  }

  void _toggleLanguage() {
    setState(() {
      _isSpanish = !_isSpanish;
      _questionSpoken = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDisplay());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _idleController.dispose();
    _shakeController.dispose();
    _happyController.dispose();
    _tts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameAnimals.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final animalName = _isSpanish ? _currentAnimal.spanishName : _currentAnimal.englishName;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, size: 28),
                        color: Colors.black87,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 26),
                            const SizedBox(width: 8),
                            Text(
                              'Lvl ${_currentLevel} • ${_currentIndex + 1} / ${_gameAnimals.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleLanguage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            _isSpanish ? 'ES 🇪🇸' : 'EN 🇬🇧',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Speech Bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SpeechBubble(text: _speechBubbleText()),
                ),

                const SizedBox(height: 8),

                // Animal Name
                Text(
                  animalName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Animal Image - SEPARATED
                Expanded(
                  flex: 2,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_shakeController, _happyController]),
                    builder: (context, child) {
                      final shakeOffset = sin(_shakeController.value * pi * 6) * (_isSad ? 8 : 0);
                      final scale = 1 + (_happyController.value * 0.1);

                      return Transform.translate(
                        offset: Offset(shakeOffset, 0),
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      );
                    },
                    child: DragTarget<FoodOption>(
                      onWillAcceptWithDetails: (details) {
                        final willAccept = details.data.type == _currentAnimal.correctFood;
                        print('🎯 Drag detected: ${details.data.englishName} → ${willAccept ? "CORRECT" : "WRONG"}');
                        return willAccept;
                      },
                      onAcceptWithDetails: (details) {
                        print('✅ onAcceptWithDetails triggered for ${details.data.englishName}');
                        _handleCorrect();
                      },
                      builder: (context, candidates, rejected) {
                        final highlight = candidates.isNotEmpty;
                        final moodColor = _isHappy
                            ? const Color(0xFFE8FFF2)
                            : _isSad
                                ? const Color(0xFFFFE3E3)
                                : Colors.transparent;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: highlight ? const Color(0xFFE8FFF2) : moodColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Image.asset(
                            _currentAnimal.image,
                            height: 280,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Question - SEPARATED with sound button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _questionText(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: Colors.orange,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _speakQuestion,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Food Options - LARGER
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: foodOptions.length,
                      itemBuilder: (context, index) {
                        final option = foodOptions[index];
                        final isDragging = _draggingFood == option.type;

                        return Draggable<FoodOption>(
                          data: option,
                          feedback: Material(
                            color: Colors.transparent,
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: FoodCard(
                                emoji: option.emoji,
                                label: _isSpanish ? option.spanishName : option.englishName,
                                color: option.color,
                                isDragging: true,
                                onSpeak: () => _speakFoodName(option),
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: FoodCard(
                              emoji: option.emoji,
                              label: _isSpanish ? option.spanishName : option.englishName,
                              color: option.color,
                              isDragging: true,
                              onSpeak: () => _speakFoodName(option),
                            ),
                          ),
                          onDragStarted: () {
                            setState(() => _draggingFood = option.type);
                          },
                          onDragEnd: (details) {
                            setState(() => _draggingFood = null);
                            if (!details.wasAccepted) {
                              _handleWrong();
                            }
                          },
                          child: FoodCard(
                            emoji: option.emoji,
                            label: _isSpanish ? option.spanishName : option.englishName,
                            color: option.color,
                            isDragging: isDragging,
                            onSpeak: () => _speakFoodName(option),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 8,
                minBlastForce: 4,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
                colors: const [Colors.yellow, Colors.orange, Colors.pink],
                createParticlePath: drawStar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Path drawStar(Size size) {
  final path = Path();
  const points = 5;
  final halfWidth = size.width / 2;
  final halfHeight = size.height / 2;
  final radius = min(halfWidth, halfHeight);
  final innerRadius = radius / 2.5;
  final angle = (pi * 2) / points;
  final startAngle = -pi / 2;

  for (int i = 0; i < points; i++) {
    final x = halfWidth + radius * cos(startAngle + angle * i);
    final y = halfHeight + radius * sin(startAngle + angle * i);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }

    final innerX = halfWidth + innerRadius * cos(startAngle + angle * i + angle / 2);
    final innerY = halfHeight + innerRadius * sin(startAngle + angle * i + angle / 2);
    path.lineTo(innerX, innerY);
  }

  path.close();
  return path;
}

class SpeechBubble extends StatelessWidget {
  final String text;

  const SpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeechBubblePainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A3B2C),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 10),
      const Radius.circular(20),
    );
    canvas.drawRRect(bubble, paint);

    final tailPath = Path()
      ..moveTo(size.width * 0.2, size.height - 10)
      ..lineTo(size.width * 0.28, size.height)
      ..lineTo(size.width * 0.34, size.height - 10)
      ..close();
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
