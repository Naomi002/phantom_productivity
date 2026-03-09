import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // New Audio Engine

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
  final List<String> _focusHistory = [];

  // Audio Logic
  final AudioPlayer _audioPlayer = AudioPlayer();
  // Using a professional royalty-free ambient stream for testing
  final String _lofiUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

  final List<IconData> _phantomStyles = [Icons.blur_on, Icons.wb_sunny_outlined, Icons.all_inclusive, Icons.auto_awesome];
  final List<Map<String, String>> _onlineGhosts = [
    {"name": "Phantom_Alpha", "status": "Deep Focus"},
    {"name": "Ghost_User_99", "status": "Steady"},
    {"name": "Nawrose_Dev", "status": "Coding..."},
  ];

  void _toggleTimer() async {
    if (_isActive) {
      _timer?.cancel();
      await _audioPlayer.pause(); // Pause music
      setState(() => _isActive = false);
    } else {
      setState(() => _isActive = true);
      await _audioPlayer.play(UrlSource(_lofiUrl)); // Start Lo-Fi
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _timer?.cancel();
            _isActive = false;
            _audioPlayer.stop();
            _addHistory();
            _showRewardDialog();
          }
        });
      });
    }
  }

  void _addHistory() {
    final timestamp = "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    _focusHistory.insert(0, "Focused Session @ $timestamp");
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Deep Work Complete! 👻", style: TextStyle(color: Colors.cyanAccent)),
        content: const Text("Music stopped. Energy saved. Great job, Nabila."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _seconds = 1500);
            },
            child: const Text("READY", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    _audioPlayer.dispose(); // Always clean up audio memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _avatarIndex = (_avatarIndex + 1) % _phantomStyles.length),
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
                  child: Text(_isActive ? "PAUSE MUSIC & TIMER" : "START FOCUS MODE", style: const TextStyle(color: Colors.cyanAccent)),
                ),
                const Spacer(),
                // History log at bottom
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ListView.builder(
                    itemCount: _focusHistory.length,
                    itemBuilder: (context, index) => Text("• ${_focusHistory[index]}", style: const TextStyle(color: Colors.white24, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 0.5, color: Colors.white10),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0F172A),
              child: Center(child: Text("GHOSTS ONLINE: ${_onlineGhosts.length}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 10))),
            ),
          ),
        ],
      ),
    );
  }
}