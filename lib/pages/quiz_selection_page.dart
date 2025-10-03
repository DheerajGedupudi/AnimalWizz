import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'habitat_game_page.dart';
import 'animal_word_puzzle_page.dart';

class QuizSelectionPage extends StatelessWidget {
  const QuizSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    final List<Map<String, dynamic>> quizSections = [
      {
        'title': 'Animals',
        'image': 'assets/images/lion.jpg',
        'color': Colors.orange,
        'icon': Icons.pets,
      },
      {
        'title': 'Habitats',
        'image': 'assets/images/forest_bg.png',
        'color': Colors.green,
        'icon': Icons.landscape,
      },
      {
        'title': 'Word Puzzle',
        'image': 'assets/images/word.jpg',
        'color': Colors.deepOrange,
        'icon': Icons.grid_4x4,
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
    ];

    int crossAxisCount;
    double childAspectRatio;

    if (isTablet && isLandscape) {
      crossAxisCount = 5;
      childAspectRatio = 0.8;
    } else if (isTablet && !isLandscape) {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    } else if (!isTablet && isLandscape) {
      crossAxisCount = 3;
      childAspectRatio = 1.0;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/quiz_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? screenWidth * 0.05 : screenWidth * 0.03,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: isLandscape ? screenHeight * 0.02 : screenHeight * 0.03,
                    bottom: isLandscape ? screenHeight * 0.01 : screenHeight * 0.02,
                  ),
                  child: Text(
                    'Choose Your Quiz Topic',
                    style: TextStyle(
                      fontSize: isLandscape ? 28 : 32,
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
                      vertical: isLandscape ? screenHeight * 0.01 : screenHeight * 0.02,
                      horizontal: isTablet && isLandscape ? screenWidth * 0.05 : 0,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: isLandscape ? screenHeight * 0.04 : screenHeight * 0.03,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: quizSections.length,
                    itemBuilder: (context, index) {
                      final section = quizSections[index];

                      return GestureDetector(
                        onTap: () {
                          if (section['title'] == 'Habitats') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HabitatGamePage(),
                              ),
                            );
                          } else if (section['title'] == 'Word Puzzle') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AnimalWordPuzzlePage(
                                  sectionName: 'Animals',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JungleQuizPage(
                                  sectionName: section['title'],
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: section['color'].withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: section['color'],
                              width: 4,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isLandscape ? 10 : 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: isLandscape ? 3 : 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: section['color'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        section['image'],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              section['icon'],
                                              size: isLandscape ? 40 : 50,
                                              color: section['color'],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isLandscape ? 5 : 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    section['title'],
                                    style: TextStyle(
                                      fontSize: isLandscape && isTablet ? 18 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: section['color'],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: isLandscape ? screenHeight * 0.01 : screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}