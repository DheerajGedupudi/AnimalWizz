import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/animals.dart';

class MemoryGamePage extends StatefulWidget {
  final String lessonTitle;
  final String lessonImage;

  const MemoryGamePage({
    super.key,
    required this.lessonTitle,
    required this.lessonImage,
  });

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  // Spanish translations for display and TTS (extend as needed)
  static const Map<String, String> _spanishNames = {
    'Horse': 'Caballo',
    'Deer': 'Ciervo',
    'Zebra': 'Cebra',
    'Elephant': 'Elefante',
    'Lion': 'León',
    'Tiger': 'Tigre',
    'Cheetah': 'Guepardo',
    'Wolf': 'Lobo',
    'Fox': 'Zorro',
    'Bear': 'Oso',
    'Pig': 'Cerdo',
    'Chimpanzee': 'Chimpancé',
    'Toucan': 'Tucán',
    'Jaguar': 'Jaguar',
    'Sloth': 'Perezoso',
    'Poison Dart Frog': 'Rana venenosa',
    'Camel': 'Camello',
    'Fennec Fox': 'Zorro del desierto',
    'Meerkat': 'Suricata',
    'Gila Monster': 'Monstruo de Gila',
    'Polar Bear': 'Oso polar',
    'Arctic Fox': 'Zorro ártico',
    'Walrus': 'Morsa',
    'Harp Seal': 'Foca de Groenlandia',
    'Reindeer': 'Reno',
    'Snowy Owl': 'Búho nival',
    'Dolphin': 'Delfín',
    'Shark': 'Tiburón',
    'Octopus': 'Pulpo',
    'Jellyfish': 'Medusa',
    'Clownfish': 'Pez payaso',
    'Sea Turtle': 'Tortuga marina',
    'Eagle': 'Águila',
    'Hawk': 'Halcón',
    'Woodpecker': 'Pájaro carpintero',
    'Squirrel': 'Ardilla',
  };

  String _nameForDisplay(String englishName) =>
      isSpanish ? (_spanishNames[englishName] ?? englishName) : englishName;

  // Core state
  List<Map<String, dynamic>> cards = [];
  List<int> selectedIndices = [];
  int matchesFound = 0;
  int wrongTries = 0; // max 3
  bool gameCompleted = false;
  bool gameWon = false;

  // Audio
  late FlutterTts flutterTts;
  late AudioPlayer _sfxPlayer;
  bool soundEnabled = true;
  bool isSpanish = false;

  // Confetti
  late ConfettiController _confettiController;

  // Grid (difficulty)
  int _gridColumns = 4;
  int _gridRows = 4;
  int get _pairsCount => (_gridColumns * _gridRows) ~/ 2;

  // Peek overlay (initial reveal)
  bool isPeeking = false;
  bool canTap = true;
  int _peekTotalSeconds = 10;
  int _peekSecondsRemaining = 0;
  Timer? _peekTimer;

  // Data
  late List<Map<String, dynamic>> animalInfo;

