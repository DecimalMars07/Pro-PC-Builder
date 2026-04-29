import 'package:equatable/equatable.dart';
import 'package:pc_part_picker/features/pc_builder/models/cpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/gpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/motherboard_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/psu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/ram_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/storage_model.dart';

abstract class BuilderState extends Equatable {
  @override
  List<Object?> get props => [];
  const BuilderState();
}

class BuilderInitial extends BuilderState {}

class BuilderLoading extends BuilderState {}

class BuilderLoaded extends BuilderState {
  final String? compatibilityError;
  final List<CpuModel> availableCpus;
  final List<GpuModel> availableGpus;
  final List<MotherboardModel> availableMotherboard;
  final List<RamModel> availableRam;
  final List<PsuModel> availablePsu;
  final List<StorageModel> availableSsd;
  final GpuModel? selectedGpu;
  final CpuModel? selectedCpu;
  final MotherboardModel? selectedMotherboard;
  final RamModel? selectedRam;
  final PsuModel? selectedPsu;
  final StorageModel? selectedSsd;
  const BuilderLoaded({
    this.selectedGpu,
    this.selectedCpu,
    required this.availableCpus,
    required this.availableGpus,
    required this.availableMotherboard,

    this.selectedMotherboard,
    this.compatibilityError,
    required this.availableRam,
    this.selectedRam,
    required this.availablePsu,
    this.selectedPsu,
    required this.availableSsd,
    this.selectedSsd,
  });

  BuilderLoaded copyWith({
    List<CpuModel>? availableCpus,
    List<GpuModel>? availableGpus,
    List<MotherboardModel>? availableMotherboard,
    List<RamModel>? availableRam,
    List<StorageModel>? availableSsd,
    GpuModel? selectedGpu,
    CpuModel? selectedCpu,
    MotherboardModel? selectedMotherboard,
    RamModel? selectedRam,
    String? compatibilityError,
    List<PsuModel>? availablePsu,
    PsuModel? selectedPsu,
    StorageModel? selectedSsd,
  }) {
    return BuilderLoaded(
      availableCpus: availableCpus ?? this.availableCpus,
      availableGpus: availableGpus ?? this.availableGpus,
      availableMotherboard: availableMotherboard ?? this.availableMotherboard,
      selectedCpu: selectedCpu ?? this.selectedCpu,
      selectedGpu: selectedGpu ?? this.selectedGpu,
      selectedMotherboard: selectedMotherboard ?? this.selectedMotherboard,
      compatibilityError: compatibilityError,
      availableRam: availableRam ?? this.availableRam,
      selectedRam: selectedRam ?? this.selectedRam,
      availablePsu: availablePsu ?? this.availablePsu,
      selectedPsu: selectedPsu ?? this.selectedPsu,
      availableSsd: availableSsd ?? this.availableSsd,
      selectedSsd: selectedSsd ?? this.selectedSsd,
    );
  }

  @override
  List<Object?> get props => [
    selectedCpu,
    availableCpus,
    selectedGpu,
    availableGpus,
    selectedMotherboard,
    availableMotherboard,
    compatibilityError,
    availableRam,
    selectedRam,
    availablePsu,
    selectedPsu,
    availableSsd,
    selectedSsd,
  ];
}

class BuilderError extends BuilderState {
  final String message;

  const BuilderError(this.message);
  @override
  List<Object?> get props => [message];
}
