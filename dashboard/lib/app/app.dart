import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daktar Lamara',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daktar Lamara'),
        ),
        body: const Center(
          child: Text('Welcome to Daktar Lamara'),
        ),
      ),
    );
  }
}
