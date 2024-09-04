import 'package:app/routing/app_router.dart';
import 'package:flutter/material.dart';

class DaktarLamara extends StatefulWidget {
  const DaktarLamara({super.key});

  @override
  State<DaktarLamara> createState() => _DaktarLamaraState();
}

class _DaktarLamaraState extends State<DaktarLamara> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}
