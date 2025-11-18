import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OceanAnimalsApp extends StatefulWidget {
  const OceanAnimalsApp({super.key});

  @override
  State<OceanAnimalsApp> createState() => _OceanAnimalsAppState();
}

class _OceanAnimalsAppState extends State<OceanAnimalsApp> {
  late FlutterTts flutterTts;

  final List<Map<String, dynamic>> _oceanAnimals = [
    {
      'name': 'Dolphin',
      'name_es': 'Delfín',
      'image': 'assets/images/dolphin.jpg',
      'description': 'Dolphins are intelligent marine mammals known for their playful behavior.',
      'description_es': 'Los delfines son mamíferos marinos inteligentes conocidos por su comportamiento juguetón.'
    },
    {
      'name': 'Octopus',
      'name_es': 'Pulpo',
      'image': 'assets/images/octopus.jpg',
      'description': 'Octopuses have eight arms and can camouflage themselves to blend with surroundings.',
      'description_es': 'Los pulpos tienen ocho brazos y pueden camuflarse para mezclarse con su entorno.'
    },
    {
      'name': 'Clownfish',
      'name_es': 'Pez Payaso',
      'image': 'assets/images/clownfish.jpg',
      'description': 'Clownfish live among sea anemones and are known for their bright orange color.',
      'description_es': 'Los peces payaso viven entre anémonas y son conocidos por su color naranja brillante.'
    },
    {
      'name': 'Sea Turtle',
      'name_es': 'Tortuga Marina',
      'image': 'assets/images/sea_turtle.jpg',
      'description': 'Sea turtles are long-living reptiles that can travel great distances in the ocean.',
      'description_es': 'Las tortugas marinas son reptiles longevos que pueden recorrer grandes distancias en el océano.'
    },
    {
      'name': 'Shark',
      'name_es': 'Tiburón',
      'image': 'assets/images/shark.jpg',
      'description': 'Sharks are powerful predators with excellent senses and strong jaws.',
      'description_es': 'Los tiburones son depredadores poderosos con excelentes sentidos y mandíbulas fuertes.'
    },
    {
      'name': 'Jellyfish',
      'name_es': 'Medusa',
      'image': 'assets/images/jellyfish.jpg',
      'description': 'Jellyfish have soft bodies and use their tentacles to sting and catch prey.',
      'description_es': 'Las medusas tienen cuerpos blandos y usan sus tentáculos para picar y atrapar presas.'
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
  builder: (context) => StatefulBuilder(
    builder: (context, setState) => AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                child: Image.asset(animal['image'], height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                isSpanish ? animal['description_es'] : animal['description'],
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
                    key: ValueKey(isSpanish), // Key to trigger animation on state change
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
                final text = isSpanish ? animal['description_es'] : animal['description'];
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
                image: AssetImage('assets/images/ocean_bg.png'),
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
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.brown.shade900,
                    onPressed: () => Navigator.pushReplacementNamed(context, '/forest'),
                  ),
                ).animate().slideX(begin: -1, duration: 400.ms).fadeIn(),
              ),
              Positioned(
                top: 800,
                right: 400,
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
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.brown.shade900,
                    onPressed: () => Navigator.pushReplacementNamed(context, '/arctic'),
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
                "🌊 Let's dive into the ocean habitat!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                  fontFamily: 'Roboto',
                  height: 1.4,
                  shadows: [
                    Shadow(blurRadius: 2, color: Colors.white, offset: Offset(1, 1)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().slideY(begin: -0.1, duration: 500.ms).fadeIn(duration: 500.ms),

            const SizedBox(height: 20), // This WILL show space now

            Image.asset(
              'assets/images/robot.png',
              height: 300,
            ),
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
                    children: _oceanAnimals.map((animal) {
                      return GestureDetector(
                        onTap: () => _onAnimalTap(animal),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(animal['image']),
                          radius: 85,
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(begin: -10, end: 10, duration: 2.seconds),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
