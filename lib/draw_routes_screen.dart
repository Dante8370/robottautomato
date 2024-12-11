import 'package:flutter/material.dart';

class DrawRouteScreen extends StatefulWidget {
  const DrawRouteScreen({super.key});

  @override
  DrawRouteScreenState createState() => DrawRouteScreenState();
}

class DrawRouteScreenState extends State<DrawRouteScreen> {
  List<Offset?> points = [];
  double scale = 1.0; // 1 pixel = 1 cm, por exemplo.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Desenhar Rota")),
      body: Stack(
        children: [                  
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanEnd: (_) {
              points.add(null); // Fim do traço
            },
            child: CustomPaint(
              painter: RoutePainter(points),
              size: Size.infinite,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () {
                saveRoute(points, scale);
              },
            ),
          )
        ],
      ),
    );
  }

  void saveRoute(List<Offset?> points, double scale) {
    // Converta pontos para distância e ângulos
    // Envie para o Firebase
  }
}

class RoutePainter extends CustomPainter {
  final List<Offset?> points;

  RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
