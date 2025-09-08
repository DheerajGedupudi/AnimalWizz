import 'package:flutter/material.dart';
import 'pages/jungle_lessons.dart';
import 'pages/quiz_selection_page.dart';
import 'pages/desert_game_page.dart';
import 'pages/forest_game_page.dart';
import 'pages/arctic_game_page.dart';
import 'pages/ocean_game_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jungle Learning App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const JungleMainPage(),
        '/desert': (context) => const DesertAnimalsApp(),
        '/forest': (context) => const ForestAnimalsApp(),
        '/arctic': (context) => const ArcticAnimalsApp(),
        '/ocean' : (context) => const OceanAnimalsApp(),
      },
    );
  }
}

class JungleMainPage extends StatefulWidget {
  const JungleMainPage({super.key});

  @override
  State<JungleMainPage> createState() => _JungleMainPageState();
}

class _JungleMainPageState extends State<JungleMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 270,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/images/user_icon.png'),
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 15),
              const Text("Explorer Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Email: user@example.com", style: TextStyle(fontSize: 16)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text("Close"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
    final List<Widget> pages = [
      JungleHomePage(onNavigate: _onItemTapped),
      const JungleLessonsPage(),
      const QuizSelectionPage(), // Changed from JungleQuizPage()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 250, 1, 1),
            shadows: [
              Shadow(offset: Offset(0, 0), blurRadius: 15, color: Colors.white),
              Shadow(offset: Offset(2, 2), blurRadius: 8, color: Colors.white),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showProfileDialog,
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_icon.png'),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.green.shade700,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Lessons'),
              BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
            ],
          ),
        ),
      ),
    );
  }
}

class JungleHomePage extends StatelessWidget {
  final Function(int) onNavigate;
  const JungleHomePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('home_page'),
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/jungle_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hi Explorer 👋",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(2, 2))],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedCard(
                    context,
                    image: 'assets/images/video_icon.png',
                    label: 'Lessons',
                    onTap: () => onNavigate(1),
                    glowColor: Colors.greenAccent,
                  ),
                  const SizedBox(width: 30),
                  _buildAnimatedCard(
                    context,
                    image: 'assets/images/quiz_icon.png',
                    label: 'Quiz',
                    onTap: () => onNavigate(2),
                    glowColor: Colors.amberAccent,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Dive into an adventure of knowledge!\nLearn, play, and explore the jungle.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    shadows: [Shadow(blurRadius: 5, color: Colors.black45, offset: Offset(1, 1))],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCard(
    BuildContext context, {
    required String image,
    required String label,
    required VoidCallback onTap,
    required Color glowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(color: glowColor, blurRadius: 20, spreadRadius: 2)],
        ),
        child: Column(
          children: [
            Image.asset(image, height: 100, width: 175, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}