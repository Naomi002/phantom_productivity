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

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  int _seconds = 1500; 
  Timer? _timer;
  bool _isActive = false;
  int _avatarIndex = 0;
  final List<String> _history = [];
  
  // Visual Styles for your changing logo
  final List<IconData> _phantomStyles = [
    Icons.blur_on, 
    Icons.wb_sunny_outlined, 
    Icons.all_inclusive, 
    Icons.auto_awesome_mosaic
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
    String timeStr = "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      body: Row(
        children: [
          // LEFT: MAIN DASHBOARD
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CHANGING LOGO: Tap this to cycle styles
                GestureDetector(
                  onTap: () => setState(() => _avatarIndex = (_avatarIndex + 1) % _phantomStyles.length),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isActive ? Colors.cyanAccent.withOpacity(0.05) : Colors.transparent,
                    ),
                    child: Icon(_phantomStyles[_avatarIndex], size: 80, color: Colors.cyanAccent),
                  ),
                ),
                const Text("PHANTOMS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.cyanAccent)),
                const SizedBox(height: 60),
                
                // TIMER TEXT
                Text(timeStr, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.w100, color: Colors.white)),
                
                const SizedBox(height: 60),
                
                // ACTION BUTTON
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
          
          // DIVIDER
          Container(width: 0.5, color: Colors.white10),

          // RIGHT: GHOSTS & HISTORY SIDEBAR
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0F172A),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(20), child: Text("LIVE GHOSTS", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, letterSpacing: 2))),
                  const ListTile(
                    leading: Icon(Icons.person_outline, size: 16, color: Colors.white30),
                    title: Text("Phantom_Alpha", style: TextStyle(fontSize: 12, color: Colors.white70)),
                    subtitle: Text("Deep Focus", style: TextStyle(fontSize: 9, color: Colors.cyanAccent)),
                  ),
                  const Divider(color: Colors.white10),
                  const Padding(padding: EdgeInsets.all(20), child: Text("HISTORY", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2))),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(_history[i], style: const TextStyle(fontSize: 11, color: Colors.white24)),
                      ),
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