import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapRouteScreen extends StatefulWidget {
  const MapRouteScreen({super.key});

  @override
  MapRouteScreenState createState() => MapRouteScreenState();
}

class MapRouteScreenState extends State<MapRouteScreen> {
  
  LatLng? startPoint;
  LatLng? endPoint;
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Definir Rota no Mapa")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-15.793889, -47.882778), // Brasília
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
         
        },
        onTap: (position) {
          setState(() {
            if (startPoint == null) {
              startPoint = position;
            } else if (endPoint == null) {
              endPoint = position;
              calculateAndDisplayRoute();
            }
          });
        },
        markers: {
          if (startPoint != null)
            Marker(markerId: const MarkerId("start"), position: startPoint!),
          if (endPoint != null)
            Marker(markerId: const MarkerId("end"), position: endPoint!),
        },
        polylines: polylines,
      ),
    );
  }

  void calculateAndDisplayRoute() async {
    if (startPoint == null || endPoint == null) return;

    const String apiKey = "SUA_API_KEY";
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint!.latitude},${startPoint!.longitude}&destination=${endPoint!.latitude},${endPoint!.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final polyline = decodePolyline(points);

        setState(() {
          polylines.add(Polyline(
            polylineId: const PolylineId("route"),
            points: polyline,
            color: Colors.blue,
            width: 5,
          ));
        });
      }
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }
}
