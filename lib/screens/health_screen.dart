import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF09111F);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('My Health'),
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF263A65), Color(0xFF171F3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WELLNESS OVERVIEW',
                    style: TextStyle(color: Color(0xFF9FB5FF), fontSize: 10,
                        letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('85 / 100', style: TextStyle(color: Colors.white,
                    fontSize: 38, fontWeight: FontWeight.w900)),
                SizedBox(height: 5),
                Text('Your health condition looks good',
                    style: TextStyle(color: Colors.white70)),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: .85, minHeight: 7,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF75E3C3)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Health metrics',
              style: TextStyle(color: Colors.white, fontSize: 19,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _MetricTile(icon: Icons.favorite_rounded,
                title: 'Heart rate', value: '72 BPM',
                color: Color(0xFFFF7185))),
            SizedBox(width: 12),
            Expanded(child: _MetricTile(icon: Icons.bedtime_rounded,
                title: 'Sleep', value: '7.5 hours',
                color: Color(0xFF9D8CFF))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _MetricTile(icon: Icons.psychology_rounded,
                title: 'Stress', value: 'Low',
                color: Color(0xFFFFB454))),
            SizedBox(width: 12),
            Expanded(child: _MetricTile(icon: Icons.directions_walk_rounded,
                title: 'Activity', value: '6,500 steps',
                color: Color(0xFF62D99B))),
          ]),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF141E31),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI insights', style: TextStyle(color: Colors.white,
                    fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                _Insight(text: 'Your activity level is healthy.'),
                _Insight(text: 'Keep a regular sleep schedule.'),
                _Insight(text: 'Drink water regularly through the day.'),
                _Insight(text: 'Continue habits that help you feel well.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.title,
    required this.value, required this.color});
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141E31),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 27),
        const SizedBox(height: 18),
        Text(title, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white,
            fontSize: 17, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _Insight extends StatelessWidget {
  const _Insight({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(children: [
      const Icon(Icons.check_circle, color: Color(0xFF75E3C3), size: 17),
      const SizedBox(width: 9),
      Expanded(child: Text(text,
          style: const TextStyle(color: Colors.white70, fontSize: 12))),
    ]),
  );
}
