import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final bool isDragging;
  final VoidCallback? onSpeak;

  const FoodCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.color,
    this.isDragging = false,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDragging ? color.withOpacity(0.8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 4,
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSpeak,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Text(
                emoji,
                style: TextStyle(
                  fontSize: isDragging ? 60 : 56,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              // Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isDragging ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: isDragging ? Colors.white : color.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Speaker Icon
              if (onSpeak != null)
                Icon(
                  Icons.volume_up,
                  color: isDragging ? Colors.white : color.withOpacity(0.7),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
