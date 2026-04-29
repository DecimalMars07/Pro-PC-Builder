import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_event.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_state.dart';
import 'package:pc_part_picker/features/pc_builder/models/cpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/gpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/motherboard_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/psu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/ram_model.dart';
import 'package:pc_part_picker/features/pc_builder/repositories/builder_repo.dart';

class BuilderBloc extends Bloc<BuilderEvent, BuilderState> {
  final BuilderRepo repo;

  BuilderBloc({required this.repo}) : super(BuilderLoading()) {
    on<LoadAvailableParts>(_onLoadAvailableParts);
    on<SelectCpu>(_onSelectedCpu);
    on<SelectGpu>(_onSelectedGpu);
    on<SelectPsu>(_onSelectPsu);
    on<SelectSsd>(_onSelectSsd);
    on<SelectMotherBoard>(_onSelectedMotherboard);
    on<SelectRam>(_onSelectRam);
    on<RemoveCpu>(_onCpuRemoval);
    on<RemoveGpu>(_onGpuRemoval);
    on<RemoveRam>(_onRamRemoval);
    on<RemovePsu>(_onPsuRemoval);
    on<RemoveSsd>(_onSsdRemoval);
    on<RemoveMotherBoard>(_onMotherboardRemoval);
    on<ClearBuild>(_onClearBuild);
  }
  String? _validateBuild({
    CpuModel? cpu,
    GpuModel? gpu,
    MotherboardModel? motherboard,
    RamModel? ram,
    PsuModel? psu,
  }) {
    // Rule 1: CPU & Motherboard Socket Check
    if (cpu != null &&
        motherboard != null &&
        cpu.socketType != motherboard.socketType) {
      return "Socket Mismatch! ${cpu.name} (${cpu.socketType}) does not fit in the ${motherboard.name} (${motherboard.socketType}).";
    }
    // Rule 2: RAM & Motherboard Check
    if (ram != null &&
        motherboard != null &&
        ram.memoryType != motherboard.memoryType) {
      return "RAM Mismatch! The ${motherboard.name} requires ${motherboard.memoryType} memory, but you selected ${ram.memoryType}.";
    }
    // Rule 3: Power Supply Check
    if (psu != null) {
      int totalWattage = (cpu?.tdp ?? 0) + (gpu?.tgp ?? 0) + (ram?.tdp ?? 0);
      double requiredWattage = totalWattage * 1.2;
      if (psu.wattage < requiredWattage) {
        return "Power Warning! Rig requires ~${requiredWattage.toInt()}W. The ${psu.name} only provides ${psu.wattage}W.";
      }
    }
    return null;
  }

  Future<void> _onLoadAvailableParts(
    LoadAvailableParts event,
    Emitter<BuilderState> emit,
  ) async {
    emit(BuilderLoading());
    try {
      final cpus = await repo.fetchCpus();
      final gpus = await repo.fetchGpus();
      final motherboard = await repo.fetchMotherBoard();
      final ram = await repo.fetchRam();
      final psu = await repo.fetchPsus();
      final ssd = await repo.fetchStorage();
      emit(
        BuilderLoaded(
          availableCpus: cpus,
          availableGpus: gpus,
          availableMotherboard: motherboard,
          availableRam: ram,
          availablePsu: psu,
          availableSsd: ssd,
        ),
      );
    } catch (e) {
      emit(BuilderError('Failed to load parts: ${e.toString()}'));
    }
  }

