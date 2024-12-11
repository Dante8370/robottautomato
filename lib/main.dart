import 'package:flutter/material.dart';

import 'draw_routes_screen.dart';
import 'map_routes_screen.dart';


void main() {
  runApp(const MaterialApp(
    home: RouteSelectionScreen(),
  ));
}

class RouteSelectionScreen extends StatelessWidget {
  const RouteSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecione o Tipo de Rota")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawRouteScreen()),
                );
              },
              child: const Text("Desenhar Rota (Espaços Pequenos)"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapRouteScreen()),
                );
              },
              child: const Text("Definir Rota no Mapa (Espaços Grandes)"),
            ),
          ],
        ),
      ),
    );
  }
}
