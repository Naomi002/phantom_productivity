import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
          useMaterial3: true),
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
  final AudioPlayer _player = AudioPlayer();
  final List<String> _history = [];

  // High-compatibility Lo-Fi loop for Chrome
  final String _ambientTrack =
      "https://actions.google.com/sounds/v1/ambiences/rain_on_roof.ogg";

  @override
  void initState() {
    super.initState();
    // This command tells the player to repeat the sound forever
    _player.setReleaseMode(ReleaseMode.loop);
  }

  void _toggleSession() async {
    if (_isActive) {
      _timer?.cancel();
      await _player.pause();
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

      try {
        await _player.setVolume(0.5);
        await _player.play(UrlSource(_ambientTrack));
      } catch (e) {
        debugPrint("Audio Error: $e");
      }
    }
  }

  void _handleFinish() {
    _timer?.cancel();
    _player.stop();
    setState(() {
      _isActive = false;
      _seconds = 1500;
      _history.insert(0,
          "Completed @ ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}");
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeStr =
        "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      body: Row(
        children: [
          // CENTER: TIMER AREA
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.blur_on, size: 80, color: Colors.cyanAccent),
                const Text("PHANTOMS",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: Colors.cyanAccent)),
                const SizedBox(height: 50),
                Text(timeStr,
                    style: const TextStyle(
                        fontSize: 100, fontWeight: FontWeight.w100)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _toggleSession,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                      side: const BorderSide(color: Colors.cyanAccent),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20)),
                  child: Text(_isActive ? "PAUSE" : "START FOCUSING"),
                ),
              ],
            ),
          ),

          Container(width: 0.5, color: Colors.white10),

          // RIGHT: GHOSTS & HISTORY
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0F172A),
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("LIVE GHOSTS",
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 10,
                              letterSpacing: 2))),
                  const ListTile(
                    leading: Icon(Icons.person_outline,
                        size: 16, color: Colors.white30),
                    title: Text("Phantom_Alpha",
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                    subtitle: Text("Deep Focus",
                        style:
                            TextStyle(fontSize: 9, color: Colors.cyanAccent)),
                  ),
                  const Divider(color: Colors.white10),
                  const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("HISTORY",
                          style: TextStyle(
                              color: Colors.white24,
                              fontSize: 10,
                              letterSpacing: 2))),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, i) => ListTile(
                          title: Text(_history[i],
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white24))),
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
