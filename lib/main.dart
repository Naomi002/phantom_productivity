import 'dart:async';
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
  int _seconds = 1500; 
  Timer? _timer;
  bool _isActive = false;

  // Mock Data for "Ghosts" online
  final List<Map<String, String>> _onlineGhosts = [
    {"name": "Phantom_Alpha", "status": "Deep Focus", "time": "12:04"},
    {"name": "Ghost_User_99", "status": "Steady", "time": "05:22"},
    {"name": "Nawrose_Dev", "status": "Focusing", "time": "19:45"},
  ];

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
            _showRewardDialog();
          }
        });
      });
    }
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Session Complete! 👻", style: TextStyle(color: Colors.cyanAccent)),
          content: const Text("Your Phantom has gained +10 Focus Energy. Great work, Nabila."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _seconds = 1500);
              },
              child: const Text("COLLECT ENERGY", style: TextStyle(color: Colors.cyanAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Row allows us to put the Timer and the Ghost List side-by-side
      body: Row(
        children: [
          // LEFT SIDE: The Main Timer Area
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.blur_on, size: 80, color: Colors.cyanAccent),
                const SizedBox(height: 10),
                const Text("PHANTOMS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.cyanAccent)),
                const SizedBox(height: 50),
                Text(
                  "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w100, color: Colors.white),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                    side: const BorderSide(color: Colors.cyanAccent, width: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(_isActive ? "PAUSE" : "START FOCUSING"),
                ),
              ],
            ),
          ),
          
          // RIGHT SIDE: The Ghost Sidebar (Vertical Divider)
          Container(width: 0.5, color: Colors.white10),
          
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0F172A),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("LIVE GHOSTS", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _onlineGhosts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person_outline, color: Colors.white30),
                          title: Text(_onlineGhosts[index]['name']!, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                          subtitle: Text(_onlineGhosts[index]['status']!, style: const TextStyle(fontSize: 10, color: Colors.cyanAccent)),
                          trailing: const Icon(Icons.bolt, size: 16, color: Colors.amberAccent),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}