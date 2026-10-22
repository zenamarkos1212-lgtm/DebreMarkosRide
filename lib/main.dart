import 'package:flutter/material.dart';

void main() {
  runApp(const DebreMarkosRideApp());
}

const Color rideGreen = Color(0xFF00A86B);

class DebreMarkosRideApp extends StatelessWidget {
  const DebreMarkosRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Debre Markos Ride',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: rideGreen,
          primary: rideGreen,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
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

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
            onPressed: () => showMessage('Phone login will be added next.'),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Account',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: rideGreen,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.local_taxi, color: Colors.white, size: 48),
                  SizedBox(height: 14),
                  Text(
                    'Your ride, your way!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fast • Safe • Reliable',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Travel around Debre Markos with ease.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Where would you like to go?',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup location',
                hintText: 'Enter your starting point',
                prefixIcon: const Icon(
                  Icons.my_location,
                  color: rideGreen,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'Where are you going?',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (pickupController.text.trim().isEmpty ||
                      destinationController.text.trim().isEmpty) {
                    showMessage('Please enter pickup and destination.');
                    return;
                  }

                  showMessage(
                    'Ride request screen will be connected next.',
                  );
                },
                icon: const Icon(Icons.local_taxi),
                label: const Text(
                  'Find a Ride',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rideGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.location_city, color: rideGreen, size: 34),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Serving Debre Markos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Convenient local rides, all in one app.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'DEBRE MARKOS RIDE • VERSION 1.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
