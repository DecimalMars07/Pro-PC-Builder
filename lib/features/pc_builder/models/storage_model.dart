class StorageModel {
  // --- 1. DERIVED FIELDS ---
  final String id;
  final String brand;
  final int tdp;       // 🔥 Calculated based on SSD vs HDD

  // --- 2. API FIELDS ---
  final String name;
  final int capacityGb; // e.g., 2000
  final String type;    // e.g., 'SSD' or 'HDD'
  final String formFactor; // e.g., 'M.2-2280'
  final String interface;  // e.g., 'M.2 PCIe 4.0 X4'
  final double price;

  StorageModel({
    required this.id,
    required this.brand,
    required this.tdp,
    required this.name,
    required this.capacityGb,
    required this.type,
    required this.formFactor,
    required this.interface,
    required this.price,
  });

  // 🧠 The Smart Storage Wattage Estimator
  static int _determineWattage(String? type, String? formFactor) {
    if (type == 'HDD') return 15; // Spinning metal platters need more juice
    if (formFactor != null && formFactor.contains('M.2')) return 10; // High-speed NVMe
    return 5; // Standard 2.5" SATA SSDs
  }

  // 🛠️ THE ADAPTER
  // 🛠️ THE ADAPTER (Bulletproof Edition)
  factory StorageModel.fromJson(Map<String, dynamic> json) {
    // 🛡️ Force all text fields into Strings safely
    final String storageName = json['name']?.toString() ?? 'Unknown Storage';
    final String storageType = json['type']?.toString() ?? 'SSD';
    final String form = json['form_factor']?.toString() ?? 'Unknown';

    return StorageModel(
      id: storageName,
      brand: storageName.split(' ').first,
      tdp: _determineWattage(storageType, form),

      name: storageName,

      // 🛡️ Safe Capacity Parsing
      capacityGb: json['capacity'] is int
          ? json['capacity']
          : int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,

      type: storageType,
      formFactor: form,
      interface: json['interface']?.toString() ?? 'Unknown Interface',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  // 🌟 BONUS UI HELPER: Convert 2000GB into '2 TB' for cleaner UI display!
  String get displayCapacity {
    if (capacityGb >= 1000) {
      // 2000 / 1000 = 2.0. The toStringAsFixed(0) chops off the decimal!
      return '${(capacityGb / 1000).toStringAsFixed(0)} TB';
    }
    return '$capacityGb GB';
  }
}