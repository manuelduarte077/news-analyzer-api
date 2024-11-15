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
    const MedicoFormScreen(),
    const ClinicaListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      drawer: isMobile ? _buildDrawer(authProvider) : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(authProvider),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _sections,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AuthProvider authProvider) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(),
          // Menú principal
          Expanded(child: ListView(children: _buildMenuItems())),
          // Botón de cerrar sesión
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              authProvider.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(AuthProvider authProvider) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Sidebar Header
          _buildDrawerHeader(),
          // Menú principal
          Expanded(child: ListView(children: _buildMenuItems())),
          // Botón de cerrar sesión
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              authProvider.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Color(0xff88B7A4),
      ),
      accountName: Text(
        'Administrador',
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        'admin@example.com',
        style: TextStyle(color: Colors.white70),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          'D',
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.list_alt_outlined, 'title': 'Lista de Médicos'},
      {'icon': Icons.person_2_outlined, 'title': 'Crear Médico'},
      {'icon': Icons.local_hospital_outlined, 'title': 'Lista de Clínicas'},
      {'icon': Icons.settings_outlined, 'title': 'Settings'},
    ];

    return List.generate(menuItems.length, (index) {
      return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Icon(
          menuItems[index]['icon'] as IconData,
          size: 35,
        ),
        title: Text(menuItems[index]['title'] as String),
        selected: _selectedIndex == index,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          if (context.canPop()) {
            context.pop();
          }
        },
      );
    });
  }
}
