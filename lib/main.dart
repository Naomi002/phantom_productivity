import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const PhantomApp());

class PhantomApp extends StatelessWidget {
  const PhantomApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, 
        scaffoldBackgroundColor: const Color(0xFF0B0E14), 
        useMaterial3: true
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
  // Timer State
  int _seconds = 1500; 
  Timer? _timer;
  bool _isActive = false;
  
  // Customization State
  int _avatarIndex = 0;
  final List<IconData> _phantomStyles = [
    Icons.blur_on, 
    Icons.wb_sunny_outlined, 
    Icons.all_inclusive, 
    Icons.auto_awesome_mosaic
  ];

  // History & Social State
  final List<String> _history = [];
  final List<Map<String, String>> _onlineGhosts = [
    {"name": "Phantom_Alpha", "status": "Deep Focus"},
    {"name": "Nawrose_Dev", "status": "Coding..."},
    {"name": "Ghost_99", "status": "Steady"},
  ];

  void _toggleSession() {
    if (_isActive) {
      _timer?.cancel();
      setState(() => _isActive = false);
    } else {
      setState(() => _isActive = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _handleFinish();
        }
      });
    }
  }

  void _handleFinish() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _seconds = 1500;
      _history.insert(0, "Focus Sprint Done @ ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (1500 - _seconds) / 1500;
    String timeStr = "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDEBAR: GHOSTS
          _buildSidebar("LIVE GHOSTS", _onlineGhosts.map((g) => ListTile(
            leading: const Icon(Icons.person_outline, size: 16, color: Colors.white30),
            title: Text(g['name']!, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            subtitle: Text(g['status']!, style: const TextStyle(fontSize: 9, color: Colors.cyanAccent)),
          )).toList()),

          // CENTER: MAIN TIMER
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _avatarIndex = (_avatarIndex + 1) % _phantomStyles.length),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: Icon(_phantomStyles[_avatarIndex], size: 80, color: Colors.cyanAccent),
                  ),
                ),
                const Text("PHANTOMS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.cyanAccent)),
                const SizedBox(height: 60),
                
                // PROGRESS RING AROUND TIMER
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                      ),
                    ),
                    Text(timeStr, style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w100)),
                  ],
                ),
                
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: _toggleSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.withOpacity(0.1), 
                    side: const BorderSide(color: Colors.cyanAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  child: Text(_isActive ? "PAUSE" : "START FOCUSING", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          // RIGHT SIDEBAR: HISTORY
          _buildSidebar("HISTORY", _history.map((h) => ListTile(
            title: Text(h, style: const TextStyle(fontSize: 11, color: Colors.white24)),
          )).toList()),
        ],
      ),
    );
  }

  Widget _buildSidebar(String title, List<Widget> items) {
    return Container(
      width: 250,
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Text(title, style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
          ),
          Expanded(child: ListView(children: items)),
        ],
      ),
    );
  }
}