import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FoodChainGamePage extends StatefulWidget {
  const FoodChainGamePage({super.key});

  @override
  State<FoodChainGamePage> createState() => _FoodChainGamePageState();
}

class _FoodChainGamePageState extends State<FoodChainGamePage> {
  final FlutterTts flutterTts = FlutterTts();
  final Map<String, bool> slotStatus = {
    'producer': false,
    'primary': false,
    'secondary': false,
    'tertiary': false,
  };

  final Map<String, String> itemPositions = {
    'producer': '',
    'primary': '',
    'secondary': '',
    'tertiary': '',
  };

  final List<Map<String, dynamic>> foodChainInfo = [
    {
      'category': 'producer',
      'label': 'Producer',
      'label_es': 'Productor',
      'image': 'assets/images/grass.jpg',
      'description': 'Producers like grass make their own food using sunlight (photosynthesis).',
      'description_es': 'Los productores como el pasto hacen su propia comida usando la luz solar (fotosíntesis).'
    },
    {
      'category': 'primary',
      'label': 'Primary Consumer',
      'label_es': 'Consumidor primario',
      'image': 'assets/images/grasshopper.webp',
      'description': 'Primary consumers like grasshoppers eat producers to get energy.',
      'description_es': 'Los consumidores primarios como los saltamontes comen productores para obtener energía.'
    },
    {
      'category': 'secondary',
      'label': 'Secondary Consumer',
      'label_es': 'Consumidor secundario',
      'image': 'assets/images/snake.webp',
      'description': 'Secondary consumers like snakes eat primary consumers.',
      'description_es': 'Los consumidores secundarios como las serpientes comen consumidores primarios.'
    },
    {
      'category': 'tertiary',
      'label': 'Tertiary Consumer',
      'label_es': 'Consumidor terciario',
      'image': 'assets/images/hawk.png',
      'description': 'Tertiary consumers like hawks are at the top of the food chain.',
      'description_es': 'Los consumidores terciarios como los halcones están en la cima de la cadena alimentaria.'
    },
  ];

  final String chainSummary =
      'The food chain starts with the grass, which is a producer. It makes its own food using sunlight. '
      'The grasshopper, a primary consumer, eats the grass. The snake, a secondary consumer, eats the grasshopper. '
      'Finally, the hawk, a tertiary consumer, eats the snake. This shows how energy flows from one organism to another in a natural ecosystem.';

  final String chainSummaryEs =
      'La cadena alimentaria comienza con el pasto, que es un productor. Produce su propio alimento usando la luz solar. '
      'El saltamontes, un consumidor primario, se alimenta del pasto. La serpiente, un consumidor secundario, se come al saltamontes. '
      'Finalmente, el halcón, un consumidor terciario, se alimenta de la serpiente. Esto muestra cómo fluye la energía de un organismo a otro en un ecosistema natural.';

