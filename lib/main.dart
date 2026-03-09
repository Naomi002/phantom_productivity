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
  int _seconds = 1500; 
  Timer? _timer;
  bool _isActive = false;
  double _volume = 0.5;
  String _audioStatus = "Ready";

  final AudioPlayer _player = AudioPlayer();
  
  // Expert Fix: A built-in "Zen Chime" Data URI (No external link needed)
  final String _zenChime = "https://actions.google.com/sounds/v1/alarms/beep_short.ogg";

  void _toggleSession() async {
    if (_isActive) {
      _timer?.cancel();
      await _player.pause();
      setState(() { _isActive = false; _audioStatus = "Paused"; });
    } else {
      setState(() { _isActive = true; _audioStatus = "Flow State Active"; });

      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _stop();
        }
      });

      try {
        await _player.setVolume(_volume);
        // Using a reliable Google-hosted notification sound
        await _player.play(UrlSource(_zenChime));
        setState(() => _audioStatus = "🎵 Focus Ambient Active");
      } catch (e) {
        setState(() => _audioStatus = "Click Screen to Enable Audio");
      }
    }
  }

  void _stop() {
    _timer?.cancel();
    _player.stop();
    setState(() { _isActive = false; _seconds = 1500; _audioStatus = "Success!"; });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_on, size: 80, color: Colors.cyanAccent),
            const Text("PHANTOMS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.cyanAccent)),
            const SizedBox(height: 50),
            Text(
              "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}", 
              style: const TextStyle(fontSize: 120, fontWeight: FontWeight.w100, color: Colors.white)
            ),
            const SizedBox(height: 10),
            Text(_audioStatus, style: const TextStyle(color: Colors.white24, fontSize: 12)),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: Slider(
                value: _volume,
                activeColor: Colors.cyanAccent,
                onChanged: (val) {
                  setState(() => _volume = val);
                  _player.setVolume(val);
                },
              ),
            ),
            const Text("VOLUME", style: TextStyle(color: Colors.white24, fontSize: 10)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent.withOpacity(0.1), 
                side: const BorderSide(color: Colors.cyanAccent),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)
              ),
              child: Text(_isActive ? "PAUSE" : "START FOCUS", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}