// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:flutter_tts/flutter_tts.dart';

// class DesertAnimalsApp extends StatefulWidget {
//   const DesertAnimalsApp({super.key});

//   @override
//   State<DesertAnimalsApp> createState() => _DesertAnimalsAppState();
// }

// class _DesertAnimalsAppState extends State<DesertAnimalsApp> {
//   int _currentPageIndex = 0;
//   final int _totalPages = 3;
//   final bool _isSpanish = false;
//   late FlutterTts flutterTts;
  
//   // List with all desert animals as shown in the image
//   final List<Map<String, dynamic>> _desertAnimals = [
//     {
//       'name': 'Fennec Fox',
//       'name_es': 'Zorro del Desierto',
//       'image': 'assets/images/fennec.jpg',
//       'description': 'Fennec foxes have large ears that help them stay cool in the hot desert.',
//       'description_es': 'Los zorros del desierto tienen orejas grandes que les ayudan a mantenerse frescos en el desierto caliente.'
//     },
//     {
//       'name': 'Camel',
//       'name_es': 'Camello',
//       'image': 'assets/images/camel.jpg',
//       'description': 'Camels store fat in their humps and can survive long periods without water.',
//       'description_es': 'Los camellos almacenan grasa en sus jorobas y pueden sobrevivir largos períodos sin agua.'
//     },
//     {
//       'name': 'Hawk',
//       'name_es': 'Halcón',
//       'image': 'assets/images/hawk.png',
//       'description': 'Desert hawks have excellent vision and can spot prey from high in the sky.',
//       'description_es': 'Los halcones del desierto tienen una excelente visión y pueden detectar presas desde lo alto del cielo.'
//     },
//     {
//       'name': 'Meerkat',
//       'name_es': 'Suricata',
//       'image': 'assets/images/meerkat.jpg',
//       'description': 'Meerkats live in groups and take turns watching for danger.',
//       'description_es': 'Los suricatas viven en grupos y se turnan para vigilar el peligro.'
//     },
//     {
//       'name': 'Gila Monster',
//       'name_es': 'Monstruo de Gila',
//       'image': 'assets/images/gila_monster.jpg',
//       'description': 'The Gila monster is one of the few venomous lizards in the world.',
//       'description_es': 'El monstruo de Gila es uno de los pocos lagartos venenosos del mundo.'
//     },
//     {
//       'name': 'Desert Tortoise',
//       'name_es': 'Tortuga del Desierto',
//       'image': 'assets/images/tortoise.png',
//       'description': 'Desert tortoises can live for 50-80 years and dig burrows to escape the heat.',
//       'description_es': 'Las tortugas del desierto pueden vivir de 50 a 80 años y cavan madrigueras para escapar del calor.'
//     },
//   ];

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
    
//     try {
//       // Initialize TTS with better settings
//       await flutterTts.setVolume(1.0);
//       await flutterTts.setSpeechRate(0.5);
//       await flutterTts.setPitch(1.0);
      
//       // Set up completion listener
//       flutterTts.setCompletionHandler(() {
//         // Optional: Show feedback when speech completes
//         print("TTS playback completed");
//       });
      
//       // Set up error listener
//       flutterTts.setErrorHandler((msg) {
//         print("TTS error: $msg");
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Voice error: $msg"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       });
//     } catch (e) {
//       print("Error initializing TTS: $e");
//     }
//   }

//   Future<void> _setLanguage(bool isSpanish) async {
//     await flutterTts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
//   }

//   Future<void> _speak(String text, bool isSpanish) async {
//     await _setLanguage(isSpanish);
//     await flutterTts.stop();
    
//     // Set volume and speech rate for better clarity
//     await flutterTts.setVolume(1.0);
//     await flutterTts.setSpeechRate(isSpanish ? 0.5 : 0.5); // Slower rate for better comprehension
//     await flutterTts.setPitch(1.0);
    
//     // Show loading indicator while preparing speech
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Loading voice..."),
//         duration: Duration(milliseconds: 800),
//       ),
//     );
    