  List<DraggableItem> draggableItems = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    draggableItems = foodChainInfo
        .map((item) => DraggableItem(
              imagePath: item['image'],
              label: item['label'],
              category: item['category'],
            ))
        .toList();
    draggableItems.shuffle(Random());
  }

  void handleResult(String slot, bool correct) {
    if (correct) {
      setState(() {
        slotStatus[slot] = true;
        itemPositions[slot] = foodChainInfo.firstWhere((item) => item['category'] == slot)['image'];
        draggableItems.removeWhere((item) => item.category == slot);
        score += 100;
      });

      showItemInfoDialog(slot);

      if (slotStatus.values.every((status) => status)) {
        flutterTts.stop();
        Future.delayed(const Duration(milliseconds: 500), () => showChainSummaryDialog());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Try Again"), backgroundColor: Colors.red, duration: Duration(milliseconds: 500)),
      );
    }
  }

  void showItemInfoDialog(String category) {
    final item = foodChainInfo.firstWhere((element) => element['category'] == category);
    bool isSpanish = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(isSpanish ? item['label_es'] : item['label']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(item['image'], width: 120, height: 120),
                const SizedBox(height: 10),
                Text(
                  isSpanish ? item['description_es'] : item['description'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _speak(isSpanish ? item['description_es'] : item['description'], isSpanish),
                    ),
                    const SizedBox(width: 10),
                    Switch(value: isSpanish, onChanged: (val) => setState(() => isSpanish = val)),
                    Text(isSpanish ? 'Español' : 'English'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  flutterTts.stop();
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },
    );
  }

  void showChainSummaryDialog() {
    bool isSpanish = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              isSpanish ? "Cadena Alimentaria" : "Food Chain",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSpanish ? chainSummaryEs : chainSummary,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.deepPurple),
                      onPressed: () => _speak(isSpanish ? chainSummaryEs : chainSummary, isSpanish),
                    ),
                    const SizedBox(width: 10),
                    Switch(value: isSpanish, onChanged: (val) => setState(() => isSpanish = val)),
                    Text(isSpanish ? 'Español' : 'English'),
                  ],
                )
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    flutterTts.stop();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    setState(() {
                      resetGame();
                      score = 0;
                      itemPositions.updateAll((key, value) => '');
                      slotStatus.updateAll((key, value) => false);
                    });
                  },
                  child: const Text("Play Again", style: TextStyle(color: Colors.deepPurple)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _speak(String text, bool isSpanish) async {
    await flutterTts.setLanguage(isSpanish ? "es-ES" : "en-US");
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Food Chain Game"), backgroundColor: Colors.green),
      body: Container(
        color: Colors.lightGreen[50],
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("Drag each item to its correct place in the food chain", style: TextStyle(fontSize: isTablet ? 22 : 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: foodChainInfo
                  .expand((item) => [
                        FoodChainSlot(
                          label: item['label'],
                          expectedCategory: item['category'],
                          onAcceptResult: (correct) => handleResult(item['category'], correct),
                          isLocked: (itemPositions[item['category']] ?? '').isNotEmpty,
                          itemPositions: itemPositions,
                        ),
                        if (item['category'] != 'tertiary') AnimatedArrow(),
                      ])
                  .toList(),
            ),
            const SizedBox(height: 30),
            Wrap(spacing: 30, runSpacing: 20, children: draggableItems),
            const SizedBox(height: 20),
            Text("Score: $score", style: TextStyle(fontSize: isTablet ? 24 : 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class AnimatedArrow extends StatefulWidget {
  @override
  _AnimatedArrowState createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 10 * sin(_controller.value * 2 * pi)),
        child: const Icon(Icons.arrow_forward, color: Colors.green, size: 70),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DraggableItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final String category;

  const DraggableItem({required this.imagePath, required this.label, required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: category,
      feedback: _buildItem(opacity: 0.7),
      childWhenDragging: _buildItem(opacity: 0.3),
      child: _buildItem(),
    );
  }

  Widget _buildItem({double opacity = 1.0}) {
    return Column(
      children: [
        Opacity(opacity: opacity, child: Image.asset(imagePath, width: 120, height: 120)),
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class FoodChainSlot extends StatelessWidget {
  final String expectedCategory;
  final String label;
  final Function(bool) onAcceptResult;
  final bool isLocked;
  final Map<String, String> itemPositions;

  const FoodChainSlot({required this.expectedCategory, required this.label, required this.onAcceptResult, required this.isLocked, required this.itemPositions, super.key});

  @override
  Widget build(BuildContext context) {
    Color slotColor = {
      'producer': Colors.green[100],
      'primary': Colors.orange[100],
      'secondary': Colors.blue[100],
      'tertiary': Colors.red[100],
    }[expectedCategory]!;

    return DragTarget<String>(
      onAccept: (data) => onAcceptResult(data == expectedCategory),
      builder: (context, candidateData, rejectedData) => Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: isLocked ? slotColor.withOpacity(0.5) : slotColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
        ),
        alignment: Alignment.center,
        child: isLocked
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  itemPositions[expectedCategory] ?? '',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