  void _onSelectedCpu(SelectCpu event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;

      final error = _validateBuild(
        cpu: event.cpuModel,
        gpu: currentState.selectedGpu,
        motherboard: currentState.selectedMotherboard,
        psu: currentState.selectedPsu,
        ram: currentState.selectedRam,
      );

      if (error != null) {
        emit(currentState.copyWith(compatibilityError: error));
      } else {
        emit(currentState.copyWith(selectedCpu: event.cpuModel));
      }
    }
  }

  void _onSelectedGpu(SelectGpu event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      final error = _validateBuild(
        cpu: currentState.selectedCpu,
        gpu: event.gpuModel,
        motherboard: currentState.selectedMotherboard,
        psu: currentState.selectedPsu,
        ram: currentState.selectedRam,
      );

      if (error != null) {
        emit(currentState.copyWith(compatibilityError: error));
      } else {
        emit(currentState.copyWith(selectedGpu: event.gpuModel));
      }
    }
  }

  void _onSelectedMotherboard(SelectMotherBoard event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      final error = _validateBuild(
        cpu: currentState.selectedCpu,
        gpu: currentState.selectedGpu,
        motherboard: event.motherboard,
        psu: currentState.selectedPsu,
        ram: currentState.selectedRam,
      );

      if (error != null) {
        emit(currentState.copyWith(compatibilityError: error));
      } else {
        emit(currentState.copyWith(selectedMotherboard: event.motherboard));
      }
    }
  }

  void _onSelectRam(SelectRam event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      final error = _validateBuild(
        cpu: currentState.selectedCpu,
        gpu: currentState.selectedGpu,
        motherboard: currentState.selectedMotherboard,
        psu: currentState.selectedPsu,
        ram: event.ram,
      );

      if (error != null) {
        emit(currentState.copyWith(compatibilityError: error));
      } else {
        emit(currentState.copyWith(selectedRam: event.ram));
      }
    }
  }

  void _onSelectPsu(SelectPsu event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;

      final error = _validateBuild(
        cpu: currentState.selectedCpu,
        gpu: currentState.selectedGpu,
        motherboard: currentState.selectedMotherboard,
        psu: event.psu,
        ram: currentState.selectedRam,
      );

      if (error != null) {
        emit(currentState.copyWith(compatibilityError: error));
      } else {
        emit(currentState.copyWith(selectedPsu: event.psu));
      }
    }
  }

  void _onSelectSsd(SelectSsd event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;

      final error = _validateBuild(
        cpu: currentState.selectedCpu,
        gpu: currentState.selectedGpu,
        motherboard: currentState.selectedMotherboard,
        psu: currentState.selectedPsu,
        ram: currentState.selectedRam,
      );

      if (error != null) {
        emit(currentState.copyWith(compatibilityError: error));
      } else {
        emit(currentState.copyWith(selectedSsd: event.ssd));
      }
    }
  }

  void _onGpuRemoval(RemoveGpu event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,
          selectedCpu: currentState.selectedCpu,
          selectedGpu: null,
          availableMotherboard: currentState.availableMotherboard,
          selectedMotherboard: currentState.selectedMotherboard,
          availableRam: currentState.availableRam,
          selectedRam: currentState.selectedRam,
          availablePsu: currentState.availablePsu,
          selectedPsu: currentState.selectedPsu,
          availableSsd: currentState.availableSsd,
          selectedSsd: currentState.selectedSsd,
        ),
      );
    }
  }

  void _onCpuRemoval(RemoveCpu event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,
          availableMotherboard: currentState.availableMotherboard,
          selectedCpu: null,
          selectedGpu: currentState.selectedGpu,
          selectedMotherboard: currentState.selectedMotherboard,
          availableRam: currentState.availableRam,
          selectedRam: currentState.selectedRam,
          availablePsu: currentState.availablePsu,
          selectedPsu: currentState.selectedPsu,
          availableSsd: currentState.availableSsd,
          selectedSsd: currentState.selectedSsd,
        ),
      );
    }
  }

  void _onMotherboardRemoval(RemoveMotherBoard event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,
          availableMotherboard: currentState.availableMotherboard,
          selectedCpu: currentState.selectedCpu,
          selectedGpu: currentState.selectedGpu,
          selectedMotherboard: null,
          availableRam: currentState.availableRam,
          selectedRam: currentState.selectedRam,
          availablePsu: currentState.availablePsu,
          selectedPsu: currentState.selectedPsu,
          availableSsd: currentState.availableSsd,
          selectedSsd: currentState.selectedSsd,
        ),
      );
    }
  }

  void _onRamRemoval(RemoveRam event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,
          availableMotherboard: currentState.availableMotherboard,
          selectedCpu: currentState.selectedCpu,
          selectedGpu: currentState.selectedGpu,
          selectedMotherboard: currentState.selectedMotherboard,
          availableRam: currentState.availableRam,
          selectedRam: null,
          availablePsu: currentState.availablePsu,
          selectedPsu: currentState.selectedPsu,
          availableSsd: currentState.availableSsd,
          selectedSsd: currentState.selectedSsd,
        ),
      );
    }
  }

  void _onPsuRemoval(RemovePsu event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,
          availableMotherboard: currentState.availableMotherboard,
          selectedCpu: currentState.selectedCpu,
          selectedGpu: currentState.selectedGpu,
          selectedMotherboard: currentState.selectedMotherboard,
          availableRam: currentState.availableRam,
          selectedRam: currentState.selectedRam,
          availablePsu: currentState.availablePsu,
          selectedPsu: null,
          availableSsd: currentState.availableSsd,
          selectedSsd: currentState.selectedSsd,
        ),
      );
    }
  }

  void _onSsdRemoval(RemoveSsd event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,
          availableMotherboard: currentState.availableMotherboard,
          selectedCpu: currentState.selectedCpu,
          selectedGpu: currentState.selectedGpu,
          selectedMotherboard: currentState.selectedMotherboard,
          availableRam: currentState.availableRam,
          selectedRam: currentState.selectedRam,
          availablePsu: currentState.availablePsu,
          selectedPsu: currentState.selectedPsu,
          availableSsd: currentState.availableSsd,
          selectedSsd: null,
        ),
      );
    }
  }

  void _onClearBuild(ClearBuild event, emit) {
    if (state is BuilderLoaded) {
      final currentState = state as BuilderLoaded;
      emit(
        BuilderLoaded(
          availableCpus: currentState.availableCpus,
          availableGpus: currentState.availableGpus,

          // Hardcode the selections back to null!
          selectedCpu: null,
          selectedGpu: null,
          selectedMotherboard: null,
          selectedRam: null,
          compatibilityError: null,
          availableMotherboard: currentState.availableMotherboard,
          availableRam: currentState.availableRam,
          availablePsu: currentState.availablePsu,
          selectedPsu: null,
          availableSsd: currentState.availableSsd,
          selectedSsd: null,
        ),
      );
    }
  }
}
