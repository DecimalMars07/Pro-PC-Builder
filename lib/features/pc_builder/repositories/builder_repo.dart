import 'dart:convert';

import 'package:pc_part_picker/features/pc_builder/models/cpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/gpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/motherboard_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/psu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/ram_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/storage_model.dart';
import 'package:http/http.dart' as http;

class BuilderRepo {
  Future<List<CpuModel>> fetchCpus() async {
    try {
      final url = Uri.parse(
        'https://raw.githubusercontent.com/docyx/pc-part-dataset/refs/heads/main/data/json/cpu.json',
      );
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception("Request timed out"),
          );

      if (response.statusCode == 200) {
        // decode the massive json file
        final List<dynamic> jsonData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        // convert it to Dart models {taking first 50 so it doesn't lag}
        return jsonData
            .take(50)
            .map((jsonItem) => CpuModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception('Failed to load CPUs. Status: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<GpuModel>> fetchGpus() async {
    // simulate network delay by 2 seconds
    try {
      final url = Uri.parse(
        'https://raw.githubusercontent.com/docyx/pc-part-dataset/refs/heads/main/data/json/video-card.json',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        // decoding the json

        final List<dynamic> jsonData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return jsonData
            .take(50)
            .map((jsonItem) => GpuModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception('Failed to load GPUs. Status: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<MotherboardModel>> fetchMotherBoard() async {
    try {
      final url = Uri.parse(
        'https://raw.githubusercontent.com/docyx/pc-part-dataset/refs/heads/main/data/json/motherboard.json',
      );
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception("Request timed out"),
          );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return jsonData
            .take(50)
            .map((jsonItem) => MotherboardModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception(
          'Failed to load Motheboard. Status: ${response.statusCode}',
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ⏱️ Faking the internet for RAM
  Future<List<RamModel>> fetchRam() async {
    try {
      final url = Uri.parse(
        'https://raw.githubusercontent.com/docyx/pc-part-dataset/refs/heads/main/data/json/memory.json',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        return jsonData
            .take(50)
            .map((jsonItem) => RamModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception('Failed to load RAM. Status: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ⏱️ Faking the internet for Power Supplies (PSU)
  Future<List<PsuModel>> fetchPsus() async {
   try{
     final url = Uri.parse('https://raw.githubusercontent.com/docyx/pc-part-dataset/refs/heads/main/data/json/power-supply.json');
     final response = await http.get(url).timeout(Duration(seconds: 8));

     if(response.statusCode == 200){
       final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

       return jsonData.map((jsonItem)=> PsuModel.fromJson(jsonItem)).toList();
     }else{
       throw Exception('Failed to load PSU. Status: ${response.statusCode}');
     }
   }on Exception {
     rethrow;
   } catch (e) {
     throw Exception('Network error: $e');
   }
  }

  Future<List<StorageModel>> fetchStorage() async {
    try{
      final url = Uri.parse('https://raw.githubusercontent.com/docyx/pc-part-dataset/refs/heads/main/data/json/internal-hard-drive.json');
      final response = await http.get(url).timeout(Duration(seconds: 8));

      if(response.statusCode == 200){
        final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        return jsonData.map((jsonItem)=> StorageModel.fromJson(jsonItem)).toList();
      }else{
        throw Exception('Failed to load SSD. Status: ${response.statusCode}');
      }
    }on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
