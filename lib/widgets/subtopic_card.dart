// import 'package:flutter/material.dart';

// class SubtopicCard extends StatelessWidget {
//   final String title;
//   final String image;
//   final VoidCallback onTap;

//   const SubtopicCard({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.lightGreen.shade100, Colors.green.shade300],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 8,
//               offset: Offset(2, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(100),
//               decoration: BoxDecoration(
//                 color: Colors.white.withAlpha(220),
//                 shape: BoxShape.circle,
//               ),
//               child: Image.asset(
//                 image,
//                 height: 150,
//                 width : 200,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.brown,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// class SubtopicCard extends StatelessWidget {
//   final String title;
//   final String image;
//   final VoidCallback onTap;

//   const SubtopicCard({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.lightGreen.shade100, Colors.green.shade300],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 8,
//               offset: Offset(2, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 300,
//               width: 300,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: ClipOval(
//                 child: Image.asset(
//                   image,
//                   // fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.brown,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// class SubtopicCard extends StatelessWidget {
//   final String title;
//   final String image;
//   final VoidCallback onTap;

//   const SubtopicCard({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.lightGreen.shade100, Colors.green.shade300],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 8,
//               offset: Offset(2, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 150,
//               width: 150,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: ClipOval(
//                 child: Image.asset(
//                   image,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.brown,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

class SubtopicCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const SubtopicCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
