// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:confetti/confetti.dart';

// class LifeCyclesGamePage extends StatefulWidget {
//   final String animal;
//   const LifeCyclesGamePage({super.key, required this.animal});

//   @override
//   State<LifeCyclesGamePage> createState() => _LifeCyclesGamePageState();
// }

// class _LifeCyclesGamePageState extends State<LifeCyclesGamePage> with TickerProviderStateMixin {
//   final FlutterTts tts = FlutterTts();
//   late ConfettiController _confettiController;
//   bool isSpanish = false;

//   final Map<String, List<Map<String, String>>> sequences = {
//     'Butterfly': [
//       {'stage': 'Egg', 'image': 'assets/images/butterfly_eggs.jpg'},
//       {'stage': 'Caterpillar', 'image': 'assets/images/caterpillar.jpg'},
//       {'stage': 'Chrysalis', 'image': 'assets/images/chrysalis.jpg'},
//       {'stage': 'Adult Butterfly', 'image': 'assets/images/adult_butterfly.jpg'},
//     ],
//     'Frog': [
//       {'stage': 'Egg', 'image': 'assets/images/frog_egg.jpg'},
//       {'stage': 'Tadpole', 'image': 'assets/images/tadpole.jpg'},
//       {'stage': 'Tadpole with Legs', 'image': 'assets/images/froglet.jpg'},
//       {'stage': 'Adult Frog', 'image': 'assets/images/frog_adult.jpg'},
//     ],
//   };

//   final Map<String, Map<String, String>> narrations = {
//     'Butterfly': {
//       'en': 'A butterfly’s life starts as an egg, then caterpillar, chrysalis, and finally a butterfly!',
//       'es': 'La vida de una mariposa comienza como un huevo, luego oruga, crisálida y finalmente mariposa.'
//     },
//     'Frog': {
//       'en': 'A frog begins as an egg, becomes a tadpole, then grows legs, and becomes a frog!',
//       'es': 'Una rana comienza como un huevo, se convierte en renacuajo, desarrolla patas y se convierte en rana.'
//     },
//   };

//   final Map<String, Map<String, Map<String, String>>> stageLessons = {
//     'Butterfly': {
//       'Egg': {
//         'en': 'The butterfly lays eggs on leaves.',
//         'es': 'La mariposa pone huevos en las hojas.'
//       },
//       'Caterpillar': {
//         'en': 'The egg hatches into a caterpillar.',
//         'es': 'El huevo se convierte en oruga.'
//       },
//       'Chrysalis': {
//         'en': 'The caterpillar forms a chrysalis.',
//         'es': 'La oruga forma una crisálida.'
//       },
//       'Adult Butterfly': {
//         'en': 'It emerges as a beautiful butterfly.',
//         'es': 'Emergió como una hermosa mariposa.'
//       },
//     },
//     'Frog': {
//       'Egg': {
//         'en': 'Frogs begin life as eggs in water.',
//         'es': 'Las ranas comienzan como huevos en el agua.'
//       },
//       'Tadpole': {
//         'en': 'The egg hatches into a tadpole.',
//         'es': 'El huevo se convierte en renacuajo.'
//       },
//       'Tadpole with Legs': {
//         'en': 'Tadpoles grow legs over time.',
//         'es': 'Los renacuajos desarrollan patas con el tiempo.'
//       },
//       'Adult Frog': {
//         'en': 'It becomes an adult frog that lives on land and water.',
//         'es': 'Se convierte en una rana adulta que vive en tierra y agua.'
//       },
//     }
//   };

//   List<String> userProgress = [];
//   String? lastTappedStage;
//   final Map<String, bool> shake = {};
//   final Map<String, bool> bounce = {};

//   @override
//   void initState() {
//     super.initState();
//     _confettiController = ConfettiController(duration: const Duration(seconds: 5));
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     tts.stop();
//     super.dispose();
//   }

//   void _speak(String text) async {
//     await tts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
//     await tts.setSpeechRate(0.5);
//     await tts.speak(text);
//   }

//   void _handleDrop(String droppedStage, int targetIndex) {
//     final correctSequence = sequences[widget.animal]!.map((s) => s['stage']!).toList();

//     if (correctSequence[targetIndex] == droppedStage) {
//       setState(() {
//         bounce[droppedStage] = true;
//         userProgress.insert(targetIndex, droppedStage);
//         lastTappedStage = droppedStage;
//       });

//       Future.delayed(const Duration(milliseconds: 700), () {
//         setState(() => bounce[droppedStage] = false);
//       });

//       final lessonText = stageLessons[widget.animal]?[droppedStage]?[isSpanish ? 'es' : 'en'];
//       if (lessonText != null) _speak(lessonText);

