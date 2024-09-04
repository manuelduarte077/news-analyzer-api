import 'package:flutter/material.dart';

class DaktarLamara extends StatefulWidget {
  const DaktarLamara({super.key});

  @override
  State<DaktarLamara> createState() => _DaktarLamaraState();
}

class _DaktarLamaraState extends State<DaktarLamara> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daktar Lamara',
      home: Scaffold(
        body: Center(
          child: Container(
            child: const Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
