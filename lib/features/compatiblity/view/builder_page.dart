import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_part_picker/core/enums/cpu_socket.dart';
import 'package:pc_part_picker/features/compatiblity/view/review_build_screen.dart';
import 'package:pc_part_picker/features/compatiblity/view/widgets/selection_page.dart';
import 'package:pc_part_picker/features/compatiblity/view/widgets/post_card.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_bloc.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_event.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_state.dart';

// 🔌 Import your shiny new custom widgets!
import 'widgets/component_slot.dart';

class BuilderPage extends StatelessWidget {
  const BuilderPage({super.key});

  static const Color bgColor = Color(0xFF0F172A);
  static const Color surfaceColor = Color(0xFF1E293B);
  static const Color accentColor = Colors.cyanAccent;
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'PRO PC BUILDER',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
        ),
        actions: [
          BlocBuilder<BuilderBloc, BuilderState>(
            builder: (context, state) {
              if (state is BuilderLoaded &&
                  (state.selectedCpu != null ||
                      state.selectedGpu != null ||
                      state.selectedMotherboard != null)) {
                return IconButton(
                  onPressed: () {
                    context.read<BuilderBloc>().add(ClearBuild());
                  },
                  icon: Icon(
                    Icons.delete_sweep_rounded,
                    color: Colors.redAccent,
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<BuilderBloc, BuilderState>(
        listener: (context, state) {
          if (state is BuilderLoaded && state.compatibilityError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.compatibilityError!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.redAccent.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 10,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BuilderLoading || state is BuilderInitial) {
            return const Center(
              child: CircularProgressIndicator(color: accentColor),
            );
          } else if (state is BuilderError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (state is BuilderLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CURRENT RIG",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✨ Look how clean this is now!
                  const SizedBox(height: 12),

                  // Gpu selection
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: SelectionPage(
                              title: 'Select Graphics Card  ',
                              itemCount: state.availableGpus.length,
                              itemBuilder: (context, index) {
                                final gpu = state.availableGpus[index];

                                return PartCard(
                                  isSelected: gpu.id == state.selectedGpu?.id,
                                  name: gpu.chipset,
                                  specs:
                                      "${gpu.memoryGb}GB VRAM • ${gpu.brand} • ${gpu.tgp}W",
                                  price: gpu.price,
                                  onTap: () async {
                                    // 🚨 UX UPDATE: Add a tiny delay so they can SEE the color change!
                                    context.read<BuilderBloc>().add(
                                      SelectGpu(gpu),
                                    );

                                    // Wait 250 milliseconds so the visual pop registers in their brain 🧠
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    // Now pop the screen!
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: ComponentSlot(
                      title: "Graphics Card (GPU)",
                      icon: Icons.extension,
                      selectedName: state.selectedGpu?.chipset,
                      price: state.selectedGpu?.price,
                      onRemove: () => context.read<BuilderBloc>().add(
                        RemoveGpu(state.selectedGpu!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // CPU selection
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: SelectionPage(
                              title: 'Select CPU  ',
                              itemCount: state.availableCpus.length,
                              itemBuilder: (context, index) {
                                final cpu = state.availableCpus[index];

                                return PartCard(
                                  isSelected: cpu.id == state.selectedCpu?.id,
                                  name: cpu.name,
                                  specs: "${cpu.coreCount} Cores • ${cpu.coreClock}GHz • ${cpu.socketType.label} • ${cpu.tdp}W",
                                  price: cpu.price,
                                  onTap: () async {
                                    // 🚨 UX UPDATE: Add a tiny delay so they can SEE the color change!
                                    context.read<BuilderBloc>().add(
                                      SelectCpu(cpu),
                                    );

                                    // Wait 250 milliseconds so the visual pop registers in their brain 🧠
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    // Now pop the screen!
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: ComponentSlot(
                      title: "Processor (CPU)",
                      icon: Icons.memory,
                      selectedName: state.selectedCpu?.name,
                      price: state.selectedCpu?.price,
                      onRemove: () => context.read<BuilderBloc>().add(
                        RemoveCpu(state.selectedCpu!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Motherboard
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: SelectionPage(
                              title: 'Select Motherboard  ',
                              itemCount: state.availableMotherboard.length,
                              itemBuilder: (context, index) {
                                final motherboard =
                                    state.availableMotherboard[index];

                                return PartCard(
                                  isSelected:
                                      motherboard.id ==
                                      state.selectedMotherboard?.id,
                                  name: motherboard.name,
                                  specs: "${motherboard.socketType.label} • ${motherboard.formFactor} • ${motherboard.memoryType}",
                                  price: motherboard.price,
                                  onTap: () async {
                                    // 🚨 UX UPDATE: Add a tiny delay so they can SEE the color change!
                                    context.read<BuilderBloc>().add(
                                      SelectMotherBoard(motherboard),
                                    );

                                    // Wait 250 milliseconds so the visual pop registers in their brain 🧠
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    // Now pop the screen!
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: ComponentSlot(
                      title: 'Motherboard',
                      icon: Icons.developer_board,
                      selectedName: state.selectedMotherboard?.name,
                      price: state.selectedMotherboard?.price,
                      onRemove: () => context.read<BuilderBloc>().add(
                        RemoveMotherBoard(state.selectedMotherboard!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  //RAM
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: SelectionPage(
                              title: 'Select RAM',
                              itemCount: state.availableMotherboard.length,
                              itemBuilder: (context, index) {
                                final ram = state.availableRam[index];

                                return PartCard(
                                  isSelected: ram.id == state.selectedRam?.id,
                                  name: ram.name,
                                  specs:
                                      "${ram.totalGb} • ${ram.memoryType} • ${ram.brand}",
                                  price: ram.price,
                                  onTap: () async {
                                    // 🚨 UX UPDATE: Add a tiny delay so they can SEE the color change!
                                    context.read<BuilderBloc>().add(
                                      SelectRam(ram),
                                    );

                                    // Wait 250 milliseconds so the visual pop registers in their brain 🧠
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    // Now pop the screen!
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: ComponentSlot(
                      title: 'RAM',
                      icon: Icons.dns,
                      selectedName: state.selectedRam?.name,
                      price: state.selectedRam?.price,
                      onRemove: () => context.read<BuilderBloc>().add(
                        RemoveRam(state.selectedRam!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // PSU
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: SelectionPage(
                              title: 'Select PSU',
                              itemCount: state.availablePsu.length,
                              itemBuilder: (context, index) {
                                final psu = state.availablePsu[index];

                                return PartCard(
                                  isSelected: psu.id == state.selectedPsu?.id,
                                  name: psu.name,
                                  specs:
                                      "${psu.efficiency} • ${psu.wattage} W • ${psu.modular}",
                                  price: psu.price,
                                  onTap: () async {
                                    // 🚨 UX UPDATE: Add a tiny delay so they can SEE the color change!
                                    context.read<BuilderBloc>().add(
                                      SelectPsu(psu),
                                    );

                                    // Wait 250 milliseconds so the visual pop registers in their brain 🧠
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    // Now pop the screen!
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: ComponentSlot(
                      title: "PSU",
                      icon: Icons.bolt,
                      selectedName: state.selectedPsu?.name,
                      price: state.selectedPsu?.price,
                      onRemove: () => context.read<BuilderBloc>().add(
                        RemovePsu(state.selectedPsu!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SSD
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: SelectionPage(
                              title: 'Select SSD',
                              itemCount: state.availablePsu.length,
                              itemBuilder: (context, index) {
                                final ssd = state.availableSsd[index];

                                return PartCard(
                                  isSelected: ssd.id == state.selectedSsd?.id,
                                  name: ssd.name,
                                  specs:
                                      "${ssd.displayCapacity} • ${ssd.brand} • ${ssd.type}",
                                  price: ssd.price,
                                  onTap: () async {
                                    // 🚨 UX UPDATE: Add a tiny delay so they can SEE the color change!
                                    context.read<BuilderBloc>().add(
                                      SelectSsd(ssd),
                                    );

                                    // Wait 250 milliseconds so the visual pop registers in their brain 🧠
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    // Now pop the screen!
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: ComponentSlot(
                      title: 'SSD',
                      icon: Icons.save,
                      selectedName: state.selectedSsd?.name,
                      price: state.selectedMotherboard?.price,
                      onRemove: () => context.read<BuilderBloc>().add(
                        RemoveSsd(state.selectedSsd!),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      // (Keep your awesome bottomNavigationBar code here)
      bottomNavigationBar: BlocBuilder<BuilderBloc, BuilderState>(
        builder: (context, state) {
          // 1. Set default empty values
          double totalPrice = 0;
          int totalWattage = 0;
          bool hasParts = false;

          // 2. If loaded, calculate the real values
          if (state is BuilderLoaded) {
            totalPrice =
                (state.selectedCpu?.price ?? 0) +
                (state.selectedGpu?.price ?? 0) +
                (state.selectedMotherboard?.price ?? 0) +
                (state.selectedPsu?.price ?? 0) +
                (state.selectedRam?.price ?? 0) +
                (state.selectedSsd?.price ?? 0);
            totalWattage =
                (state.selectedCpu?.tdp ?? 0) + (state.selectedGpu?.tgp ?? 0) + (state.selectedRam?.tdp ??0) ;
            hasParts = state.selectedCpu != null || state.selectedGpu != null;
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side: Stats (Always visible now!)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Est. Wattage: ${totalWattage}W",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          // Grey out the price if it's zero
                          color: hasParts
                              ? bgColor
                              : const Color.fromARGB(255, 80, 111, 153),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Right Side: Smart Action Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // 1. The colors when the button is ACTIVE (hasParts == true)
                      backgroundColor: const Color.fromARGB(255, 61, 223, 223),
                      foregroundColor: bgColor,

                      // 2. 🚨 THE FIX: The colors when the button is DISABLED (onPressed == null)
                      disabledBackgroundColor: Colors.grey.shade400,
                      disabledForegroundColor: Colors.grey.shade800,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: hasParts ? 5 : 0,
                    ),
                    // 3. This 'null' triggers the disabled colors above!
                    onPressed: hasParts ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // We wrap it in BlocProvider.value to pass the existing state to the new page!
                          builder: (_) => BlocProvider.value(
                            value: context.read<BuilderBloc>(),
                            child: const ReviewBuildScreen()
                          ),
                        ),
                      );
                    } : null,
                    child: const Text(
                      "REVIEW BUILD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
