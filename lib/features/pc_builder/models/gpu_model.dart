class GpuModel {
  // --- 1. DERIVED FIELDS (Required for our app's UI and Compatibility Engine) ---
  final String id;
  final String brand;
  final int tgp; // ✅ Corrected to Total Graphics Power!

  // --- 2. API FIELDS (Exactly matching the GitHub dataset) ---
  final String name;
  final String chipset;
  final int memoryGb;
  final double price;

  GpuModel({
    required this.id,
    required this.brand,
    required this.tgp,
    required this.name,
    required this.chipset,
    required this.memoryGb,
    required this.price,
  });

  // 🧠 The Dynamic Tier-Based Wattage Estimator
  static int _determineWattage(String? chipset) {
    if (chipset == null) return 200; // Safe fallback

    final c = chipset.toLowerCase();

    // 1. Ultra Enthusiast Tier (e.g., RTX 4090, RTX 5090, RX 7900 XTX)
    if (c.contains('90 ') || c.endsWith('90') || c.contains('900')) return 400;

    // 2. High-End Tier (e.g., RTX 4080, RTX 5080, RX 7800 XT)
    if (c.contains('80 ') || c.endsWith('80') || c.contains('800')) return 320;

    // 3. Mid-High Tier (e.g., RTX 4070, RTX 5070, RX 7700 XT)
    if (c.contains('70 ') || c.endsWith('70') || c.contains('700')) return 220;

    // 4. Mid-Range Tier (e.g., RTX 4060, RTX 5060, RX 7600)
    if (c.contains('60 ') || c.endsWith('60') || c.contains('600')) return 150;

    // 5. Budget Tier (e.g., RTX 3050, RX 6500)
    if (c.contains('50 ') || c.endsWith('50') || c.contains('500')) return 100;

    // If it's an older or unlisted card, return a safe middle ground
    return 200;
  }

  // 🛠️ THE ADAPTER (JSON -> Dart Object)
  factory GpuModel.fromJson(Map<String, dynamic> json) {
    final String gpuName = json['name'] ?? 'Unknown GPU';
    final String? rawChipset = json['chipset'];

    return GpuModel(
      id: gpuName,
      brand: gpuName.split(' ').first,
      tgp: _determineWattage(rawChipset), // ✅ Passed into TGP

      name: gpuName,
      chipset: rawChipset ?? 'Unknown Chipset',
      memoryGb: json['memory'] ?? 8,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
