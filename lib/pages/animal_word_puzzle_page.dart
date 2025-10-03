import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimalWordPuzzlePage extends StatefulWidget {
  final String sectionName;
  
  const AnimalWordPuzzlePage({
    Key? key,
    required this.sectionName,
  }) : super(key: key);

  @override
  State<AnimalWordPuzzlePage> createState() => _AnimalWordPuzzlePageState();
}

class PuzzleWord {
  final int id;
  final String word;
  final String direction;
  final int row;
  final int col;

  PuzzleWord({
    required this.id,
    required this.word,
    required this.direction,
    required this.row,
    required this.col,
  });
}

class GridCell {
  String letter;
  String correct;
  int? wordId;
  int? number;
  bool isActive;
  FocusNode? focusNode;
  TextEditingController? controller;
  bool showingWrong;

  GridCell({
    this.letter = '',
    this.correct = '',
    this.wordId,
    this.number,
    this.isActive = false,
    this.focusNode,
    this.controller,
    this.showingWrong = false,
  });

  bool get isCorrect => letter == correct;
}

class _AnimalWordPuzzlePageState extends State<AnimalWordPuzzlePage> {
  late List<PuzzleWord> words;
  late List<List<GridCell?>> grid;
  int score = 0;
  bool hasShownDialog = false;
  bool showSpanish = false;
  
  final Map<int, String> animalImages = {
    1: 'assets/images/elephant.jpg',
    2: 'assets/images/sheep.png',
    3: 'assets/images/kangaroo.jpg',
    4: 'assets/images/cat.jpg',
  };

