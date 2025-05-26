import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          zoom: 17,
          target: LatLng(22.863353, 89.523078),
        ),
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: (LatLng position) {
          print(position);
        },
        markers: {
          Marker(
            markerId: MarkerId('my-location'),
            position: LatLng(22.863353, 89.523078),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'My Location'),
          ),
          Marker(
            markerId: MarkerId('drag-location'),
            position: LatLng(22.869242863362874, 89.52570464462042),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Drag Location'),
            draggable: true,
            onDrag: (LatLng position) {},
            onDragStart: (LatLng position) {},
            onDragEnd: (LatLng position) {},
          ),
        },
        circles: {
          Circle(
            circleId: CircleId('circle-1'),
            center: LatLng(22.863353, 89.523078),
            radius: 100,
            strokeWidth: 2,
            strokeColor: Colors.deepPurple,
            fillColor: Colors.purpleAccent.withOpacity(0.5),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route-1'),
            points: [
              LatLng(22.863353, 89.523078),
              LatLng(22.869242863362874, 89.52570464462042),
            ],
            color: Colors.blueAccent,
            width: 8,
          ),
        },
        polygons: {
          Polygon(
            polygonId: PolygonId('polygon-1'),
            points: [
              LatLng(22.871814610215292, 89.52147413045168),
              LatLng(22.863523988830927, 89.52080190181732),
              LatLng(22.865316414798176, 89.51908092945814),
              LatLng(22.87091164686718, 89.51857298612595)
            ],
            strokeWidth: 2,
            strokeColor: Colors.cyan,
            fillColor: Colors.cyanAccent.withOpacity(0.5),
          ),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 17,
                target: LatLng(22.863353, 89.523078),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }
}
