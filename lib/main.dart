import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const PhantomApp());

class PhantomApp extends StatelessWidget {
  const PhantomApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF0B0E14), useMaterial3: true),
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
  
  // Weekly Stats: Monday to Sunday (Sprints per day)
  final List<int> _weeklyStats = [2, 5, 3, 8, 4, 1, 0]; 
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  final List<IconData> _phantomStyles = [Icons.blur_on, Icons.wb_sunny_outlined, Icons.all_inclusive, Icons.auto_awesome_mosaic];

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
      // Update today's stat (assuming today is index 6 for Sunday)
      _weeklyStats[6]++; 
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (1500 - _seconds) / 1500;
    String timeStr = "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDEBAR: LIVE GHOSTS
          _buildSidebar("LIVE GHOSTS", [
            const ListTile(title: Text("Phantom_Alpha", style: TextStyle(fontSize: 12)), subtitle: Text("Focusing", style: TextStyle(fontSize: 9, color: Colors.cyanAccent))),
            const ListTile(title: Text("Nawrose_Naomi", style: TextStyle(fontSize: 12)), subtitle: Text("Coding", style: TextStyle(fontSize: 9, color: Colors.cyanAccent))),
          ]),

          // CENTER: TIMER
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _avatarIndex = (_avatarIndex + 1) % _phantomStyles.length),
                  child: Icon(_phantomStyles[_avatarIndex], size: 80, color: Colors.cyanAccent),
                ),
                const SizedBox(height: 60),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(height: 300, width: 300, child: CircularProgressIndicator(value: progress, strokeWidth: 4, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(Colors.cyanAccent))),
                    Text(timeStr, style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w100)),
                  ],
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: _toggleSession,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent.withOpacity(0.1), side: const BorderSide(color: Colors.cyanAccent), padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  child: Text(_isActive ? "PAUSE" : "START FOCUSING", style: const TextStyle(color: Colors.cyanAccent)),
                ),
              ],
            ),
          ),

          // RIGHT SIDEBAR: ANALYTICS BAR CHART
          Container(
            width: 250,
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(30), child: Text("WEEKLY FOCUS", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold))),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) => _buildBar(index)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index) {
    double height = (_weeklyStats[index] * 20.0).clamp(5.0, 200.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(_weeklyStats[index].toString(), style: const TextStyle(fontSize: 8, color: Colors.white24)),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 12,
          height: height,
          decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.6), borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 8),
        Text(_days[index], style: const TextStyle(fontSize: 10, color: Colors.white30)),
      ],
    );
  }

  Widget _buildSidebar(String title, List<Widget> items) {
    return Container(
      width: 250,
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(30), child: Text(title, style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, letterSpacing: 2))),
          ...items,
        ],
      ),
    );
  }
}