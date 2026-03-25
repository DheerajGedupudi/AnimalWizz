import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/animal.dart';
import '../data/animals.dart';

class HabitatConfig {
  final String name;
  final String backgroundImage;
  final String bannerText;
  final String prevRoute;
  final String nextRoute;
  final Color arrowColor;

  const HabitatConfig({
    required this.name,
    required this.backgroundImage,
    required this.bannerText,
    required this.prevRoute,
    required this.nextRoute,
    required this.arrowColor,
  });
}

// --- Habitat Configs (data comes from central animals.dart) ---

const desertConfig = HabitatConfig(
  name: 'Desert',
  backgroundImage: 'assets/images/desser_bg.png',
  bannerText: "🏜️ Let's explore the desert habitat!",
  prevRoute: '/arctic',
  nextRoute: '/forest',
  arrowColor: Color(0xFF3E2723),
);

const forestConfig = HabitatConfig(
  name: 'Forest',
  backgroundImage: 'assets/images/forest_bg.png',
  bannerText: "🌲 Let's explore the forest habitat!",
  prevRoute: '/desert',
  nextRoute: '/ocean',
  arrowColor: Color(0xFF1B5E20),
);

const arcticConfig = HabitatConfig(
  name: 'Arctic',
  backgroundImage: 'assets/images/arctic_bg.png',
  bannerText: "❄️ Let's discover the arctic habitat!",
  prevRoute: '/ocean',
  nextRoute: '/desert',
  arrowColor: Color(0xFF3E2723),
);

const oceanConfig = HabitatConfig(
  name: 'Ocean',
  backgroundImage: 'assets/images/ocean_bg.png',
  bannerText: "🌊 Let's dive into the ocean habitat!",
  prevRoute: '/forest',
  nextRoute: '/arctic',
  arrowColor: Color(0xFF3E2723),
);

// --- The Unified Widget ---

class HabitatPage extends StatefulWidget {
  final HabitatConfig config;

  const HabitatPage({super.key, required this.config});

  @override
  State<HabitatPage> createState() => _HabitatPageState();
}

class _HabitatPageState extends State<HabitatPage> {
  late FlutterTts flutterTts;
  late List<Animal> _animals;

  @override
  void initState() {
    super.initState();
    _initTts();
    _animals = animalsForHabitat(widget.config.name);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text, bool isSpanish) async {
    await flutterTts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  void _onAnimalTap(Animal animal) {
    bool isSpanish = false;
    bool isSpeaking = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Center(
              child: AnimatedScale(
                scale: 1.1,
                duration: const Duration(milliseconds: 400),
                child: Text(
                  isSpanish ? animal.nameEs : animal.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    key: ValueKey(animal.image),
                    child: Image.asset(
                      animal.image,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    isSpanish ? animal.descriptionEs : animal.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Language: "),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Switch(
                        value: isSpanish,
                        onChanged: (val) {
                          setState(() {
                            isSpanish = val;
                            flutterTts.stop();
                          });
                        },
                        activeColor: Colors.deepPurple,
                        key: ValueKey(isSpanish),
                      ),
                    ),
                    Text(isSpanish ? "Spanish" : "English"),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
                  label: Text(isSpeaking ? "Stop" : "Listen"),
                  onPressed: () {
                    final text = isSpanish
                        ? animal.descriptionEs
                        : animal.description;
                    setState(() => isSpeaking = !isSpeaking);
                    if (isSpeaking) {
                      _speak(text, isSpanish).then((_) {
                        setState(() => isSpeaking = false);
                      });
                    } else {
                      flutterTts.stop();
                    }
                  },
                ),
              ],
            ),
            actions: [
              Center(
                child: FadeTransition(
                  opacity: const AlwaysStoppedAnimation(1.0),
                  child: TextButton(
                    onPressed: () {
                      flutterTts.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      isSpanish ? "Cerrar" : "Close",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(config.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Back button (top-left)
                Positioned(
                  top: 10,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: config.arrowColor,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
                // Previous habitat (left side, vertically centered)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 16,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: config.arrowColor,
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          config.prevRoute,
                        ),
                      ),
                    ),
                  ).animate().slideX(begin: -1, duration: 400.ms).fadeIn(),
                ),
                // Next habitat (right side, vertically centered)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 16,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(-2, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: config.arrowColor,
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          config.nextRoute,
                        ),
                      ),
                    ),
                  ).animate().slideX(begin: 1, duration: 400.ms).fadeIn(),
                ),
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 250,
                    runSpacing: 30,
                    children: _animals.map((animal) {
                      return GestureDetector(
                        onTap: () => _onAnimalTap(animal),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(animal.image),
                          radius: 85,
                        )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .moveY(
                              begin: -10,
                              end: 10,
                              duration: 2.seconds,
                            ),
                      );
                    }).toList(),
                  ),
                ),
                // Banner + robot (rendered last so it appears on top of animal grid)
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          config.bannerText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50),
                            fontFamily: 'Roboto',
                            height: 1.4,
                            shadows: [
                              Shadow(
                                blurRadius: 2,
                                color: Colors.white,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          .animate()
                          .slideY(begin: -0.1, duration: 500.ms)
                          .fadeIn(duration: 500.ms),
                      const SizedBox(height: 20),
                      Image.asset('assets/images/robot.png', height: 300),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
