// // lib/pages/subtopic_detail_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class SubtopicDetailPage extends StatefulWidget {
//   final String subtopicTitle;
//   final String imagePath;

//   const SubtopicDetailPage({
//     super.key,
//     required this.subtopicTitle,
//     required this.imagePath,
//   });

//   @override
//   State<SubtopicDetailPage> createState() => _SubtopicDetailPageState();
// }

// class _SubtopicDetailPageState extends State<SubtopicDetailPage> {
//   late FlutterTts flutterTts;
//   bool isSpanish = false;

//   final Map<String, String> descriptions = {
//     'herbivores': 'Herbivores eat only plants. They have flat teeth to help grind food.',
//     'carnivores': 'Carnivores eat other animals. They are strong predators.',
//     'omnivores': 'Omnivores eat both plants and animals.',
//     'rainforest': 'Rainforests are hot, dense forests with lots of rain and animals.',
//     'desert': 'Deserts are dry and hot places with very little rain.',
//     'butterfly': 'Butterflies go through metamorphosis and help pollinate flowers.',
//     'frog': 'Frogs start as eggs, become tadpoles, and grow into adults.',
//     'producers & consumers': 'Producers make their own food. Consumers eat other organisms.',
//   };

//   @override
//   void initState() {
//     super.initState();
//     flutterTts = FlutterTts();
//     _setLanguage();
//   }

//   Future<void> _setLanguage() async {
//     await flutterTts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
//   }

//   Future<void> _speak() async {
//     await _setLanguage();
//     String key = widget.subtopicTitle.toLowerCase();
//     String text = descriptions[key] ?? 'No description available.';
//     await flutterTts.speak(text);
//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.subtopicTitle),
//         backgroundColor: Colors.green.shade800,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/frame.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Card(
//               elevation: 12,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset(widget.imagePath, height: 150),
//                     const SizedBox(height: 20),
//                     Text(
//                       descriptions[widget.subtopicTitle.toLowerCase()] ?? 'No description available.',
//                       style: const TextStyle(fontSize: 18),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Language: "),
//                         Switch(
//                           value: isSpanish,
//                           onChanged: (val) {
//                             setState(() {
//                               isSpanish = val;
//                             });
//                           },
//                         ),
//                         Text(isSpanish ? "Spanish" : "English"),
//                       ],
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _speak,
//                       icon: const Icon(Icons.volume_up),
//                       label: const Text("Play Voiceover"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

class SubtopicDetailPage extends StatelessWidget {
  final String subtopicTitle;

  const SubtopicDetailPage({super.key, required this.subtopicTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subtopicTitle)),
      body: Center(
        child: Text('Lesson for $subtopicTitle coming soon!', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
