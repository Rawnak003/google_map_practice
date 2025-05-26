import 'package:flutter/material.dart';
import 'package:google_map/locator_service.dart';

class GpsServiceScreen extends StatefulWidget {
  const GpsServiceScreen({super.key});

  @override
  State<GpsServiceScreen> createState() => _GpsServiceScreenState();
}

class _GpsServiceScreenState extends State<GpsServiceScreen> {
  final LocatorService locatorService = LocatorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPS Service',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Location:\n'
                  '${locatorService.currentLocation?.latitude ?? "null"}, '
                  '${locatorService.currentLocation?.longitude ?? "null"}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                locatorService.getCurrentLocation(() {
                  setState(() {});
                });
              },
              child: Text('Get Current Location'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                locatorService.listenCurrentLocation(() {
                  setState(() {});
                });
              },
              child: Text('Listen Current Location'),
            ),
          ],
        ),
      ),
    );
  }
}