  @override
  void initState() {
    super.initState();
    _sfxPlayer = AudioPlayer();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    // Filter by category (lessonTitle) or use all animals (including "All Animals").
    final category = widget.lessonTitle;
    if (category == 'All Animals' || category.isEmpty) {
      animalInfo =
          kAllAnimals.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      animalInfo =
          kAllAnimals
              .where((a) => (a['category'] ?? '') == category)
              .map((a) => Map<String, dynamic>.from(a))
              .toList();
    }
    _initTts();
    // Choose difficulty first
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showDifficultyDialog(),
    );
  }

  @override
  void dispose() {
    _peekTimer?.cancel();
    _sfxPlayer.stop();
    _sfxPlayer.dispose();
    flutterTts.stop();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    try {
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
      await _setLanguage();
    } catch (_) {}
  }

  Future<void> _setLanguage() async {
    await flutterTts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
  }

  // Difficulty handling
  void _applyDifficulty({
    required int rows,
    required int cols,
    int? peekSeconds,
  }) {
    setState(() {
      _gridRows = rows;
      _gridColumns = cols;
      if (peekSeconds != null) _peekTotalSeconds = peekSeconds;
      cards = [];
      selectedIndices.clear();
      matchesFound = 0;
      wrongTries = 0;
      gameCompleted = false;
      gameWon = false;
    });
    _initializeGame();
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2E3192),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) Navigator.of(this.context).maybePop();
                        });
                      },
                    ),
                  ),
                  const Text(
                    'Choose Difficulty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3192),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _difficultyButton(
                    label: 'Easy – 2 × 3',
                    onTap: () {
                      Navigator.pop(context);
                      _applyDifficulty(rows: 2, cols: 3, peekSeconds: 10);
                    },
                  ),
                  const SizedBox(height: 8),
                  _difficultyButton(
                    label: 'Medium – 2 × 4',
                    onTap: () {
                      Navigator.pop(context);
                      _applyDifficulty(rows: 2, cols: 4, peekSeconds: 10);
                    },
                  ),
                  const SizedBox(height: 8),
                  _difficultyButton(
                    label: 'Hard – 3 × 4',
                    onTap: () {
                      Navigator.pop(context);
                      _applyDifficulty(rows: 3, cols: 4, peekSeconds: 10);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _difficultyButton({
    required String label,
    required VoidCallback onTap,
  }) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFAAFFE5),
      foregroundColor: const Color(0xFF40196D),
      elevation: 2,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: onTap,
    child: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  // Game setup
  void _initializeGame() {
    // Build pool from selected category or all
    final List<Map<String, dynamic>> pool =
        animalInfo.isNotEmpty
            ? List<Map<String, dynamic>>.from(animalInfo)
            : kAllAnimals.map((e) => Map<String, dynamic>.from(e)).toList();

    // Pick unique animals
    final rnd = Random();
    final Set<int> chosen = {};
    final List<Map<String, dynamic>> chosenAnimals = [];
    while (chosenAnimals.length < _pairsCount && chosen.length < pool.length) {
      final i = rnd.nextInt(pool.length);
      if (chosen.add(i)) chosenAnimals.add(pool[i]);
    }

    // Create cards (image + text) for each chosen animal
    final List<Map<String, dynamic>> nextCards = [];
    for (final a in chosenAnimals) {
      nextCards.add({
        'type': 'image',
        'image': a['image'],
        'name': a['name'],
        'revealed': false,
        'matched': false,
        'info': a,
      });
      nextCards.add({
        'type': 'text',
        'name': a['name'],
        'revealed': false,
        'matched': false,
        'info': a,
      });
    }
    nextCards.shuffle(Random());

    setState(() {
      cards = nextCards;
    });

    _startPeek();
  }

  Future<void> _startPeek() async {
    if (!mounted) return;
    setState(() {
      isPeeking = true;
      canTap = false;
      _peekSecondsRemaining = _peekTotalSeconds;
      for (final c in cards) {
        if (c['type'] == 'image') c['revealed'] = true;
      }
    });
    _peekTimer?.cancel();
    _peekTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _peekSecondsRemaining = (_peekSecondsRemaining - 1).clamp(0, 99);
      });
    });
    await Future.delayed(Duration(seconds: _peekTotalSeconds));
    if (!mounted) return;
    setState(() {
      for (final c in cards) {
        if (c['type'] == 'image') c['revealed'] = false;
      }
      isPeeking = false;
      canTap = true;
    });
    _peekTimer?.cancel();
  }

  // Interaction
  void _onCardTap(int index) {
    if (isPeeking || !canTap) return;
    if (gameCompleted) return;
    if (cards[index]['revealed'] ||
        cards[index]['matched'] ||
        selectedIndices.length >= 2)
      return;

    setState(() {
      cards[index]['revealed'] = true;
      selectedIndices.add(index);
    });

    _playFlipAudio(cards[index]);

    if (selectedIndices.length == 2) {
      canTap = false;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        final int a = selectedIndices[0];
        final int b = selectedIndices[1];
        final bool isMatch =
            cards[a]['name'] == cards[b]['name'] &&
            cards[a]['type'] != cards[b]['type'];
        if (isMatch) {
          setState(() {
            cards[a]['matched'] = true;
            cards[b]['matched'] = true;
            matchesFound++;
            if (matchesFound == _pairsCount) {
              gameWon = true;
              gameCompleted = true;
            }
          });
          // Celebrate a correct match
          _confettiController.play();
        } else {
          setState(() {
            cards[a]['revealed'] = false;
            cards[b]['revealed'] = false;
            wrongTries = (wrongTries + 1).clamp(0, 3);
            if (wrongTries >= 3) {
              gameWon = false;
              gameCompleted = true;
            }
          });
          // Show a brief "Try again!" message when the match is wrong
          if (!gameCompleted) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Try again!'),
                backgroundColor: Colors.redAccent,
                duration: Duration(milliseconds: 700),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
        selectedIndices.clear();
        canTap = true;
        if (gameCompleted) {
          Future.delayed(
            const Duration(milliseconds: 400),
            _showGameCompletedDialog,
          );
        }
      });
    }
  }

  Future<void> _playFlipAudio(Map<String, dynamic> card) async {
    try {
      if (!soundEnabled) return;
      if (card['type'] == 'text') {
        final say = _nameForDisplay((card['name'] ?? '').toString());
        await _speak(say);
      } else {
        final name = (card['name'] ?? '').toString();
        final path = _animalSoundPath(name);
        await _sfxPlayer.stop();
        await _sfxPlayer.play(AssetSource(path));
      }
    } catch (_) {
      if (soundEnabled) {
        final say = _nameForDisplay((card['name'] ?? '').toString());
        await _speak(say);
      }
    }
  }

  String _animalSoundPath(String name) {
    final sanitized = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return 'assets/sounds/animals/${sanitized}.mp3';
  }

  Future<void> _speak(String text) async {
    if (!soundEnabled) return;
    await _setLanguage();
    await flutterTts.stop();
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF5C1), Color(0xFFFFDD9E)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (gameWon)
                    const Text(
                      '🎉 Great Job! 🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B),
                        letterSpacing: 1.2,
                      ),
                    ),
                  const SizedBox(height: 15),
                  if (gameWon)
                    const Text(
                      'You matched all the animals!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 15),
                  _buildStarsRow(size: 36, spacing: 8),
                  const SizedBox(height: 10),
                  if (gameWon)
                    const Text(
                      'You can now tap any animal to learn more!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (gameWon)
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Continue Playing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3192),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _restartGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAAFFE5),
                          foregroundColor: const Color(0xFF40196D),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      cards = [];
      selectedIndices.clear();
      matchesFound = 0;
      wrongTries = 0;
      gameCompleted = false;
      gameWon = false;
    });
    _initializeGame();
  }

  // UI helpers
  Widget _buildStarsRow({double size = 20, double spacing = 4}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final consumed = i < wrongTries;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.star,
                color: consumed ? Colors.grey : const Color(0xFFFFC107),
                size: size,
              ),
              if (consumed)
                Transform.rotate(
                  angle: 0.78539816339, // 45 degrees
                  child: Container(
                    width: size * 1.2,
                    height: 2,
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Brain Challenger',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: const Color(0xFF40196D),
        elevation: 0,
        actions: [
          // Language toggle with emoji + label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() => isSpanish = !isSpanish);
                _setLanguage();
              },
              icon: Text(
                isSpanish ? '🇪🇸' : '🇬🇧',
                style: const TextStyle(fontSize: 18),
              ),
              label: Text(
                isSpanish ? 'Español' : 'English',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
          // Speaker toggle
          IconButton(
            tooltip: soundEnabled ? 'Mute' : 'Unmute',
            onPressed: () async {
              setState(() => soundEnabled = !soundEnabled);
              if (soundEnabled) {
                await _setLanguage();
              } else {
                await _sfxPlayer.stop();
                await flutterTts.stop();
              }
            },
            icon: Icon(
              soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildStarsRow(size: 22, spacing: 4),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay for better readability
          Container(color: Colors.white.withOpacity(0.7)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Match Pictures With Names',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40196D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Card grid
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              const crossAxisSpacing = 6.0;
                              const mainAxisSpacing = 6.0;
                              final totalWidth = constraints.maxWidth;
                              final totalHeight = constraints.maxHeight;
                              final tileWidth =
                                  (totalWidth -
                                      (crossAxisSpacing * (_gridColumns - 1))) /
                                  _gridColumns;
                              final tileHeight =
                                  (totalHeight -
                                      (mainAxisSpacing * (_gridRows - 1))) /
                                  _gridRows;
                              final aspect = tileWidth / tileHeight;
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _gridColumns,
                                      crossAxisSpacing: crossAxisSpacing,
                                      mainAxisSpacing: mainAxisSpacing,
                                      childAspectRatio: aspect,
                                    ),
                                itemCount: cards.length,
                                itemBuilder: (context, index) {
                                  final card = cards[index];
                                  return GestureDetector(
                                    onTap: () => _onCardTap(index),
                                    child: Card(
                                      elevation: card['matched'] ? 0 : 2,
                                      margin: EdgeInsets.zero,
                                      shadowColor:
                                          card['matched']
                                              ? const Color(
                                                0xFF4ECDC4,
                                              ).withOpacity(0.5)
                                              : Colors.black.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              card['matched']
                                                  ? const Color(0xFFAAFFE5)
                                                  : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      color:
                                          card['matched']
                                              ? const Color(0xFFAAFFE5)
                                              : const Color(0xFFFF87AB),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            if (card['revealed'] &&
                                                !card['matched'])
                                              const BoxShadow(
                                                color: Color(0xFFAAFFE5),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                          ],
                                        ),
                                        child:
                                            (card['revealed'] ||
                                                    card['matched'])
                                                ? (card['type'] == 'image'
                                                    ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4.0,
                                                          ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                        child: Image.asset(
                                                          card['image'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                    : Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              2.0,
                                                            ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            _nameForDisplay(
                                                              (card['name'] ??
                                                                      '')
                                                                  .toString(),
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                    0xFF40196D,
                                                                  ),
                                                                ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                : const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      2.0,
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        'Flip the card',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                            0xFF40196D,
                                                          ),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        if (isPeeking)
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: true,
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 140,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 110,
                                              height: 110,
                                              child: CircularProgressIndicator(
                                                value:
                                                    _peekTotalSeconds == 0
                                                        ? null
                                                        : (1 -
                                                            (_peekSecondsRemaining /
                                                                _peekTotalSeconds)),
                                                strokeWidth: 8,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFF40196D)),
                                                backgroundColor: const Color(
                                                  0xFFAAFFE5,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '$_peekSecondsRemaining',
                                              style: const TextStyle(
                                                fontSize: 34,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF40196D),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Flip and Match',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2E3192),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                          ),
                          ),

                        // Confetti overlay for correct matches
                        Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            shouldLoop: false,
                            numberOfParticles: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
