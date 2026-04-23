import 'package:flutter/material.dart';
import 'habitat_page.dart';
import 'coming_soon_page.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/selection_card.dart';
import '../widgets/responsive_grid.dart';

class JungleLessonsPage extends StatelessWidget {
  const JungleLessonsPage({super.key});

  static final List<Map<String, dynamic>> _lessons = [
    {
      'title': 'Habitats',
      'image': 'assets/images/habitat_forest.png',
      'color': Colors.green,
      'icon': Icons.landscape,
      'ready': true,
    },
    {
      'title': 'Animals',
      'image': 'assets/images/animal_habitats.png',
      'color': Colors.orange,
      'icon': Icons.pets,
      'ready': false,
    },
    {
      'title': 'Life Cycles',
      'image': 'assets/images/butterfly.png',
      'color': Colors.blue,
      'icon': Icons.refresh,
      'ready': false,
    },
    {
      'title': 'Food Chain',
      'image': 'assets/images/foodchain.png',
      'color': Colors.purple,
      'icon': Icons.restaurant,
      'ready': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final grid = ResponsiveGridConfig.of(context, tabletLandscapeCount: 4);

    return BackgroundScaffold(
      backgroundImage: 'assets/images/background.jpg',
      overlayColor: Colors.white.withOpacity(0.5),
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
                'Jungle Lessons',
                style: TextStyle(
                  fontSize: grid.isLandscape ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                  shadows: const [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.white,
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
                itemCount: _lessons.length,
                itemBuilder: (context, index) {
                  final lesson = _lessons[index];
                  return SelectionCard(
                    title: lesson['title'],
                    image: lesson['image'],
                    color: lesson['color'],
                    icon: lesson['icon'],
                    isReady: lesson['ready'] as bool,
                    onTap: () => _navigateToLesson(context, lesson),
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

  void _navigateToLesson(
      BuildContext context, Map<String, dynamic> lesson) {
    Widget destination;
    if (lesson['ready'] as bool) {
      switch (lesson['title']) {
        case 'Habitats':
          destination = const HabitatPage(config: desertConfig);
        default:
          return;
      }
    } else {
      destination = ComingSoonPage(
        topicName: lesson['title'],
        icon: lesson['icon'],
        color: lesson['color'],
      );
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }
}
