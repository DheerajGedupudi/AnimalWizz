import 'package:flutter/material.dart';

class DragDropQuizWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final bool showSpanish;
  final Function(bool) onAnswer;
  final VoidCallback onNext;

  const DragDropQuizWidget({
    super.key,
    required this.question,
    required this.showSpanish,
    required this.onAnswer,
    required this.onNext,
  });

  @override
  State<DragDropQuizWidget> createState() => _DragDropQuizWidgetState();
}

class _DragDropQuizWidgetState extends State<DragDropQuizWidget> {
  List<String> availableItems = [];
  List<String?> droppedItems = [];
  bool showFeedback = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initializeQuestion();
  }

  @override
  void didUpdateWidget(DragDropQuizWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question || 
        oldWidget.showSpanish != widget.showSpanish) {
      _initializeQuestion();
    }
  }

  void _initializeQuestion() {
    final items = widget.showSpanish 
        ? widget.question['items_es'] as List<dynamic>
        : widget.question['items_en'] as List<dynamic>;
    
    setState(() {
      availableItems = List<String>.from(items.map((item) => item.toString()))..shuffle();
      droppedItems = List.filled(items.length, null);
      showFeedback = false;
      isCorrect = false;
    });
  }

  void _checkAnswer() {
    final correctOrder = widget.showSpanish 
        ? widget.question['correct_order_es'] as List<dynamic>
        : widget.question['correct_order_en'] as List<dynamic>;
    
    final correctOrderStrings = correctOrder.map((item) => item.toString()).toList();
    
    isCorrect = true;
    for (int i = 0; i < droppedItems.length; i++) {
      if (droppedItems[i] != correctOrderStrings[i]) {
        isCorrect = false;
        break;
      }
    }

    setState(() {
      showFeedback = true;
    });
    
    widget.onAnswer(isCorrect);
    
    // If incorrect, reset after delay to allow trying again
    if (!isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _initializeQuestion();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionText = widget.showSpanish 
        ? widget.question['question_es'] as String
        : widget.question['question_en'] as String;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question text
        Text(
          questionText,
          style: TextStyle(
            fontSize: isLandscape ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isLandscape ? 8 : 15),
        
        // Drop targets container
        Expanded(
          flex: isLandscape ? 4 : 3,
          child: Container(
            padding: EdgeInsets.all(isLandscape ? 10 : 15),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.shade200, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  widget.showSpanish ? 'Orden correcto:' : 'Correct order:',
                  style: TextStyle(
                    fontSize: isLandscape ? 14 : 16, 
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: isLandscape ? 5 : 10),
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: droppedItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: isLandscape ? 2 : 4),
                        child: DragTarget<String>(
                          onAccept: (data) {
                            if (!showFeedback) {
                              setState(() {
                                availableItems.remove(data);
                                if (droppedItems[index] != null) {
                                  availableItems.add(droppedItems[index]!);
                                }
                                droppedItems[index] = data;
                              });
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            final correctOrder = widget.showSpanish 
                                ? widget.question['correct_order_es'] as List<dynamic>
                                : widget.question['correct_order_en'] as List<dynamic>;
                            final correctItem = correctOrder[index].toString();
                            
                            return Container(
                              height: isLandscape ? 35 : 45,
                              decoration: BoxDecoration(
                                color: showFeedback
                                    ? (droppedItems[index] == correctItem
                                        ? Colors.green.shade100
                                        : Colors.red.shade100)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: candidateData.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}.',
                                      style: TextStyle(
                                        fontSize: isLandscape ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: droppedItems[index] != null
                                        ? Draggable<String>(
                                            data: droppedItems[index]!,
                                            feedback: Material(
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  droppedItems[index]!,
                                                  style: TextStyle(fontSize: isLandscape ? 12 : 14),
                                                ),
                                              ),
                                            ),
                                            childWhenDragging: Container(),
                                            onDragCompleted: () {
                                              if (!showFeedback) {
                                                setState(() {
                                                  droppedItems[index] = null;
                                                });
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                droppedItems[index]!,
                                                style: TextStyle(fontSize: isLandscape ? 14 : 16),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: isLandscape ? 8 : 15),
        
        // Available items container
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(isLandscape ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.showSpanish ? 'Arrastra los elementos:' : 'Drag the items:',
                  style: TextStyle(
                    fontSize: isLandscape ? 12 : 14, 
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: isLandscape ? 4 : 8),
                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: isLandscape ? 4 : 8,
                      children: availableItems.map((item) {
                        return Draggable<String>(
                          data: item,
                          feedback: Material(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLandscape ? 12 : 16,
                                vertical: isLandscape ? 6 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: isLandscape ? 12 : 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLandscape ? 12 : 16,
                                vertical: isLandscape ? 6 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(fontSize: isLandscape ? 12 : 14),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isLandscape ? 12 : 16,
                              vertical: isLandscape ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: isLandscape ? 5 : 10),
        
        // Buttons section
        if (!showFeedback && droppedItems.every((item) => item != null))
          Center(
            child: ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? 25 : 30, 
                  vertical: isLandscape ? 8 : 12
                ),
              ),
              child: Text(
                widget.showSpanish ? 'Verificar' : 'Check Answer',
                style: TextStyle(fontSize: isLandscape ? 14 : 16),
              ),
            ),
          ),
        
        if (showFeedback) ...[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 15 : 20, 
                    vertical: isLandscape ? 6 : 10
                  ),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isCorrect
                        ? (widget.showSpanish ? '¡Correcto!' : 'Correct!')
                        : (widget.showSpanish ? 'Inténtalo de nuevo' : 'Try again'),
                    style: TextStyle(
                      fontSize: isLandscape ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                ),
                if (isCorrect) ...[
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? 20 : 25,
                        vertical: isLandscape ? 6 : 10,
                      ),
                    ),
                    child: Text(
                      widget.showSpanish ? 'Siguiente' : 'Next',
                      style: TextStyle(fontSize: isLandscape ? 14 : 16),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}