  final List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'text': '1. I am the largest land animal with a long trunk.',
      'spanish': '1. Soy el animal terrestre más grande con una trompa larga',
      'direction': 'down'
    },
    {
      'id': 2,
      'text': '2. I have woolly fur and say baa.',
      'spanish': '2. Tengo pelaje lanudo y digo bee',
      'direction': 'across'
    },
    {
      'id': 3,
      'text': '3. I hop and carry my baby in a pouch.',
      'spanish': '3. Salto y llevo a mi bebé en una bolsa',
      'direction': 'across'
    },
    {
      'id': 4,
      'text': '4. I am a furry pet that says meow.',
      'spanish': '4. Soy una mascota peluda que dice miau',
      'direction': 'across'
    },
  ];

  @override
  void initState() {
    super.initState();
    words = [
      PuzzleWord(id: 1, word: 'ELEPHANT', direction: 'down', row: 0, col: 2),
      PuzzleWord(id: 2, word: 'SHEEP', direction: 'across', row: 2, col: 0),
      PuzzleWord(id: 3, word: 'KANGAROO', direction: 'across', row: 5, col: 1),
      PuzzleWord(id: 4, word: 'CAT', direction: 'across', row: 7, col: 0),
    ];
    
    buildGrid();
  }

  @override
  void dispose() {
    for (var row in grid) {
      for (var cell in row) {
        cell?.focusNode?.dispose();
        cell?.controller?.dispose();
      }
    }
    super.dispose();
  }

  void buildGrid() {
    grid = List.generate(
      8,
      (_) => List.generate(9, (_) => null),
    );

    for (var word in words) {
      for (int i = 0; i < word.word.length; i++) {
        int r = word.direction == 'across' ? word.row : word.row + i;
        int c = word.direction == 'across' ? word.col + i : word.col;

        String correct = word.word[i];

        if (grid[r][c] == null) {
          grid[r][c] = GridCell(
            correct: correct,
            wordId: word.id,
            isActive: true,
            focusNode: FocusNode(),
            controller: TextEditingController(),
          );
        } else {
          grid[r][c]!.correct = correct;
        }
        
        if (i == 0) {
          grid[r][c]!.number = word.id;
        }
      }
    }
  }

  void handleCellInput(int row, int col, String value) {
    if (value.isEmpty || grid[row][col] == null) return;
    
    final cell = grid[row][col]!;
    final inputLetter = value.toUpperCase();
    
    if (inputLetter == cell.correct) {
      // Correct answer - keep it and move to next
      setState(() {
        cell.letter = inputLetter;
        cell.showingWrong = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          moveToNextCell(row, col);
          checkCompletion();
        }
      });
    } else {
      // Wrong answer - show in red, then clear
      setState(() {
        cell.letter = inputLetter;
        cell.showingWrong = true;
      });
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            cell.letter = '';
            cell.showingWrong = false;
          });
          // Clear the controller and keep focus
          cell.controller?.clear();
          cell.focusNode?.requestFocus();
        }
      });
    }
  }

  void moveToNextCell(int row, int col) {
    PuzzleWord? currentWord;
    for (var word in words) {
      if (word.direction == 'across' && word.row == row && col >= word.col && col < word.col + word.word.length) {
        currentWord = word;
        break;
      } else if (word.direction == 'down' && word.col == col && row >= word.row && row < word.row + word.word.length) {
        currentWord = word;
        break;
      }
    }

    if (currentWord != null) {
      int nextRow = row;
      int nextCol = col;
      
      if (currentWord.direction == 'across') {
        nextCol++;
        if (nextCol >= currentWord.col + currentWord.word.length) return;
      } else {
        nextRow++;
        if (nextRow >= currentWord.row + currentWord.word.length) return;
      }
      
      if (nextRow < grid.length && nextCol < grid[0].length && grid[nextRow][nextCol] != null) {
        grid[nextRow][nextCol]!.focusNode?.requestFocus();
      }
    }
  }

  bool get allCorrect {
    for (var row in grid) {
      for (var cell in row) {
        if (cell != null && cell.isActive) {
          if (!cell.isCorrect || cell.letter.isEmpty) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void checkCompletion() {
    if (allCorrect && !hasShownDialog) {
      hasShownDialog = true;
      
      int correctCount = 0;
      for (var row in grid) {
        for (var cell in row) {
          if (cell != null && cell.isActive && cell.isCorrect) {
            correctCount++;
          }
        }
      }
      score = correctCount * 10;
      
      Future.delayed(const Duration(milliseconds: 500), () {
        _showCompletionDialog();
      });
    }
  }

  void _showHintsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Animal Hints',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orange.shade300,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${question['id']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  animalImages[question['id']]!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.pets,
                                      size: 60,
                                      color: Colors.orange.shade300,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                words[index].word,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.orange.shade50,
          title: const Text(
            '🎉 Congratulations! 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You solved all the puzzles!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Score: $score points',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Back to Topics',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  for (var row in grid) {
                    for (var cell in row) {
                      if (cell != null) {
                        cell.letter = '';
                      }
                    }
                  }
                  score = 0;
                  hasShownDialog = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFEDD5),
              Color(0xFFFED7AA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? screenWidth * 0.05 : screenWidth * 0.03,
                  vertical: isLandscape ? screenHeight * 0.02 : screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.orange, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${widget.sectionName} Word Puzzle',
                            style: TextStyle(
                              fontSize: isLandscape ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap cells to fill in answers',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? screenWidth * 0.05 : screenWidth * 0.03,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.orange,
                            width: 3,
                          ),
                        ),
                        padding: EdgeInsets.all(isTablet ? 24 : 16),
                        child: Column(
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    grid.length,
                                    (i) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        grid[i].length,
                                        (j) {
                                          GridCell? cell = grid[i][j];
                                          double cellSize = isTablet ? 55 : 42;

                                          if (cell == null || !cell.isActive) {
                                            return Container(
                                              width: cellSize,
                                              height: cellSize,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),
                                              ),
                                            );
                                          }

                                          return Container(
                                            width: cellSize,
                                            height: cellSize,
                                            decoration: BoxDecoration(
                                              color: cell.showingWrong
                                                  ? Colors.red.shade100
                                                  : (cell.letter.isNotEmpty && cell.isCorrect
                                                      ? Colors.green.shade100
                                                      : Colors.white),
                                              border: Border.all(
                                                color: cell.showingWrong
                                                    ? Colors.red.shade400
                                                    : Colors.orange.shade300,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                if (cell.number != null)
                                                  Positioned(
                                                    top: 2,
                                                    left: 2,
                                                    child: Text(
                                                      '${cell.number}',
                                                      style: TextStyle(
                                                        fontSize: isTablet ? 11 : 9,
                                                        color: Colors.orange.shade700,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                Center(
                                                  child: TextField(
                                                    key: ValueKey('${i}_${j}'),
                                                    controller: cell.controller,
                                                    focusNode: cell.focusNode,
                                                    textAlign: TextAlign.center,
                                                    maxLength: 1,
                                                    style: TextStyle(
                                                      fontSize: isTablet ? 24 : 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: cell.showingWrong
                                                          ? Colors.red.shade700
                                                          : Colors.orange.shade900,
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      counterText: '',
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      FilteringTextInputFormatter.allow(
                                                        RegExp('[a-zA-Z]'),
                                                      ),
                                                      UpperCaseTextFormatter(),
                                                    ],
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty) {
                                                        handleCellInput(i, j, value);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet ? 20 : 16),

                            ElevatedButton.icon(
                              onPressed: () {
                                _showHintsDialog();
                              },
                              icon: const Icon(Icons.lightbulb_outline),
                              label: const Text(
                                'Show Animal Hints',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black87,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 32 : 24,
                                  vertical: isTablet ? 16 : 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isLandscape ? screenHeight * 0.02 : screenHeight * 0.03),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.orange,
                            width: 3,
                          ),
                        ),
                        padding: EdgeInsets.all(isTablet ? 24 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'QUESTIONS :',
                                  style: TextStyle(
                                    fontSize: isTablet ? 26 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'English',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: showSpanish ? FontWeight.normal : FontWeight.bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Switch(
                                      value: showSpanish,
                                      onChanged: (value) {
                                        setState(() {
                                          showSpanish = value;
                                        });
                                      },
                                      activeColor: Colors.orange,
                                    ),
                                    Text(
                                      'Español',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: showSpanish ? FontWeight.bold : FontWeight.normal,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 16 : 12),

                            ...questions.map((q) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  showSpanish ? q['spanish'] : q['text'],
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      SizedBox(height: isLandscape ? screenHeight * 0.02 : screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}