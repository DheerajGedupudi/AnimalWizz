import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DesertAnimalsApp extends StatefulWidget {
  const DesertAnimalsApp({super.key});

  @override
  State<DesertAnimalsApp> createState() => _DesertAnimalsAppState();
}

class _DesertAnimalsAppState extends State<DesertAnimalsApp> {
  late FlutterTts flutterTts;

  final List<Map<String, dynamic>> _desertAnimals = [
    {
      'name': 'Fennec Fox',
      'name_es': 'Zorro del Desierto',
      'image': 'assets/images/fennec.jpg',
      'description':
          'Fennec foxes have large ears that help them stay cool in the hot desert.',
      'description_es':
          'Los zorros del desierto tienen orejas grandes que les ayudan a mantenerse frescos en el desierto caliente.',
    },
    {
      'name': 'Camel',
      'name_es': 'Camello',
      'image': 'assets/images/camel.jpg',
      'description':
          'Camels store fat in their humps and can survive long periods without water.',
      'description_es':
          'Los camellos almacenan grasa en sus jorobas y pueden sobrevivir largos períodos sin agua.',
    },
    {
      'name': 'Hawk',
      'name_es': 'Halcón',
      'image': 'assets/images/hawk.png',
      'description':
          'Desert hawks have excellent vision and can spot prey from high in the sky.',
      'description_es':
          'Los halcones del desierto tienen una excelente visión y pueden detectar presas desde lo alto del cielo.',
    },
    {
      'name': 'Meerkat',
      'name_es': 'Suricata',
      'image': 'assets/images/meerkat.jpg',
      'description':
          'Meerkats live in groups and take turns watching for danger.',
      'description_es':
          'Los suricatas viven en grupos y se turnan para vigilar el peligro.',
    },
    {
      'name': 'Gila Monster',
      'name_es': 'Monstruo de Gila',
      'image': 'assets/images/gila_monster.jpg',
      'description':
          'The Gila monster is one of the few venomous lizards in the world.',
      'description_es':
          'El monstruo de Gila es uno de los pocos lagartos venenosos del mundo.',
    },
    {
      'name': 'Desert Tortoise',
      'name_es': 'Tortuga del Desierto',
      'image': 'assets/images/tortoise.png',
      'description':
          'Desert tortoises can live for 50-80 years and dig burrows to escape the heat.',
      'description_es':
          'Las tortugas del desierto pueden vivir de 50 a 80 años y cavan madrigueras para escapar del calor.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
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

  void _onAnimalTap(Map<String, dynamic> animal) {
    bool isSpanish = false;
    bool isSpeaking = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 500),
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    title: Center(
                      child: AnimatedScale(
                        scale: 1.1,
                        duration: Duration(milliseconds: 400),
                        child: Text(
                          isSpanish ? animal['name_es'] : animal['name'],
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
                          duration: Duration(milliseconds: 500),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            key: ValueKey(animal['image']),
                            child: Image.asset(
                              animal['image'],
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            isSpanish
                                ? animal['description_es']
                                : animal['description'],
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
                              duration: Duration(milliseconds: 300),
                              child: Switch(
                                value: isSpanish,
                                onChanged: (val) {
                                  setState(() {
                                    isSpanish = val;
                                    flutterTts.stop();
                                  });
                                },
                                activeColor: Colors.deepPurple,
                                key: ValueKey(
                                  isSpanish,
                                ), // Key to trigger animation on state change
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
                            final text =
                                isSpanish
                                    ? animal['description_es']
                                    : animal['description'];
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
                          opacity: AlwaysStoppedAnimation(1.0),
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/desser_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 800,
                  left: 400,
                  child:
                      Container(
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
                        padding: const EdgeInsets.all(10),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.brown.shade900,
                          onPressed:
                              () => Navigator.pushReplacementNamed(
                                context,
                                '/arctic',
                              ),
                        ),
                      ).animate().slideX(begin: -1, duration: 400.ms).fadeIn(),
                ),
                Positioned(
                  top: 800,
                  right: 400,
                  child:
                      Container(
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
                        padding: const EdgeInsets.all(10),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: Colors.brown.shade900,
                          onPressed:
                              () => Navigator.pushReplacementNamed(
                                context,
                                '/forest',
                              ),
                        ),
                      ).animate().slideX(begin: 1, duration: 400.ms).fadeIn(),
                ),
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
                            child: const Text(
                              "🏜️ Let's explore the desert habitat!",
                              style: TextStyle(
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

                      const SizedBox(height: 20), // This WILL show space now

                      Image.asset('assets/images/robot.png', height: 300),
                    ],
                  ),
                ),

                Positioned(
                  top: 120, // Adjust this value to move the row further up/down
                  left: 0,
                  right: 0,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 250,
                    runSpacing: 30,
                    children:
                        _desertAnimals.map((animal) {
                          return GestureDetector(
                            onTap: () => _onAnimalTap(animal),
                            child: CircleAvatar(
                                  backgroundImage: AssetImage(animal['image']),
                                  radius: 85,
                                )
                                .animate(
                                  onPlay:
                                      (controller) =>
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
