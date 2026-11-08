import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIHealthDashboard extends StatefulWidget {
  const AIHealthDashboard({super.key});

  @override
  State<AIHealthDashboard> createState() => _AIHealthDashboardState();
}

class _AIHealthDashboardState extends State<AIHealthDashboard> {
  int _waterTaken = 0;
  final int _waterGoal = 2000;

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  void _addWater(int amount) {
    setState(() {
      final updated = _waterTaken + amount;
      _waterTaken = updated > _waterGoal ? _waterGoal : updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071715),
      body: Stack(
        children: [
          const Positioned(
            top: -100,
            right: -100,
            child: _GlowOrb(color: Color(0xFF00D6B3)),
          ),
          const Positioned(
            top: 480,
            left: -150,
            child: _GlowOrb(color: Color(0xFF315BFF)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      const SizedBox(height: 27),
                      _greeting(),
                      const SizedBox(height: 20),
                      _healthSummaryCard(),
                      const SizedBox(height: 25),
                      _sectionHeading('Your health', 'VIEW DETAILS'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _metricCard(
                              icon: Icons.favorite_rounded,
                              title: 'Heart rate',
                              value: '72',
                              unit: 'BPM',
                              color: const Color(0xFFFF7185),
                              onTap: () => _openPage(const HeartRatePage()),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _metricCard(
                              icon: Icons.bedtime_rounded,
                              title: 'Sleep',
                              value: '7.5',
                              unit: 'HRS',
                              color: const Color(0xFF9A8BFF),
                              onTap: () => _openPage(const SleepPage()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _waterCard(),
                      const SizedBox(height: 15),
                      _checkHealthButton(),
                      const SizedBox(height: 18),
                      const Center(
                        child: Text(
                          'Your daily wellness at a glance',
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFF66F5DC), Color(0xFF00A98F)],
            ),
          ),
          child: const Icon(Icons.favorite_rounded, color: Color(0xFF06231E)),
        ),
        const SizedBox(width: 11),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AroCareX',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            Text('HEALTH COMPANION',
                style: TextStyle(
                    color: Color(0xFF5FE4CE),
                    fontSize: 8,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800)),
          ],
        ),
        const Spacer(),
        _roundAction(Icons.notifications_none_rounded),
        const SizedBox(width: 9),
        _roundAction(Icons.person_outline_rounded),
      ],
    );
  }

  Widget _roundAction(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _greeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUNDAY • YOUR DAILY CHECK-IN',
            style: TextStyle(
                color: Colors.white54,
                fontSize: 9,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w800)),
        SizedBox(height: 8),
        Text('Good morning 👋',
            style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w900,
                letterSpacing: -.7)),
        SizedBox(height: 4),
        Text('Let’s see how you’re doing today.',
            style: TextStyle(color: Color(0xFF68E9D2), fontSize: 14)),
      ],
    );
  }

  Widget _healthSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF14443C), Color(0xFF0B2623)],
        ),
        border: Border.all(color: const Color(0xFF62EBD5).withOpacity(.17)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D7B2).withOpacity(.10),
            blurRadius: 32,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            height: 105,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: .82,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(.10),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF61F0D7)),
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('82',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900)),
                    Text('SCORE',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 8,
                            letterSpacing: 1.3)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 17),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You’re doing well',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 6),
                Text('Your latest wellness summary is ready.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 11, height: 1.35)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.circle, color: Color(0xFF63E4A4), size: 8),
                    SizedBox(width: 6),
                    Text('Stable today',
                        style: TextStyle(
                            color: Color(0xFF63E4A4),
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, String tag) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        const Spacer(),
        Text(tag,
            style: const TextStyle(
                color: Color(0xFF5FE4CE),
                fontSize: 8,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF102925),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: color, size: 19),
                ),
                const Spacer(),
                const Icon(Icons.arrow_outward_rounded,
                    color: Colors.white38, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(color: Colors.white60, fontSize: 10)),
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900)),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(unit,
                      style: TextStyle(
                          color: color,
                          fontSize: 8,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: color.withOpacity(.8),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF102925),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_rounded,
                  color: Color(0xFF58BFFF), size: 23),
              const SizedBox(width: 9),
              const Expanded(
                child: Text('Water intake',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
              ),
              Text('$_waterTaken / $_waterGoal ml',
                  style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _waterTaken / _waterGoal,
              minHeight: 7,
              backgroundColor: Colors.white.withOpacity(.08),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF58BFFF)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text('Keep sipping through the day',
                    style: TextStyle(color: Colors.white54, fontSize: 9)),
              ),
              _waterButton('+250', 250),
              const SizedBox(width: 6),
              _waterButton('+500', 500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _waterButton(String label, int amount) {
    return GestureDetector(
      onTap: () => _addWater(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF58BFFF).withOpacity(.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Color(0xFF78CCFF),
                fontSize: 9,
                fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _checkHealthButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: () => _openPage(const CheckHealthPage()),
        icon: const Icon(Icons.health_and_safety_rounded),
        label: const Text('CHECK MY HEALTH'),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF5FE4CE),
          foregroundColor: const Color(0xFF06231E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          textStyle: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.12),
          ),
        ),
      ),
    );
  }
}

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({super.key});
  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  final _controller = TextEditingController();
  int? _bpm;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _save() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < 20 || value > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid heart rate from 20 to 250 BPM.')));
      return;
    }
    setState(() => _bpm = value);
  }

  @override
  Widget build(BuildContext context) {
    final result = _bpm == null ? '' :
      _bpm! < 60 ? 'Below the typical adult resting range.' :
      _bpm! <= 100 ? 'Within the typical adult resting range.' :
      'Above the typical adult resting range.';
    return Scaffold(
      appBar: AppBar(title: const Text('Heart Rate')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Icon(Icons.favorite, size: 72, color: Colors.red),
        const SizedBox(height: 16),
        TextField(controller: _controller, keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Heart rate', suffixText: 'BPM',
            border: OutlineInputBorder())),
        const SizedBox(height: 12),
        FilledButton(onPressed: _save, child: const Text('Save reading')),
        if (_bpm != null) Card(child: ListTile(
          title: Text(_bpm.toString() + ' BPM'), subtitle: Text(result))),
        const SizedBox(height: 12),
        const Text('This simple comparison is for adult resting heart rates and is not a diagnosis.'),
      ]),
    );
  }
}

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});
  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final _controller = TextEditingController();
  double? _hours;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _save() {
    final value = double.tryParse(_controller.text.trim());
    if (value == null || value <= 0 || value > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter sleep time from 0 to 24 hours.')));
      return;
    }
    setState(() => _hours = value);
  }

  @override
  Widget build(BuildContext context) {
    final result = _hours == null ? '' :
      _hours! < 7 ? 'Below the common adult guide of 7–9 hours.' :
      _hours! <= 9 ? 'Within the common adult guide of 7–9 hours.' :
      'Above the common adult guide of 7–9 hours.';
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Icon(Icons.bedtime, size: 72, color: Colors.indigo),
        const SizedBox(height: 16),
        TextField(controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Sleep last night',
            suffixText: 'hours', hintText: 'Example: 7.5', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        FilledButton(onPressed: _save, child: const Text('Save sleep')),
        if (_hours != null) Card(child: ListTile(
          title: Text(_hours!.toStringAsFixed(1) + ' hours'), subtitle: Text(result))),
        const SizedBox(height: 12),
        const Text('The 7–9 hour comparison is a general guide for many adults. Sleep needs vary by age.'),
      ]),
    );
  }
}

