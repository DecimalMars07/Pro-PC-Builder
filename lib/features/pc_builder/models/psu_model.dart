class PsuModel {
  // --- 1. DERIVED FIELDS ---
  final String id;
  final String brand;

  // --- 2. API FIELDS ---
  final String name;
  final int wattage;     // ⚡ THE CEILING: How much power this unit can provide!
  final String type;     // e.g., 'ATX', 'SFX'
  final String efficiency; // e.g., 'gold', 'bronze'
  final String modular;  // e.g., 'Full', 'Semi', 'None'
  final String color;
  final double price;

  PsuModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.wattage,
    required this.type,
    required this.efficiency,
    required this.modular,
    required this.color,
    required this.price,
  });

  // 🛠️ THE ADAPTER (JSON -> Dart Object)
  factory PsuModel.fromJson(Map<String, dynamic> json) {
    final String psuName = json['name']?.toString() ?? 'Unknown PSU';

    return PsuModel(
      id: psuName,
      brand: psuName.split(' ').first, // Grabs 'MSI', 'Corsair', 'EVGA', etc.

      name: psuName,
      // If the API forgets to list the wattage, default to a safe 500W
      wattage: json['wattage'] is int
          ? json['wattage']
          : int.tryParse(json['wattage']?.toString() ?? '500') ?? 500,
      type: json['type'] ?? 'ATX',

      // Capitalize the first letter for the UI (e.g., 'gold' -> 'Gold')
      efficiency: (json['efficiency'] ?? 'Standard').toString().replaceFirstMapped(
          RegExp(r'^[a-z]'),
              (match) => match.group(0)!.toUpperCase()
      ),

      modular: json['modular'] is bool
          ? (json['modular'] ? 'Yes' : 'None')
          : (json['modular']?.toString() ?? 'Unknown'),
      color: json['color'] ?? 'Black',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}