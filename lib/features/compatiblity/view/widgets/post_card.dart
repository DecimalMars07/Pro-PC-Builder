import 'package:flutter/material.dart';

class PartCard extends StatelessWidget {
  final String name;
  final String specs;
  final double price;
  final VoidCallback onTap;

  // 1. ADD THIS NEW VARIABLE 👇
  final bool isSelected;

  const PartCard({
    super.key,
    required this.name,
    required this.specs,
    required this.price,
    required this.onTap,

    // 2. ADD IT TO THE CONSTRUCTOR, defaulting to 'false' 👇
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 DEFINE YOUR COLORS
    // Let's assume your app uses a dark Blue/Black theme

    const darkText = Color(
      0xFF0D0D2B,
    ); // Text color when selected (dark text on light background)
    const accentColor = Color.fromARGB(
      255,
      189,
      231,
      241,
    ); // Your app's main "pop" color

    return AnimatedContainer(
      // ⏱️ An AnimatedContainer makes the color swap look smooth!
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        // 3. SWAP THE CARD BACKGROUND COLOR 👇n
        // If selected: AccentColor (Light) | If normal: DarkBg (Dark)
        color: isSelected
            ? const Color.fromARGB(255, 241, 243, 243)
            : Color.fromARGB(255, 27, 70, 75),

        elevation: isSelected
            ? 10
            : 2, // Pop it forward visually when selected!
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.teal.shade400 : Colors.transparent,
            width: 2.5,
          ),
        ),

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // 4. SWAP THE TEXT COLOR 👇
                          color: isSelected ? darkText : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        specs,
                        style: TextStyle(
                          fontSize: 14,
                          // 5. SWAP THE SUBTITLE COLOR 👇
                          color: isSelected
                              ? darkText.withOpacity(0.8)
                              : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$$price",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // 6. SWAP THE PRICE COLOR 👇
                    // We want it green when normal, but dark contrast when background is green!
                    color: isSelected ? darkText : accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
