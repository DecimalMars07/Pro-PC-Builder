import 'package:flutter/material.dart';

class ComponentSlot extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? selectedName;
  final double? price;
  final VoidCallback onRemove;

  // We bring in the colors so it matches your theme perfectly
  static const Color bgColor = Color(0xFF0F172A);
  static const Color surfaceColor = Color(0xFF1E293B);
  static const Color accentColor = Colors.cyanAccent;
  static const Color textMuted = Color(0xFF94A3B8);

  const  ComponentSlot({
    super.key,
    required this.title,
    required this.icon,
    required this.selectedName,
    required this.price,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = selectedName == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEmpty ? Colors.transparent : accentColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: isEmpty
            ? []
            : [
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isEmpty ? textMuted : accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEmpty ? "Tap a part below to Select" : selectedName!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
                    color: isEmpty ? Colors.white54 : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (!isEmpty) ...[
            Text(
              "\$${price?.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white54),
              onPressed: onRemove,
            ),
          ],
        ],
      ),
    );
  }
}