//     // Add slight delay to ensure snackbar appears before speech starts
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     // Speak the text
//     var result = await flutterTts.speak(text);
    
//     // Check result and show error if needed
//     if (result != 1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Sorry, voice playback failed. Please try again."),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _goToNextPage() {
//     if (_currentPageIndex < _totalPages - 1) {
//       setState(() {
//         _currentPageIndex++;
//       });
//     }
//   }

//   void _goToPreviousPage() {
//     if (_currentPageIndex > 0) {
//       setState(() {
//         _currentPageIndex--;
//       });
//     }
//   }

//   void _onAnimalTap(Map<String, dynamic> animal) {
//     bool isSpeaking = false;
//     bool dialogIsSpanish = false; // Local language state for the dialog
    
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) => StatefulBuilder(
//         builder: (context, setDialogState) => Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFFF5F7FF), Color(0xFFE0F2FE)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 250,
//                   width: 250,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.asset(
//                       animal['image'],
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   dialogIsSpanish ? animal['name_es'] : animal['name'],
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2E3192),
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Color(0xFFBAE6FD), width: 2),
//                   ),
//                   child: Text(
//                     dialogIsSpanish ? animal['description_es'] : animal['description'],
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF333333),
//                       height: 1.4,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Language: ",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2E3192),
//                       ),
//                     ),
//                     Switch(
//                       value: dialogIsSpanish,
//                       activeColor: Color(0xFFFF6B6B),
//                       onChanged: (val) {
//                         setDialogState(() {
//                           dialogIsSpanish = val;
//                           // Stop any playing audio when language changes
//                           if (isSpeaking) {
//                             flutterTts.stop();
//                             isSpeaking = false;
//                           }
//                         });
//                       },
//                     ),
//                     Text(
//                       dialogIsSpanish ? "Spanish" : "English",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: dialogIsSpanish ? Color(0xFFFF6B6B) : Color(0xFF2E3192),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         final textToSpeak = dialogIsSpanish ? animal['description_es'] : animal['description'];
                        
//                         setDialogState(() {
//                           isSpeaking = !isSpeaking;
//                         });
                        
