import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pc_part_picker/features/compatiblity/view/builder_page.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_bloc.dart';
import 'package:pc_part_picker/features/pc_builder/bloc/builder_event.dart';
import 'package:pc_part_picker/features/pc_builder/repositories/builder_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) =>
            BuilderBloc(repo: BuilderRepo())..add(LoadAvailableParts()),
        child: BuilderPage(),
      ),
    );
  }
}
