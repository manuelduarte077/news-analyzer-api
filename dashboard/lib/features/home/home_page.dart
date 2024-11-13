import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../auth/provider/auth_provider.dart';
import '../clinica/clinica_list.dart';
import '../medico/medico_form.dart';
import '../medico/medico_list.dart';
import '../settings/settings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _sections = [
    const MedicoListScreen(),
    MedicoFormScreen(),
    const SettingsScreen(),
    const ClinicaListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.medical_services, size: 30),
            SizedBox(width: 10),
            Text('Dashboard'),
          ],
        ),
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
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(),
          Expanded(child: _sections[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: _buildMenuItems(),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.grey[200],
      child: Column(
        children: _buildMenuItems(),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.list, 'title': 'Lista de Médicos'},
      {'icon': Icons.person_add, 'title': 'Crear Médico'},
      {'icon': Icons.settings, 'title': 'Settings'},
      {'icon': Icons.local_hospital, 'title': 'Lista de Clínicas'},
    ];

    return List.generate(menuItems.length, (index) {
      return ListTile(
        leading: Icon(menuItems[index]['icon'] as IconData),
        title: Text(menuItems[index]['title'] as String),
        selected: _selectedIndex == index,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          context.pop();
        },
      );
    });
  }
}
