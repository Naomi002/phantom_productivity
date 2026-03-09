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
  int _avatarIndex = 0;
  
  // Data for Session History
  final List<String> _focusHistory = [];

  final List<IconData> _phantomStyles = [
    Icons.blur_on,
    Icons.wb_sunny_outlined,
    Icons.all_inclusive,
    Icons.auto_awesome,
  ];

  final List<Map<String, String>> _onlineGhosts = [
    {"name": "Phantom_Alpha", "status": "Deep Focus"},
    {"name": "Ghost_User_99", "status": "Steady"},
    {"name": "Nawrose_Dev", "status": "Coding..."},
    {"name": "Shadow_Student", "status": "Reading"},
  ];

  void _cycleAvatar() {
    setState(() => _avatarIndex = (_avatarIndex + 1) % _phantomStyles.length);
  }

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
            _addHistory(); // Record the win!
            _showRewardDialog();
          }
        });
      });
    }
  }

  void _addHistory() {
    final now = DateTime.now();
    final timestamp = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    _focusHistory.insert(0, "Completed 25m Session at $timestamp");
  }

  void _sendPulse(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text("Motivation Pulse sent to $name! ⚡", 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Session Complete! 👻", style: TextStyle(color: Colors.cyanAccent)),
        content: const Text("Energy Collected. Your Focus History has been updated, Nabila."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _seconds = 1500);
            },
            child: const Text("CONTINUE", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
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
      body: Row(
        children: [
          // MAIN PANEL
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: _cycleAvatar,
                  child: Icon(_phantomStyles[_avatarIndex], size: 100, color: Colors.cyanAccent),
                ),
                const SizedBox(height: 10),
                const Text("PHANTOMS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.cyanAccent)),
                const SizedBox(height: 40),
                Text(
                  "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w100, color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                    side: const BorderSide(color: Colors.cyanAccent, width: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(_isActive ? "PAUSE" : "START FOCUSING", style: const TextStyle(color: Colors.cyanAccent)),
                ),
                const Spacer(),
                
                // NEW: FOCUS HISTORY LIST
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("FOCUS HISTORY", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
                      const Divider(color: Colors.white10),
                      Expanded(
                        child: _focusHistory.isEmpty 
                          ? const Center(child: Text("No sessions yet today.", style: TextStyle(color: Colors.white10, fontSize: 12)))
                          : ListView.builder(
                              itemCount: _focusHistory.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text("• ${_focusHistory[index]}", style: const TextStyle(color: Colors.white60, fontSize: 12)),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Container(width: 0.5, color: Colors.white10),
          
          // GHOST SIDEBAR
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0F172A),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text("LIVE GHOSTS", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _onlineGhosts.length,
                      itemBuilder: (context, index) {
                        final ghost = _onlineGhosts[index];
                        return ListTile(
                          onTap: () => _sendPulse(ghost['name']!),
                          leading: const Icon(Icons.person_outline, size: 20, color: Colors.white30),
                          title: Text(ghost['name']!, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                          subtitle: Text(ghost['status']!, style: const TextStyle(fontSize: 10, color: Colors.cyanAccent)),
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