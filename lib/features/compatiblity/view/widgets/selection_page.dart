import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const SelectionPage({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        23,
        29,
        49,
      ), // Use your app's background color!
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ),
      ),
    );
  }
}
