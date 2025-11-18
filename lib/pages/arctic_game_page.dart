import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ArcticAnimalsApp extends StatefulWidget {
  const ArcticAnimalsApp({super.key});

  @override
  State<ArcticAnimalsApp> createState() => _ArcticAnimalsAppState();
}

class _ArcticAnimalsAppState extends State<ArcticAnimalsApp> {
  late FlutterTts flutterTts;

  final List<Map<String, dynamic>> _arcticAnimals = [
    {
      'name': 'Polar Bear',
      'name_es': 'Oso Polar',
      'image': 'assets/images/polar_bear.jpg',
      'description': 'Polar bears have thick fur and fat to survive in freezing temperatures.',
      'description_es': 'Los osos polares tienen un pelaje grueso y grasa para sobrevivir en temperaturas heladas.'
    },
    {
      'name': 'Arctic Fox',
      'name_es': 'Zorro Ártico',
      'image': 'assets/images/arctic_fox.jpg',
      'description': 'The Arctic fox changes its fur color with the seasons for camouflage.',
      'description_es': 'El zorro ártico cambia el color de su pelaje con las estaciones para camuflarse.'
    },
    {
      'name': 'Snowy Owl',
      'name_es': 'Búho Nival',
      'image': 'assets/images/snowy_owl.jpg',
      'description': 'Snowy owls are well-camouflaged and hunt during the day.',
      'description_es': 'Los búhos nivales están bien camuflados y cazan durante el día.'
    },
    {
      'name': 'Walrus',
      'name_es': 'Morsa',
      'image': 'assets/images/walrus.jpg',
      'description': 'Walruses have tusks and use them to pull themselves onto ice.',
      'description_es': 'Las morsas tienen colmillos que usan para subirse al hielo.'
    },
    {
      'name': 'Harp Seal',
      'name_es': 'Foca Arpa',
      'image': 'assets/images/harp_seal.jpg',
      'description': 'Harp seals are great swimmers and have thick fur as pups.',
      'description_es': 'Las focas arpa son excelentes nadadoras y tienen un pelaje espeso cuando son crías.'
    },
    {
      'name': 'Reindeer',
      'name_es': 'Reno',
      'image': 'assets/images/reindeer.jpg',
      'description': 'Reindeer migrate long distances and both males and females grow antlers.',
      'description_es': 'Los renos migran largas distancias y tanto machos como hembras tienen astas.'
    },
  ];

//   @override
//   void initState() {
//     super.initState();
//     _initTts();
//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     super.dispose();
//   }

//   Future<void> _initTts() async {
//     flutterTts = FlutterTts();
//     await flutterTts.setVolume(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.setPitch(1.0);
//   }

//   Future<void> _speak(String text, bool isSpanish) async {
//     await flutterTts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
//     await flutterTts.stop();
//     await flutterTts.speak(text);
//   }

//   void _onAnimalTap(Map<String, dynamic> animal) {
//     bool isSpanish = false;
//     bool isSpeaking = false;

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: Text(isSpanish ? animal['name_es'] : animal['name']),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(animal['image'], height: 150),
//               const SizedBox(height: 12),
//               Text(isSpanish ? animal['description_es'] : animal['description']),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const Text("Language: "),
//                   Switch(
//                     value: isSpanish,
//                     onChanged: (val) {
//                       setState(() => isSpanish = val);
//                       flutterTts.stop();
//                     },
//                   ),
//                   Text(isSpanish ? "Spanish" : "English"),
//                 ],
//               ),
//               ElevatedButton.icon(
//                 icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
//                 label: Text(isSpeaking ? "Stop" : "Listen"),
//                 onPressed: () {
//                   final text = isSpanish ? animal['description_es'] : animal['description'];
//                   setState(() => isSpeaking = !isSpeaking);
//                   if (isSpeaking) {
//                     _speak(text, isSpanish).then((_) {
//                       setState(() => isSpeaking = false);
//                     });
//                   } else {
//                     flutterTts.stop();
//                   }
//                 },
//               )
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 flutterTts.stop();
//                 Navigator.pop(context);
//               },
//               child: Text(isSpanish ? "Cerrar" : "Close"),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/arctic_bg.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios),
//                     color: Colors.white,
//                     onPressed: () => Navigator.pushReplacementNamed(context, '/ocean'),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios),
//                     color: Colors.white,
//                     onPressed: () => Navigator.pushReplacementNamed(context, '/desert'),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 120,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: Image.asset(
//                       'assets/images/robot.png',
//                       height: 250,
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Wrap(
//                     alignment: WrapAlignment.center,
//                     spacing: 20,
//                     runSpacing: 20,
//                     children: _arcticAnimals.map((animal) {
//                       return GestureDetector(
//                         onTap: () => _onAnimalTap(animal),
//                         child: CircleAvatar(
//                           backgroundImage: AssetImage(animal['image']),
//                           radius: 60,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

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
                image: AssetImage('assets/images/arctic_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Positioned(
                //   top: 800,
                //   left: 500,
                //   child: IconButton(
                //     icon: const Icon(Icons.arrow_back_ios),
                //      color: Colors.green.shade900,
                //     onPressed: () => Navigator.pushReplacementNamed(context, '/desert'),
                //   ).animate().slideX(begin: -1, duration: 400.ms).fadeIn(),
                // ),
                // Positioned(
                //   top: 800,
                //   right: 500,
                //   child: IconButton(
                //     icon: const Icon(Icons.arrow_forward_ios),
                //     color: Colors.green.shade900,
                //     onPressed: () => Navigator.pushReplacementNamed(context, '/ocean'),
                //   ).animate().slideX(begin: 1, duration: 400.ms).fadeIn(),
                // ),
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
                    onPressed: () => Navigator.pushReplacementNamed(context, '/ocean'),
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
                    onPressed: () => Navigator.pushReplacementNamed(context, '/desert'),
                  ),
                ).animate().slideX(begin: 1, duration: 400.ms).fadeIn(),
              ),

                // Positioned(
                //   bottom: 30,
                //   left: 0,
                //   right: 0,
                //   child: Stack(
                //     alignment: Alignment.topCenter,
                //     children: [
                //       Container(
                //         margin: const EdgeInsets.only(bottom: 260),
                //         padding: const EdgeInsets.all(12),
                //         constraints: const BoxConstraints(maxWidth: 250),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(20),
                //           boxShadow: [
                //             BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(2, 4)),
                //           ],
                //         ),
                //       //   child: const Text(
                //       //     "Let's explore the forest habitat!",
                //       //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                //       //     textAlign: TextAlign.center,
                //       //   ),
                //       // ).animate().slideY(begin: -0.5, duration: 600.ms).fadeIn(duration: 600.ms),
                //             child: const Text(
                //       "🌲 Let's explore the forest habitat!",
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w700,
                //         color: Color(0xFF2C3E50),
                //         fontFamily: 'Roboto',
                //         height: 1.4,
                //         shadows: [
                //           Shadow(blurRadius: 2, color: Colors.white, offset: Offset(1, 1)),
                //         ],
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ).animate().slideY(begin: -0.1, duration: 500.ms).fadeIn(duration: 500.ms),
                //    const SizedBox(height: 30),
                //       Image.asset(
                //         'assets/images/robot.png',
                //         height: 300,
                //       ),
                //     ],
                //   ),
                // ),
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
          "❄️ Let's discover the arctic habitat!",
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
                    children: _arcticAnimals.map((animal) {
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
