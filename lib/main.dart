import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const DebreMarkosRideApp());
}

const Color rideGreen = Color(0xFF00A86B);

class DebreMarkosRideApp extends StatelessWidget {
  const DebreMarkosRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debre Markos Ride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: rideGreen),
        useMaterial3: true,
      ),
      home: const RideHomePage(),
    );
  }
}

class RideHomePage extends StatefulWidget {
  const RideHomePage({super.key});

  @override
  State<RideHomePage> createState() => _RideHomePageState();
}

class _RideHomePageState extends State<RideHomePage> {
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final mapController = MapController();

  // Debre Markos approximate coordinates
  LatLng currentLocation = const LatLng(10.3404, 37.7186);
  bool loadingLocation = false;
  bool hasGpsLocation = false;

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    mapController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> findMyLocation() async {
    setState(() => loadingLocation = true);

    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        showMessage('Please turn on your phone location/GPS.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showMessage('Location permission is needed to show your position.');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final point = LatLng(position.latitude, position.longitude);

      setState(() {
        currentLocation = point;
        hasGpsLocation = true;
      });

      mapController.move(point, 15);
      pickupController.text = 'My current location';
      showMessage('Your current location has been found.');
    } catch (e) {
      showMessage('Could not get GPS location. Please try again.');
    } finally {
      if (mounted) setState(() => loadingLocation = false);
    }
  }

  void requestRide() {
    if (pickupController.text.trim().isEmpty ||
        destinationController.text.trim().isEmpty) {
      showMessage('Please enter pickup and destination.');
      return;
    }

    showMessage(
      'Pickup: ${pickupController.text.trim()} | '
      'Destination: ${destinationController.text.trim()}. '
      'Driver matching will be added next.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: rideGreen,
        foregroundColor: Colors.white,
        title: const Text(
          'Debre Markos Ride',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: findMyLocation,
            tooltip: 'Find my location',
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: rideGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.local_taxi, color: Colors.white, size: 42),
                  SizedBox(height: 10),
                  Text(
                    'Your ride, your way!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Fast • Safe • Reliable',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Travel around Debre Markos with ease.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Choose your location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 300,
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: currentLocation,
                    initialZoom: 13,
                    onTap: (tapPosition, point) {
                      setState(() => currentLocation = point);
                      pickupController.text =
                          '${point.latitude.toStringAsFixed(5)}, '
                          '${point.longitude.toStringAsFixed(5)}';
                      showMessage('Pickup point selected on the map.');
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.debremarkos.ride.debremarkosride',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentLocation,
                          width: 48,
                          height: 48,
                          child: Icon(
                            hasGpsLocation
                                ? Icons.my_location
                                : Icons.location_pin,
                            color: rideGreen,
                            size: 42,
                          ),
                        ),
                      ],
                    ),
                    const RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution('OpenStreetMap contributors'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: loadingLocation ? null : findMyLocation,
              icon: loadingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.gps_fixed),
              label: Text(
                loadingLocation ? 'Finding location...' : 'Use my current location',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup location',
                hintText: 'Tap the map or use GPS',
                prefixIcon: const Icon(Icons.my_location, color: rideGreen),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'Enter destination name',
                prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: requestRide,
                icon: const Icon(Icons.local_taxi),
                label: const Text(
                  'Find a Ride',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rideGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Map data © OpenStreetMap contributors',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
