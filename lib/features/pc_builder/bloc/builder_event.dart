import 'package:equatable/equatable.dart';
import 'package:pc_part_picker/features/pc_builder/models/cpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/gpu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/motherboard_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/psu_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/ram_model.dart';
import 'package:pc_part_picker/features/pc_builder/models/storage_model.dart';

abstract class BuilderEvent extends Equatable {
  @override
  List<Object?> get props => [];
  const BuilderEvent();
}

class LoadAvailableParts extends BuilderEvent {}

class SelectCpu extends BuilderEvent {
  final CpuModel cpuModel;

  const SelectCpu(this.cpuModel);
  @override
  List<Object?> get props => [cpuModel];
}

class SelectGpu extends BuilderEvent {
  final GpuModel gpuModel;
  const SelectGpu(this.gpuModel);
  @override
  List<Object?> get props => [gpuModel];
}

class RemoveCpu extends BuilderEvent {
  final CpuModel cpuModel;

  const RemoveCpu(this.cpuModel);
  @override
  List<Object?> get props => [cpuModel];
}

class RemoveGpu extends BuilderEvent {
  final GpuModel gpuModel;
  const RemoveGpu(this.gpuModel);
  @override
  List<Object?> get props => [gpuModel];
}

class SelectMotherBoard extends BuilderEvent {
  final MotherboardModel motherboard;
  const SelectMotherBoard(this.motherboard);
  @override
  List<Object?> get props => [motherboard];
}

class RemoveMotherBoard extends BuilderEvent {
  final MotherboardModel motherboard;
  const RemoveMotherBoard(this.motherboard);
  @override
  List<Object?> get props => [motherboard];
}

class ClearBuild extends BuilderEvent {}

class SelectRam extends BuilderEvent {
  final RamModel ram;
  const SelectRam(this.ram);
  @override
  List<Object?> get props => [ram];
}

class RemoveRam extends BuilderEvent {
  final RamModel ram;
  const RemoveRam(this.ram);
  @override
  List<Object?> get props => [ram];
}

class SelectPsu extends BuilderEvent {
  final PsuModel psu;
  const SelectPsu(this.psu);
  @override
  List<Object?> get props => [psu];
}

class RemovePsu extends BuilderEvent {
  final PsuModel psu;
  const RemovePsu(this.psu);
  @override
  List<Object?> get props => [psu];
}

class SelectSsd extends BuilderEvent {
  final StorageModel ssd;
  const SelectSsd(this.ssd);
  @override
  List<Object?> get props => [ssd];
}

class RemoveSsd extends BuilderEvent {
  final StorageModel ssd;
  const RemoveSsd(this.ssd);
  @override
  List<Object?> get props => [ssd];
}