//       if (userProgress.length == correctSequence.length) {
//         _confettiController.play();
//         _speak(narrations[widget.animal]![isSpanish ? 'es' : 'en']!);
//         Future.delayed(const Duration(seconds: 4), () {
//           setState(() {
//             userProgress = [];
//             lastTappedStage = null;
//           });
//         });
//       }
//     } else {
//       setState(() => shake[droppedStage] = true);
//       _speak(isSpanish ? 'Inténtalo de nuevo' : 'Try again');
//       Future.delayed(const Duration(milliseconds: 600), () {
//         setState(() => shake[droppedStage] = false);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final options = List<Map<String, String>>.from(sequences[widget.animal]!);
//     final correctStages = options.map((e) => e['stage']!).toList();
//     final stageImages = {for (var item in options) item['stage']!: item['image']!};

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.animal} Life Cycle'),
//         backgroundColor: Colors.green.shade800,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Center(
//               child: TextButton(
//                 onPressed: () => setState(() => isSpanish = !isSpanish),
//                 child: Text(
//                   isSpanish ? 'Español 🇪🇸' : 'English 🇺🇸',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Wrap(
//                       spacing: 30,
//                       children: correctStages.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         String stage = entry.value;

//                         return DragTarget<String>(
//                           builder: (context, candidateData, rejectedData) {
//                             return AnimatedContainer(
//                               duration: const Duration(milliseconds: 400),
//                               transform: bounce[stage] == true
//                                   ? Matrix4.translationValues(0, -10.0, 0)
//                                   : Matrix4.identity(),
//                               width: 300,
//                               height: 300,
//                               margin: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.brown, width: 2),
//                                 color: userProgress.contains(stage)
//                                     ? Colors.green.shade100
//                                     : Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: userProgress.length > index
//                                   ? Image.asset(stageImages[stage]!, fit: BoxFit.cover)
//                                   : const Center(child: Text('?')),
//                             );
//                           },
//                           onWillAccept: (data) => true,
//                           onAccept: (data) => _handleDrop(data, index),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 20),
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: correctStages
//                           .where((stage) => !userProgress.contains(stage))
//                           .map((stage) => Draggable<String>(
//                                 data: stage,
//                                 feedback: Material(
//                                   child: Image.asset(stageImages[stage]!, width: 120, height: 120),
//                                 ),
//                                 childWhenDragging: Opacity(
//                                   opacity: 0.3,
//                                   child: Image.asset(stageImages[stage]!, width: 120, height: 120),
//                                 ),
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 400),
//                                   transform: shake[stage] == true
//                                       ? Matrix4.translationValues(10.0, 0, 0)
//                                       : Matrix4.identity(),
//                                   child: Image.asset(stageImages[stage]!, width: 120, height: 120),
//                                 ),
//                               ))
//                           .toList(),
//                     ),
//                     const SizedBox(height: 20),
//                     if (lastTappedStage != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Text(
//                           stageLessons[widget.animal]![lastTappedStage!]![isSpanish ? 'es' : 'en']!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: ConfettiWidget(
//               confettiController: _confettiController,
//               blastDirectionality: BlastDirectionality.explosive,
//               shouldLoop: false,
//               numberOfParticles: 30,
//               maxBlastForce: 20,
//               minBlastForce: 10,
//               emissionFrequency: 0.05,
//               colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:confetti/confetti.dart';

class LifeCyclesGamePage extends StatefulWidget {
  final String animal;
  const LifeCyclesGamePage({super.key, required this.animal});

  @override
  State<LifeCyclesGamePage> createState() => _LifeCyclesGamePageState();
}

class _LifeCyclesGamePageState extends State<LifeCyclesGamePage> with TickerProviderStateMixin {
  final FlutterTts tts = FlutterTts();
  late ConfettiController _confettiController;
  bool isSpanish = false;

  final Map<String, List<Map<String, String>>> sequences = {
    'Butterfly': [
      {'stage': 'Egg', 'image': 'assets/images/butterfly_eggs.jpg'},
      {'stage': 'Caterpillar', 'image': 'assets/images/caterpillar.jpg'},
      {'stage': 'Chrysalis', 'image': 'assets/images/chrysalis.jpg'},
      {'stage': 'Adult Butterfly', 'image': 'assets/images/adult_butterfly.jpg'},
    ],
    'Frog': [
      {'stage': 'Egg', 'image': 'assets/images/frog_egg.jpg'},
      {'stage': 'Tadpole', 'image': 'assets/images/tadpole.jpg'},
      {'stage': 'Tadpole with Legs', 'image': 'assets/images/froglet.jpg'},
      {'stage': 'Adult Frog', 'image': 'assets/images/frog_adult.jpg'},
    ],
  };

