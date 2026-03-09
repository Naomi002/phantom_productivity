import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

  // Expert Audio Configuration
  final AudioPlayer _player = AudioPlayer();
  // Using a direct, high-speed MP3 link that works well in Chrome
  final String _audioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

  final List<IconData> _phantomStyles = [Icons.blur_on, Icons.wb_sunny_outlined, Icons.all_inclusive, Icons.auto_awesome];

  @override
  void initState() {
    super.initState();
    // Pre-setting the volume and source for a smoother start
    _player.setReleaseMode(ReleaseMode.loop); // Keep the music looping!
    _player.setVolume(0.5); 
  }

  void _toggleSession() async {
    if (_isActive) {
      _timer?.cancel();
      await _player.pause(); // Stop the music
      setState(() => _isActive = false);
    } else {
      setState(() => _isActive = true);
      
      // Start Timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _timer?.cancel();
          _player.stop();
          _showReward();
        }
      });

      // Start Music with Error Handling
      try {
        await _player.play(UrlSource(_audioUrl));
      } catch (e) {
        debugPrint("Audio Playback Error: $e");
      }
    }
  }

  void _showReward() {
    setState(() {
      _isActive = false;
      _focusHistory.insert(0, "Completed @ ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}");
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Success, Nabila! 👻", style: TextStyle(color: Colors.cyanAccent)),
        content: const Text("Focus session recorded. Music paused."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _seconds = 1500);
            },
            child: const Text("RESET", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timeDisplay = "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _avatarIndex = (_avatarIndex + 1) % _phantomStyles.length),
                  child: Icon(_phantomStyles[_avatarIndex], size: 100, color: Colors.cyanAccent),
                ),
                const SizedBox(height: 10),
                const Text("PHANTOMS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.cyanAccent)),
                const SizedBox(height: 50),
                Text(timeDisplay, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.w100, color: Colors.white)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _toggleSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                    side: const BorderSide(color: Colors.cyanAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  child: Text(_isActive ? "PAUSE FOCUS" : "START FOCUS", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                ),
                if (_isActive) 
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("🎵 Audio Playing...", style: TextStyle(color: Colors.white24, fontSize: 12)),
                  ),
              ],
            ),
          ),
          Container(width: 0.5, color: Colors.white10),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0F172A),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("LOG", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, letterSpacing: 2)),
                  const Divider(color: Colors.white10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _focusHistory.length,
                      itemBuilder: (context, index) => Text("• ${_focusHistory[index]}", style: const TextStyle(color: Colors.white24, fontSize: 11)),
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