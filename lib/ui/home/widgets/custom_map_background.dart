import 'package:flutter/material.dart';

class CustomMapBackground extends StatelessWidget {
  const CustomMapBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Stack(
        children: [
          // Abstract Map Patterns
          Positioned(top: 100, left: 50, child: _buildMapRoad(0)),
          Positioned(top: 300, right: 80, child: _buildMapRoad(45)),
          const Center(
              child: Icon(Icons.location_on, color: Colors.blue, size: 40)),
        ],
      ),
    );
  }

  Widget _buildMapRoad(double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 300,
        height: 15,
        color: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}
