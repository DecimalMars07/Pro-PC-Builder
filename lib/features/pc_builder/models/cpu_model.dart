   import 'package:pc_part_picker/core/enums/cpu_socket.dart';

class CpuModel {
  // --- Derived Fields ---
  final String id;
  final String brand;
  final CpuSocket socketType; // ✅ enum instead of String

  // --- API Fields ---
  final String name;
  final int coreCount;
  final double coreClock;
  final double? boostClock;
  final String? microarchitecture;
  final int tdp;
  final String? graphics;
  final bool smt;
  final double price;

  CpuModel({
    required this.id,
    required this.brand,
    required this.socketType,
    required this.name,
    required this.coreCount,
    required this.coreClock,
    this.boostClock,
    this.microarchitecture,
    required this.tdp,
    this.graphics,
    required this.smt,
    required this.price,
  });

  // 🔥 Clean Enum Mapper
  static CpuSocket _determineSocket(String? arch) {
    if (arch == null) return CpuSocket.unknown;

    final a = arch.toLowerCase();

    // AMD
    if (a.contains('zen 4') || a.contains('zen 5')) return CpuSocket.am5;
    if (a.contains('zen')) return CpuSocket.am4;

    // Intel
    if (a.contains('alder lake') || a.contains('raptor lake')) {
      return CpuSocket.lga1700;
    }
    if (a.contains('rocket lake') || a.contains('comet lake')) {
      return CpuSocket.lga1200;
    }
    if (a.contains('coffee lake')) return CpuSocket.lga1151;
    if (a.contains('meteor lake') || a.contains('arrow lake')) {
      return CpuSocket.lga1851;
    }

    return CpuSocket.unknown;
  }

  factory CpuModel.fromJson(Map<String, dynamic> json) {
    final String cpuName = json['name'] ?? 'Unknown CPU';
    final String? arch = json['microarchitecture'];

    final lower = cpuName.toLowerCase();

    final String brand =
        (lower.contains('ryzen') || lower.contains('threadripper'))
        ? 'AMD'
        : 'Intel';

    return CpuModel(
      id: cpuName,
      brand: brand,
      socketType: _determineSocket(arch),

      name: cpuName,
      coreCount: json['core_count'] ?? 0,
      coreClock: (json['core_clock'] ?? 0.0).toDouble(),
      boostClock: json['boost_clock'] != null
          ? (json['boost_clock']).toDouble()
          : null,
      microarchitecture: arch,
      tdp: json['tdp'] ?? 0,
      graphics: json['graphics'],
      smt: json['smt'] ?? false,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
