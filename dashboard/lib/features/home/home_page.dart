import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Bienvenido, administrador!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
