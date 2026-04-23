import 'package:flutter/material.dart';
import 'memory_game_page.dart';
import 'food_chain_game_page.dart';
import 'life_cycles_game_page.dart';
import 'animal_word_puzzle_page.dart';
import 'tracking_quiz_page.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/selection_card.dart';
import '../widgets/responsive_grid.dart';

class GamesSelectionPage extends StatelessWidget {
  const GamesSelectionPage({super.key});

  static final List<Map<String, dynamic>> _games = [
    {
      'title': 'Memory Match',
      'image': 'assets/images/owl.jpg',
      'color': Colors.teal,
      'icon': Icons.grid_view_rounded,
    },
    {
      'title': 'Word Puzzle',
      'image': 'assets/images/word.jpg',
      'color': Colors.deepOrange,
      'icon': Icons.grid_4x4,
    },
    {
      'title': 'Animal Detective',
      'image': 'assets/images/fox.jpg',
      'color': Colors.indigo,
      'icon': Icons.search,
    },
    {
      'title': 'Food Chain',
      'image': 'assets/images/foodchain.png',
      'color': Colors.purple,
      'icon': Icons.restaurant,
    },
    {
      'title': 'Life Cycles',
      'image': 'assets/images/butterfly.png',
      'color': Colors.blue,
      'icon': Icons.refresh,
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
                'Choose Your Game',
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
                itemCount: _games.length,
                itemBuilder: (context, index) {
                  final game = _games[index];
                  return SelectionCard(
                    title: game['title'],
                    image: game['image'],
                    color: game['color'],
                    icon: game['icon'],
                    onTap: () => _navigateToGame(context, game['title']),
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

  void _navigateToGame(BuildContext context, String title) {
    Widget destination;
    switch (title) {
      case 'Memory Match':
        destination = const MemoryGamePage(
          lessonTitle: 'All Animals',
          lessonImage: 'assets/images/animal_habitats.png',
        );
      case 'Word Puzzle':
        destination = const AnimalWordPuzzlePage(sectionName: 'Animals');
      case 'Animal Detective':
        destination = const TrackingQuizPage();
      case 'Food Chain':
        destination = const FoodChainGamePage();
      case 'Life Cycles':
        destination = const LifeCyclesGamePage(animal: 'Butterfly');
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }
}
