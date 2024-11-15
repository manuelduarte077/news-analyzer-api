import 'package:flutter/material.dart';

class CardClinica extends StatelessWidget {
  const CardClinica({
    super.key,
    required this.clinica,
    required this.onTap,
    required this.ubicacion,
    required this.selected,
    this.trailing,
  });

  final String clinica;
  final String ubicacion;
  final void Function()? onTap;
  final bool selected;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(
        clinica,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: selected ? const Icon(Icons.local_hospital_outlined) : trailing,
      subtitle: Text(
        ubicacion,
        style: TextStyle(
          color: selected ? Theme.of(context).primaryColor : null,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