//                         if (isSpeaking) {
//                           _speak(textToSpeak, dialogIsSpanish).then((_) {
//                             if (context.mounted) {
//                               setDialogState(() {
//                                 isSpeaking = false;
//                               });
//                             }
//                           });
//                         } else {
//                           flutterTts.stop();
//                         }
//                       },
//                       icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
//                       label: Text(
//                         isSpeaking ? "Stop" : "Listen",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isSpeaking ? Color(0xFFFF6B6B) : Color(0xFFAAFFE5),
//                         foregroundColor: Color(0xFF40196D),
//                         elevation: 3,
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         flutterTts.stop();
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFE0E0E0),
//                         foregroundColor: Color(0xFF40196D),
//                         elevation: 2,
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         dialogIsSpanish ? "Cerrar" : "Close",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ).then((_) {
//       // Ensure TTS stops when dialog closes
//       flutterTts.stop();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Desert background with gradient sky
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/desser_bg.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
          
//           // Main content
//           SafeArea(
//             child: Stack(
//               children: [
//                 // Back button (hidden but functional)
//                 Positioned(
//                   top: 10,
//                   left: 20,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.transparent),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
                
//                 // Animal bubbles in custom positions to match the image exactly
//                 // Fennec Fox - top left
//                 Positioned(
//                   top: 20,
//                   left: 20,
//                   child: _buildAnimalBubble(_desertAnimals[0]),
//                 ),
                
//                 // Camel - top center
//                 Positioned(
//                   top: 20,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: _buildAnimalBubble(_desertAnimals[1]),
//                   ),
//                 ),
                
//                 // Hawk - top right
//                 Positioned(
//                   top: 20,
//                   right: 20,
//                   child: _buildAnimalBubble(_desertAnimals[2]),
//                 ),
                
//                 // Meerkat - center
//                 Positioned(
//                   top: 250,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: _buildAnimalBubble(_desertAnimals[3]),
//                   ),
//                 ),
                
//                 // Gila Monster - bottom left
//                 Positioned(
//                   top: 250,
//                   left: 40,
//                   child: _buildAnimalBubble(_desertAnimals[4]),
//                 ),
                
//                 // Desert Tortoise - bottom right
//                 Positioned(
//                   top: 250,
//                   right: 40,
//                   child: _buildAnimalBubble(_desertAnimals[5]),
//                 ),
                
//                 // Robot character in the center bottom
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
                
//                 // Navigation buttons at the bottom
//                 Positioned(
//                   bottom: 30,
//                   left: 0,
//                   right: 0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Left arrow button
//                       GestureDetector(
//                         onTap: _goToPreviousPage,
//                         child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFF9F4A),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: const Color(0xFF8B4513),
//                               width: 3,
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                       ),
                      
//                       // Right arrow button
//                       GestureDetector(
//                         onTap: _goToNextPage,
//                         child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFF9F4A),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: const Color(0xFF8B4513),
//                               width: 3,
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.arrow_forward,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildAnimalBubble(Map<String, dynamic> animal, {double size = 200}) {
//     return GestureDetector(
//       onTap: () => _onAnimalTap(animal),
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: const Color(0xFFFFF8E1),
//           border: Border.all(
//             color: Colors.amber.shade300,
//             width: 4,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.amber.withOpacity(0.5),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//             BoxShadow(
//               color: Colors.white.withOpacity(0.5),
//               blurRadius: 12,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             animal['image'],
//             fit: BoxFit.cover,
//             width: size,
//             height: size,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
      'description': 'Fennec foxes have large ears that help them stay cool in the hot desert.',
      'description_es': 'Los zorros del desierto tienen orejas grandes que les ayudan a mantenerse frescos en el desierto caliente.'
    },
    {
      'name': 'Camel',
      'name_es': 'Camello',
      'image': 'assets/images/camel.jpg',
      'description': 'Camels store fat in their humps and can survive long periods without water.',
      'description_es': 'Los camellos almacenan grasa en sus jorobas y pueden sobrevivir largos períodos sin agua.'
    },
    {
      'name': 'Hawk',
      'name_es': 'Halcón',
      'image': 'assets/images/hawk.png',
      'description': 'Desert hawks have excellent vision and can spot prey from high in the sky.',
      'description_es': 'Los halcones del desierto tienen una excelente visión y pueden detectar presas desde lo alto del cielo.'
    },
    {
      'name': 'Meerkat',
      'name_es': 'Suricata',
      'image': 'assets/images/meerkat.jpg',
      'description': 'Meerkats live in groups and take turns watching for danger.',
      'description_es': 'Los suricatas viven en grupos y se turnan para vigilar el peligro.'
    },
    {
      'name': 'Gila Monster',
      'name_es': 'Monstruo de Gila',
      'image': 'assets/images/gila_monster.jpg',
      'description': 'The Gila monster is one of the few venomous lizards in the world.',
      'description_es': 'El monstruo de Gila es uno de los pocos lagartos venenosos del mundo.'
    },
    {
      'name': 'Desert Tortoise',
      'name_es': 'Tortuga del Desierto',
      'image': 'assets/images/tortoise.png',
      'description': 'Desert tortoises can live for 50-80 years and dig burrows to escape the heat.',
      'description_es': 'Las tortugas del desierto pueden vivir de 50 a 80 años y cavan madrigueras para escapar del calor.'
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
//                 image: AssetImage('assets/images/desser_bg.png'),
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
//                     onPressed: () => Navigator.pushReplacementNamed(context, '/arctic'),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios),
//                     color: Colors.white,
//                     onPressed: () => Navigator.pushReplacementNamed(context, '/forest'),
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
//                     children: _desertAnimals.map((animal) {
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
                image: AssetImage('assets/images/desser_bg.png'),
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
                    onPressed: () => Navigator.pushReplacementNamed(context, '/arctic'),
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
                    onPressed: () => Navigator.pushReplacementNamed(context, '/forest'),
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
          "🏜️ Let's explore the desert habitat!",
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
                    children: _desertAnimals.map((animal) {
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