class CheckHealthPage extends StatefulWidget {
  const CheckHealthPage({super.key});
  @override
  State<CheckHealthPage> createState() => _CheckHealthPageState();
}

class _CheckHealthPageState extends State<CheckHealthPage> {
  final _age = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  String _exercise = 'Yes';
  String _sleep = '5-8 Hours';
  String _food = 'Healthy';
  double? _bmi;
  int? _score;
  String _status = '';
  String _suggestion = '';

  @override
  void dispose() {
    _age.dispose(); _height.dispose(); _weight.dispose(); super.dispose();
  }

  Future<void> _checkHealth() async {
    final age = int.tryParse(_age.text.trim());
    final height = double.tryParse(_height.text.trim());
    final weight = double.tryParse(_weight.text.trim());
    if (age == null || age <= 0 || age > 120 || height == null || height <= 0 ||
        weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid age, height, and weight.')));
      return;
    }
    final bmi = weight / ((height / 100) * (height / 100));
    var score = 100;
    if (_exercise == 'No') score -= 15;
    if (_sleep == 'Less than 5 Hours') score -= 15;
    if (_food == 'Unhealthy') score -= 20;
    final status = score >= 80 ? 'Healthy' : score >= 60 ? 'Moderate risk' : 'Needs attention';
    final suggestion = score >= 80 ? 'Keep up your healthy habits.' :
      score >= 60 ? 'Consider improving exercise, food, and sleep habits.' :
      'Consider discussing your health habits with a healthcare professional.';
    setState(() { _bmi = bmi; _score = score; _status = status; _suggestion = suggestion; });

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('health_reports') ?? <String>[];
    history.add(jsonEncode({'date': DateTime.now().toIso8601String(), 'age': age,
      'bmi': bmi, 'score': score, 'status': status}));
    await prefs.setStringList('health_reports', history);
  }

  Widget _dropdown(String label, String value, List<String> options,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Check My Health')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Icon(Icons.monitor_heart, size: 72, color: Colors.teal),
      const SizedBox(height: 16),
      TextField(controller: _age, keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextField(controller: _height, keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextField(controller: _weight, keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      _dropdown('Exercise', _exercise, const ['Yes', 'No'],
        (v) { if (v != null) setState(() => _exercise = v); }),
      const SizedBox(height: 12),
      _dropdown('Sleep', _sleep, const ['Less than 5 Hours', '5-8 Hours', 'More than 8 Hours'],
        (v) { if (v != null) setState(() => _sleep = v); }),
      const SizedBox(height: 12),
      _dropdown('Food', _food, const ['Healthy', 'Average', 'Unhealthy'],
        (v) { if (v != null) setState(() => _food = v); }),
      const SizedBox(height: 16),
      FilledButton(onPressed: _checkHealth, child: const Text('Check my health')),
      if (_score != null) Card(
        child: Padding(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BMI: ' + _bmi!.toStringAsFixed(1)),
            Text('Lifestyle score: ' + _score.toString() + '/100'),
            Text('Status: ' + _status),
            const SizedBox(height: 8),
            Text(_suggestion),
          ],
        )),
      ),
      const SizedBox(height: 12),
      const Text('This lifestyle score is an app estimate, not a medical assessment. BMI alone does not determine health.'),
    ]),
  );
}
