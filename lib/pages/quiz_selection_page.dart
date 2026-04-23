import 'package:flutter/material.dart';
import 'unified_quiz_page.dart';
import '../data/quiz_questions.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/selection_card.dart';
import '../widgets/responsive_grid.dart';

class QuizSelectionPage extends StatelessWidget {
  const QuizSelectionPage({super.key});

  static final List<Map<String, dynamic>> _quizSections = [
    {
      'title': 'Animals',
      'image': 'assets/images/lion.jpg',
      'color': Colors.orange,
      'icon': Icons.pets,
    },
    {
      'title': 'Habitats',
      'image': 'assets/images/animal_habitats.png',
      'color': Colors.green,
      'icon': Icons.landscape,
    },
    {
      'title': 'Life Cycles',
      'image': 'assets/images/butterfly.png',
      'color': Colors.blue,
      'icon': Icons.refresh,
    },
    {
      'title': 'Food Chain',
      'image': 'assets/images/foodchain.png',
      'color': Colors.purple,
      'icon': Icons.restaurant,
    },
    {
      'title': 'Feed Animals',
      'image': 'assets/images/elephant.jpg',
      'color': Colors.pink,
      'icon': Icons.fastfood,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final grid = ResponsiveGridConfig.of(context);

    return BackgroundScaffold(
      backgroundImage: 'assets/images/quiz_background.png',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: grid.horizontalPadding),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: grid.topPadding,
                bottom: grid.bottomPadding,
              ),
              child: Text(
                'Choose Your Quiz Topic',
                style: TextStyle(
                  fontSize: grid.isLandscape ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: grid.gridVerticalPadding,
                  horizontal: grid.gridHorizontalPadding,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid.crossAxisCount,
                  crossAxisSpacing: grid.crossAxisSpacing,
                  mainAxisSpacing: grid.mainAxisSpacing,
                  childAspectRatio: grid.childAspectRatio,
                ),
                itemCount: _quizSections.length,
                itemBuilder: (context, index) {
                  final section = _quizSections[index];
                  return SelectionCard(
                    title: section['title'],
                    image: section['image'],
                    color: section['color'],
                    icon: section['icon'],
                    onTap: () => _navigateToQuiz(context, section['title']),
                  );
                },
              ),
            ),
            SizedBox(height: grid.bottomPadding),
          ],
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context, String title) {
    final config = switch (title) {
      'Animals' => animalsQuizConfig,
      'Habitats' => habitatsQuizConfig,
      'Life Cycles' => lifeCyclesQuizConfig,
      'Food Chain' => foodChainQuizConfig,
      'Feed Animals' => feedAnimalsQuizConfig,
      _ => animalsQuizConfig,
    };
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UnifiedQuizPage(config: config)),
    );
  }
}
