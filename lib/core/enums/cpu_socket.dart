enum CpuSocket { am4, am5, lga1151, lga1200, lga1700, lga1851, unknown }

// For UI display
extension CpuSocketExtension on CpuSocket {
  String get label {
    switch (this) {
      case CpuSocket.am4:
        return 'AM4';
      case CpuSocket.am5:
        return 'AM5';
      case CpuSocket.lga1151:
        return 'LGA 1151';
      case CpuSocket.lga1200:
        return 'LGA 1200';
      case CpuSocket.lga1700:
        return 'LGA 1700';
      case CpuSocket.lga1851:
        return 'LGA 1851';
      case CpuSocket.unknown:
        return 'Unknown';
    }
  }
}

// For API parsing
extension CpuSocketParser on String {
  CpuSocket toCpuSocket() {
    final value = toLowerCase();

    if (value.contains('am4')) return CpuSocket.am4;
    if (value.contains('am5')) return CpuSocket.am5;
    if (value.contains('1151')) return CpuSocket.lga1151;
    if (value.contains('1200')) return CpuSocket.lga1200;
    if (value.contains('1700')) return CpuSocket.lga1700;
    if (value.contains('1851')) return CpuSocket.lga1851;

    return CpuSocket.unknown;
  }
}
