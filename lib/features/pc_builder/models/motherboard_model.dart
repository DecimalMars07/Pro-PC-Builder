import 'package:pc_part_picker/core/enums/cpu_socket.dart';

class MotherboardModel {
  final String id;
  final String name;
  final String brand;

  final CpuSocket socketType; // ✅ enum now
  final String formFactor;
  final double price;
  final String memoryType;

  MotherboardModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.socketType,
    required this.formFactor,
    required this.price,
    required this.memoryType,
  });

  // 🛠️ THE ADAPTER (Bulletproof Edition)
  factory MotherboardModel.fromJson(Map<String, dynamic> json) {
    final String moboName = json['name']?.toString() ?? 'Unknown Motherboard';

    // 🛡️ API Scraper Defense: Check multiple possible keys for the socket!
    final String rawSocket = (json['socket'] ??
        json['cpu_socket'] ??
        json['socket / cpu'])?.toString() ?? '';

    // 🛡️ API Scraper Defense: Check multiple keys for memory type
    final String rawMemory = (json['memory_type'] ??
        json['memory'])?.toString() ?? 'DDR4';

    return MotherboardModel(
      id: moboName,
      brand: moboName.split(' ').first,
      name: moboName,

      // Pass the raw string to your awesome Extension Parser!
      socketType: rawSocket.toCpuSocket(),

      formFactor: json['form_factor']?.toString() ?? 'ATX',
      memoryType: rawMemory,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
