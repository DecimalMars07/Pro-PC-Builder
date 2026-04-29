import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pc_builder/bloc/builder_bloc.dart';
import '../../pc_builder/bloc/builder_state.dart';

// 🚨 Make sure to import your exact Bloc and State files here!
// import 'package:pc_part_picker/features/pc_builder/bloc/builder_bloc.dart';
// import 'package:pc_part_picker/features/pc_builder/bloc/builder_state.dart';

class ReviewBuildScreen extends StatelessWidget {
  const ReviewBuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Matching your dark theme
      appBar: AppBar(
        title: const Text('Build Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<BuilderBloc, BuilderState>(
        builder: (context, state) {
          // 🚨 1. TYPE PROMOTION: We only build the UI if the state is successfully loaded!
          if (state is BuilderLoaded) {

            // 🧠 2. THE LOGIC
            final double totalPrice = _calculateTotal(state);
            final int totalWattage = _calculateWattage(state);

            final bool hasPsu = state.selectedPsu != null;
            final int psuWattage = state.selectedPsu?.wattage ?? 0;
            final bool isPowerSufficient = psuWattage >= totalWattage;

            // Check if they actually selected anything at all
            final bool hasAnyParts = state.selectedCpu != null ||
                state.selectedGpu != null ||
                state.selectedMotherboard != null ||
                state.selectedPsu != null ||
                state.selectedRam != null ||
                state.selectedSsd != null;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // ⚡ COMPATIBILITY CHECKER (Handles Empty, Safe, and Warning states)
                _buildCompatibilityCard(isPowerSufficient, psuWattage, totalWattage, hasPsu),
                const SizedBox(height: 24),

                // 🛒 THE RECEIPT (Parts List)
                const Text(
                  'Your Components',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),

                // Spread operator to drop our list of parts right here
                ..._buildPartList(state),

                const Divider(color: Colors.white24, height: 40, thickness: 1),

                // 💰 FINAL PRICE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price', style: TextStyle(fontSize: 22, color: Colors.white)),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 🚀 FINISH BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Gray out the button if the cart is empty!
                      backgroundColor: hasAnyParts ? Colors.blueAccent : Colors.grey[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    // Disable the button (pass null) if no parts are selected
                    onPressed: hasAnyParts ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Build Saved Successfully! 🚀'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } : null,
                    child: Text(
                      hasAnyParts ? 'Save & Finish' : 'Add parts to continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: hasAnyParts ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
          }

          // If the state is Initial or Loading, show a spinner
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        },
      ),
    );
  }

  // --- HELPER WIDGETS & LOGIC ---

  Widget _buildCompatibilityCard(bool isSafe, int psuWatt, int totalWatt, bool hasPsu) {
    // 🟧 EMPTY STATE: No PSU selected yet
    if (!hasPsu) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orangeAccent),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orangeAccent, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Missing Power Supply',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orangeAccent),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select a PSU to see if your build has enough power.',
                    style: TextStyle(color: Colors.white70),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    // 🟩 SAFE STATE / 🟥 WARNING STATE
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSafe ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSafe ? Colors.green : Colors.redAccent),
      ),
      child: Row(
        children: [
          Icon(isSafe ? Icons.check_circle : Icons.warning_amber_rounded,
              color: isSafe ? Colors.green : Colors.redAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSafe ? 'Power Delivery Safe' : 'Power Warning!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                      color: isSafe ? Colors.green : Colors.redAccent),
                ),
                const SizedBox(height: 4),
                Text(
                  isSafe
                      ? 'Your ${psuWatt}W PSU can safely handle the estimated ${totalWatt}W draw.'
                      : 'Your build needs ~${totalWatt}W, but your PSU is only ${psuWatt}W. It might crash under load!',
                  style: const TextStyle(color: Colors.white70),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🚨 Notice it accepts BuilderLoaded now!
  List<Widget> _buildPartList(BuilderLoaded state) {
    final List<Widget> list = [];

    // Safely adds a row only if the part isn't null
    void addPart(String category, dynamic part) {
      if (part != null) {
        // We use try-catch to safely grab the name or brand without crashing if properties differ
        String displayName = 'Unknown Part';
        try {
          // If it's a GPU with a brand, use that. Otherwise, default to the part name.
          displayName = part.name;
        } catch (e) {
          displayName = 'Component';
        }

        list.add(
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              title: Text(
                displayName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(category, style: const TextStyle(color: Colors.grey)),
              trailing: Text(
                '\$${part.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
        );
      }
    }

    // Add all your parts here matching your exact state variables
    addPart('Processor', state.selectedCpu);
    addPart('Motherboard', state.selectedMotherboard);
    addPart('Graphics Card', state.selectedGpu);
    addPart('Memory (RAM)', state.selectedRam);
    addPart('Storage (SSD)', state.selectedSsd);
    addPart('Power Supply', state.selectedPsu);

    // If the list is empty, show a friendly placeholder
    if (list.isEmpty) {
      list.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'No parts selected yet.',
                style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
              ),
            ),
          )
      );
    }

    return list;
  }

  // 🚨 Notice it accepts BuilderLoaded now!
  double _calculateTotal(BuilderLoaded state) {
    return (state.selectedCpu?.price ?? 0) +
        (state.selectedGpu?.price ?? 0) +
        (state.selectedPsu?.price ?? 0) +
        (state.selectedMotherboard?.price ?? 0) +
        (state.selectedRam?.price ?? 0) +
        (state.selectedSsd?.price ?? 0);
  }

  // 🚨 Notice it accepts BuilderLoaded now!
  int _calculateWattage(BuilderLoaded state) {
    // CPU TDP + GPU TGP + 50W Buffer for Motherboard/Fans/RAM
    return (state.selectedCpu?.tdp ?? 0) +
        (state.selectedGpu?.tgp ?? 0) +
        50;
  }
}