import 'package:flutter/material.dart';

class PillEstado extends StatelessWidget {
  const PillEstado({
    super.key,
    required this.label,
    required this.color,
    required this.fondo,
  });

  final String label;
  final Color color;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
          color: color,
        ),
      ),
    );
  }
}
