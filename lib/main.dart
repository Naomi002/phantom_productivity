import 'package:flutter/material.dart';

void main() {
  runApp(const PhantomApp());
}

class PhantomApp extends StatelessWidget {
  const PhantomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phantoms',
      theme: ThemeData(
        brightness: Brightness.dark,
        // The Millionaire Aesthetic: A very deep, premium midnight black
        scaffoldBackgroundColor: const Color(0xFF0B0E14), 
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Our temporary logo
            Icon(Icons.blur_on, size: 80, color: Colors.cyanAccent),
            SizedBox(height: 20),
            Text(
              "PHANTOMS",
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 8,
                color: Colors.cyanAccent,
              ),
            ),
            Text(
              "Presence Without Pressure",
              style: TextStyle(color: Colors.white38, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}