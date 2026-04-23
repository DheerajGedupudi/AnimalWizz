import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import '../data/quiz_models.dart';
import '../services/tts_service.dart';
import '../widgets/background_scaffold.dart';

class UnifiedQuizPage extends StatefulWidget {
  final QuizConfig config;
  const UnifiedQuizPage({super.key, required this.config});

  @override
  State<UnifiedQuizPage> createState() => _UnifiedQuizPageState();
}

class _UnifiedQuizPageState extends State<UnifiedQuizPage> {
  final TtsService _tts = TtsService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  late List<_ShuffledQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _showFeedback = false;
  bool _isSpanish = false;
  int _timeLeft = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prepareQuestions();
    _startTimer();
    _speakCurrentQuestion();
  }

  void _prepareQuestions() {
    final rng = Random();
    // Shuffle the full bank, then take questionsPerRound
    final bank = List<QuizQuestion>.from(widget.config.questions)..shuffle(rng);
    final count = min(widget.config.questionsPerRound, bank.length);
    final selected = bank.take(count).toList();

    // For each question, shuffle options and track where correctIndex moved
    _questions = selected.map((q) {
      final indices = List.generate(q.options.length, (i) => i)..shuffle(rng);
      final shuffledOptions = [for (final i in indices) q.options[i]];
      final newCorrectIndex = indices.indexOf(q.correctIndex);
      return _ShuffledQuestion(
        question: q,
        shuffledOptions: shuffledOptions,
        correctIndex: newCorrectIndex,
      );
    }).toList();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --------------- Timer ---------------

  void _startTimer() {
    _timeLeft = widget.config.timePerQuestion;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 1) {
        timer.cancel();
        // Time's up — show feedback with no selection
        setState(() {
          _showFeedback = true;
          _timeLeft = 0;
        });
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  // --------------- TTS ---------------

  Future<void> _speakCurrentQuestion() async {
    final q = _questions[_currentIndex].question;
    await _tts.configure(languageCode: _isSpanish ? 'es-ES' : 'en-US');
    await _tts.speak(_isSpanish ? q.questionEs : q.questionEn);
  }

  // --------------- Sounds ---------------

  Future<void> _playSound(bool correct) async {
    await _audioPlayer.stop();
    await _audioPlayer
        .play(AssetSource('sounds/${correct ? 'correct' : 'wrong'}.mp3'));
  }

  // --------------- Answer logic ---------------

  void _selectOption(int index) {
    if (_showFeedback) return;
    final correct = index == _questions[_currentIndex].correctIndex;

    _timer?.cancel();
    setState(() {
      _selectedIndex = index;
      _showFeedback = true;
      if (correct) {
        _score++;
        _confettiController.play();
      }
    });
    _playSound(correct);
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _showFeedback = false;
      });
      _startTimer();
      _speakCurrentQuestion();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          _isSpanish ? '¡Quiz Terminado!' : 'Quiz Complete!',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_score / ${_questions.length}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isSpanish ? 'Puntuación' : 'Score',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to selection
            },
            child: Text(_isSpanish ? 'Volver' : 'Done'),
          ),
        ],
      ),
    );
  }

  // --------------- Build ---------------

  @override
  Widget build(BuildContext context) {
    final sq = _questions[_currentIndex];
    final q = sq.question;
    final title = _isSpanish ? widget.config.titleEs : widget.config.titleEn;
    final questionText = _isSpanish ? q.questionEs : q.questionEn;

    return BackgroundScaffold(
      backgroundImage: 'assets/images/quiz_background.png',
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ── Top bar: back, title, language toggle ──
                _buildTopBar(title),
                const SizedBox(height: 12),

                // ── Progress & timer ──
                _buildProgressRow(),
                const SizedBox(height: 16),

                // ── Question image (if present) ──
                if (q.questionImage != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      q.questionImage!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ── Question text + speaker ──
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                      onPressed: _speakCurrentQuestion,
                    ),
                    Expanded(
                      child: Text(
                        questionText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black54,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── 2×2 option grid ──
                Expanded(child: _buildOptionsGrid(sq)),

                // ── Next button ──
                if (_showFeedback)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _nextQuestion,
                        child: Text(
                          _currentIndex < _questions.length - 1
                              ? (_isSpanish ? 'Siguiente' : 'Next')
                              : (_isSpanish ? 'Ver Resultados' : 'See Results'),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Confetti overlay ──
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────── Sub-widgets ───────────

  Widget _buildTopBar(String title) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 4),
        _buildLanguageToggle(),
      ],
    );
  }

  Widget _buildLanguageToggle() {
    return GestureDetector(
      onTap: () {
        setState(() => _isSpanish = !_isSpanish);
        _speakCurrentQuestion();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _isSpanish ? 'ES' : 'EN',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildProgressRow() {
    return Row(
      children: [
        Text(
          'Q ${_currentIndex + 1} / ${_questions.length}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _timeLeft <= 5
                ? Colors.red.shade400
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '⏱️ $_timeLeft s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _timeLeft <= 5 ? Colors.white : Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '⭐ $_score',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsGrid(_ShuffledQuestion sq) {
    final options = sq.shuffledOptions;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(options.length, (i) {
        return _buildOptionCard(i, options[i], sq.correctIndex);
      }),
    );
  }

  Widget _buildOptionCard(int index, QuizOption option, int correctIndex) {
    final text = _isSpanish ? option.textEs : option.textEn;
    final hasImage = option.image != null;

    // Determine card color based on feedback state
    Color cardColor = Colors.white.withValues(alpha: 0.9);
    if (_showFeedback) {
      if (index == correctIndex) {
        cardColor = Colors.green.shade300;
      } else if (index == _selectedIndex) {
        cardColor = Colors.red.shade300;
      } else {
        cardColor = Colors.grey.shade300;
      }
    }

    return GestureDetector(
      onTap: _showFeedback ? null : () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _showFeedback && index == correctIndex
                ? Colors.green.shade700
                : Colors.black12,
            width: _showFeedback && index == correctIndex ? 3 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: hasImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          option.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}

// Internal helper — holds a question with its shuffled options
class _ShuffledQuestion {
  final QuizQuestion question;
  final List<QuizOption> shuffledOptions;
  final int correctIndex;

  const _ShuffledQuestion({
    required this.question,
    required this.shuffledOptions,
    required this.correctIndex,
  });
}
