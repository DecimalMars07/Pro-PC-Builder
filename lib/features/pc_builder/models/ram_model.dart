class RamModel {
  // --- 1. DERIVED FIELDS ---
  final String id;
  final String brand;
  final String
  memoryType; // e.g., 'DDR4', 'DDR5' (Crucial for Motherboard matching!)
  final int totalGb; // e.g., 32 (Calculated from 2 x 16GB)
  final int tdp; // 🔥 Calculated: ~4W per stick of RAM

  // --- 2. API FIELDS ---
  final String name;
  final int speed; // e.g., 6000
  final int modules; // e.g., 2
  final double price;

  RamModel({
    required this.id,
    required this.brand,
    required this.memoryType,
    required this.totalGb,
    required this.tdp,
    required this.name,
    required this.speed,
    required this.modules,
    required this.price,
  });

  // 🛠️ THE ADAPTER (JSON -> Dart Object)
  factory RamModel.fromJson(Map<String, dynamic> json) {
    final String ramName = json['name'] ?? 'Unknown RAM';

    // 1. Parsing the tricky [DDR Version, Speed] Array
    final List<dynamic>? speedData = json['speed'];
    final int ddrVersion = (speedData != null && speedData.isNotEmpty)
        ? speedData[0] as int
        : 4;
    final int ramSpeed = (speedData != null && speedData.length > 1)
        ? speedData[1] as int
        : 3200;

    // 2. Parsing the tricky [Module Count, GB per Stick] Array
    final List<dynamic>? moduleData = json['modules'];
    final int stickCount = (moduleData != null && moduleData.isNotEmpty)
        ? moduleData[0] as int
        : 2;
    final int gbPerStick = (moduleData != null && moduleData.length > 1)
        ? moduleData[1] as int
        : 8;

    return RamModel(
      id: ramName,
      name: ramName,
      brand: ramName
          .split(' ')
          .first, // Usually Corsair, G.Skill, Kingston, etc.
      // --- Derived Data ---
      memoryType:
          'DDR$ddrVersion', // Creates 'DDR4' or 'DDR5' to match the motherboard!
      totalGb: stickCount * gbPerStick, // e.g., 2 * 16 = 32GB Total
      tdp: stickCount * 4, // 🔌 Assigns 4 Watts per stick
      // --- Direct API Data ---
      speed: ramSpeed,
      modules: stickCount,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