  final Map<String, Map<String, String>> narrations = {
    'Butterfly': {
      'en': 'A butterfly’s life starts as an egg, then caterpillar, chrysalis, and finally a butterfly!',
      'es': 'La vida de una mariposa comienza como un huevo, luego oruga, crisálida y finalmente mariposa.'
    },
    'Frog': {
      'en': 'A frog begins as an egg, becomes a tadpole, then grows legs, and becomes a frog!',
      'es': 'Una rana comienza como un huevo, se convierte en renacuajo, desarrolla patas y se convierte en rana.'
    },
  };

  final Map<String, Map<String, Map<String, String>>> stageLessons = {
    'Butterfly': {
      'Egg': {
        'en': 'The butterfly lays eggs on leaves.',
        'es': 'La mariposa pone huevos en las hojas.'
      },
      'Caterpillar': {
        'en': 'The egg hatches into a caterpillar.',
        'es': 'El huevo se convierte en oruga.'
      },
      'Chrysalis': {
        'en': 'The caterpillar forms a chrysalis.',
        'es': 'La oruga forma una crisálida.'
      },
      'Adult Butterfly': {
        'en': 'It emerges as a beautiful butterfly.',
        'es': 'Emergió como una hermosa mariposa.'
      },
    },
    'Frog': {
      'Egg': {
        'en': 'Frogs begin life as eggs in water.',
        'es': 'Las ranas comienzan como huevos en el agua.'
      },
      'Tadpole': {
        'en': 'The egg hatches into a tadpole.',
        'es': 'El huevo se convierte en renacuajo.'
      },
      'Tadpole with Legs': {
        'en': 'Tadpoles grow legs over time.',
        'es': 'Los renacuajos desarrollan patas con el tiempo.'
      },
      'Adult Frog': {
        'en': 'It becomes an adult frog that lives on land and water.',
        'es': 'Se convierte en una rana adulta que vive en tierra y agua.'
      },
    }
  };

  List<String> userProgress = [];
  String? lastTappedStage;
  final Map<String, bool> shake = {};
  final Map<String, bool> bounce = {};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    tts.stop();
    super.dispose();
  }

  void _speak(String text) async {
    await tts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  void _handleDrop(String droppedStage, int targetIndex) {
    final correctSequence = sequences[widget.animal]!.map((s) => s['stage']!).toList();

    if (correctSequence[targetIndex] == droppedStage) {
      setState(() {
        bounce[droppedStage] = true;
        userProgress.insert(targetIndex, droppedStage);
        lastTappedStage = droppedStage;
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() => bounce[droppedStage] = false);
      });

      final lessonText = stageLessons[widget.animal]?[droppedStage]?[isSpanish ? 'es' : 'en'];
      if (lessonText != null) _speak(lessonText);

      if (userProgress.length == correctSequence.length) {
        _confettiController.play();
        _speak(narrations[widget.animal]![isSpanish ? 'es' : 'en']!);
        Future.delayed(const Duration(seconds: 4), () {
          setState(() {
            userProgress = [];
            lastTappedStage = null;
          });
        });
      }
    } else {
      setState(() => shake[droppedStage] = true);
      _speak(isSpanish ? 'Inténtalo de nuevo' : 'Try again');
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() => shake[droppedStage] = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = List<Map<String, String>>.from(sequences[widget.animal]!);
    final correctStages = options.map((e) => e['stage']!).toList();
    final stageImages = {for (var item in options) item['stage']!: item['image']!};

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.animal} Life Cycle'),
        backgroundColor: Colors.green.shade800,
        actions: [
          TextButton(
            onPressed: () => setState(() => isSpanish = !isSpanish),
            child: Text(
              isSpanish ? 'Español 🇪🇸' : 'English 🇺🇸',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/forest_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 20,
                children: correctStages.asMap().entries.map((entry) {
                  int index = entry.key;
                  String stage = entry.value;

                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        transform: bounce[stage] == true
                            ? Matrix4.translationValues(0, -10.0, 0)
                            : Matrix4.identity(),
                        width: 330,
                        height: 450,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown, width: 3),
                          color: userProgress.length > index && userProgress[index] == stage
                              ? Colors.green.shade100
                              : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: userProgress.length > index && userProgress[index] == stage
                            ? Image.asset(stageImages[stage]!, fit: BoxFit.cover)
                            : const Center(child: Text('?', style: TextStyle(fontSize: 30))),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) => _handleDrop(data, index),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: correctStages
                    .where((stage) => !userProgress.contains(stage))
                    .map((stage) => Draggable<String>(
                          data: stage,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Image.asset(stageImages[stage]!, width: 120, height: 120),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Image.asset(stageImages[stage]!, width: 120, height: 120),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            transform: shake[stage] == true
                                ? Matrix4.translationValues(10.0, 0, 0)
                                : Matrix4.identity(),
                            child: Image.asset(stageImages[stage]!, width: 120, height: 120),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              if (lastTappedStage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.green.shade900, width: 2),
                    ),
                    child: Text(
                      stageLessons[widget.animal]![lastTappedStage!]![isSpanish ? 'es' : 'en']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }
}