import 'dart:async'; // Required for real-time timer logic
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
        // The "Millionaire" Aesthetic: Deep Space Black
        scaffoldBackgroundColor: const Color(0xFF0B0E14), 
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Timer State Variables
  int _seconds = 1500; // 25 minutes default
  Timer? _timer;
  bool _isActive = false;

  // The "Real-Time Engine" Logic
  void _toggleTimer() {
    if (_isActive) {
      _timer?.cancel();
      setState(() => _isActive = false);
    } else {
      setState(() => _isActive = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _timer?.cancel();
            _isActive = false;
          }
        });
      });
    }
  }

  // Formatting the time display (00:00)
  String get _formattedTime {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel(); // Prevents the app from crashing in the background
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing Logo
            const Icon(Icons.blur_on, size: 80, color: Colors.cyanAccent),
            const SizedBox(height: 20),
            const Text(
              "PHANTOMS",
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 8,
                color: Colors.cyanAccent,
              ),
            ),
            const Text(
              "Presence Without Pressure",
              style: TextStyle(color: Colors.white38, letterSpacing: 2),
            ),
            const SizedBox(height: 60),
            
            // The Big Real-Time Timer
            Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 100, 
                fontWeight: FontWeight.w100, 
                color: Colors.white
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Interactive Focus Button
            ElevatedButton(
              onPressed: _toggleTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                side: const BorderSide(color: Colors.cyanAccent, width: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                _isActive ? "PAUSE SESSION" : "START FOCUSING",
                style: const TextStyle(
                  color: Colors.cyanAccent, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}