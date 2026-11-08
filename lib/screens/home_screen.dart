import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// EXISTING APP SCREENS
// ============================================================

import 'health_screen.dart';
import 'air_quality_screen.dart';
import 'family_health_screen.dart';
import 'medicine_screen.dart';
import 'profile.dart';
import 'emergency_screen.dart';
import 'ai_chat_screen.dart';
import 'report_screen.dart';

// ============================================================
// AROCAREX - ANIMATED UNIVERSAL HEALTH HOME
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _entryController;
  late AnimationController _ecgController;
  late AnimationController _waterController;
  late AnimationController _orbController;

  int waterGlasses = 5;

  int completedMissions = 2;

  String selectedMood = '';

  bool familyExpanded = false;

  final List<String> moods = [
    '😊',
    '🙂',
    '😐',
    '😟',
    '😴',
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _ecgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _waterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _ecgController.dispose();
    _waterController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _openHealth() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HealthScreen(),
      ),
    );
  }

  void _openHeartRate() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HeartRatePage()));
  }

  void _openSleep() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepPage()));
  }

  void _openEnergy() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const EnergyPage()));
  }

  void _openCheckHealth() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckHealthPage()));
  }
  void _openAirQuality() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AirQualityScreen(),
      ),
    );
  }

  void _openMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MedicineScreen(),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );
  }

  void _openEmergency() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EmergencyScreen(),
      ),
    );
  }

  void _openSearch() {
    final destinations = <(String, IconData, VoidCallback)>[
      ('Heart rate', Icons.favorite_rounded, _openHeartRate),
      ('Sleep', Icons.bedtime_rounded, _openSleep),
      ('Check my health', Icons.health_and_safety_rounded, _openCheckHealth),
      ('Medicine', Icons.medication_rounded, _openMedicine),
      ('Family health', Icons.family_restroom_rounded, _openFamilyHealth),
      ('Medical reports', Icons.description_outlined, _openReports),
      ('Air quality', Icons.air_rounded, _openAirQuality),
      ('Emergency support', Icons.emergency_rounded, _openEmergency),
      ('Health overview', Icons.monitor_heart_rounded, _openHealth),
    ];
    var query = '';

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final matches = destinations
              .where((item) => item.$1.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return AlertDialog(
            backgroundColor: const Color(0xFF141E31),
            title: const Text('Search AroCareX',
                style: TextStyle(color: Colors.white)),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search health features',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setDialogState(() => query = value),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: matches
                          .map((item) => ListTile(
                                leading: Icon(item.$2, color: const Color(0xFF5FE4CE)),
                                title: Text(item.$1,
                                    style: const TextStyle(color: Colors.white)),
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                  item.$3();
                                },
                              ))
                          .toList(),
                    ),
                  ),
                  if (matches.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No matching features',
                          style: TextStyle(color: Colors.white60)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openNotifications() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        decoration: const BoxDecoration(
          color: Color(0xFF141E31),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Medicine reminders and health updates will appear here.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.medication_rounded,
                  color: Color(0xFFB785FF),
                ),
                title: const Text(
                  'Medicine reminders',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Open your medicine schedule',
                  style: TextStyle(color: Colors.white60),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openMedicine();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.family_restroom_rounded,
                  color: Color(0xFF67D6FF),
                ),
                title: const Text(
                  'Family health',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'View family member updates',
                  style: TextStyle(color: Colors.white60),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openFamilyHealth();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _openFamilyHealth() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyHealthScreen()));
  }

  void _openAI() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AIChatScreen(),
      ),
    );
  }

  void _openReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReportScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool desktop = width >= 900;
    final bool tablet = width >= 600 && width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF080D1B),
      body: Stack(
        children: [
          _animatedBackground(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                desktop
                    ? 55
                    : tablet
                        ? 35
                        : 17,
                18,
                desktop
                    ? 55
                    : tablet
                        ? 35
                        : 17,
                125,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1250,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _animatedItem(
                        0.0,
                        _header(),
                      ),

                      const SizedBox(height: 25),

                      _animatedItem(
                        0.08,
                        _greeting(),
                      ),

                      const SizedBox(height: 22),

                      _animatedItem(
                        0.15,
                        _livingHealthOrb(),
                      ),

                      const SizedBox(height: 24),

                      _animatedItem(
                        0.23,
                        _dailyMissionCard(),
                      ),

                      const SizedBox(height: 25),

                      _animatedItem(
                        0.31,
                        _sectionTitle(
                          'Your body, right now',
                          'LIVE',
                        ),
                      ),

                      const SizedBox(height: 13),

                      _animatedItem(
                        0.37,
                        _vitalGrid(desktop),
                      ),

                      const SizedBox(height: 25),

                      _animatedItem(
                        0.405,
                        _checkHealthCard(),
                      ),

                      const SizedBox(height: 20),
                      _animatedItem(
                        0.43,
                        _sectionTitle(
                          'Daily signals',
                          'SMART',
                        ),
                      ),

                      const SizedBox(height: 13),

                      _animatedItem(
                        0.48,
                        _signalsGrid(desktop),
                      ),

                      const SizedBox(height: 25),

                      _animatedItem(
                        0.56,
                        _moodCard(),
                      ),

                      const SizedBox(height: 22),

                      _animatedItem(
                        0.63,
                        _aiAssistantCard(),
                      ),

                      const SizedBox(height: 22),

                      _animatedItem(
                        0.70,
                        _medicineTimeline(),
                      ),

                      const SizedBox(height: 22),

                      _animatedItem(
                        0.77,
                        _familyHealthCard(),
                      ),

                      const SizedBox(height: 22),

                      _animatedItem(
                        0.84,
                        _reportsCard(),
                      ),

                      const SizedBox(height: 22),

                      _animatedItem(
                        0.90,
                        _emergencyCard(),
                      ),

                      const SizedBox(height: 25),

                      Center(
                        child: Text(
                          'AroCareX • Intelligent care for every generation',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.3),
                            fontSize: 10,
                            letterSpacing: .7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom navigation removed as requested.
        ],
      ),
    );
  }

  // ============================================================
  // ANIMATED BACKGROUND
  // ============================================================

  Widget _animatedBackground() {
    return AnimatedBuilder(
      animation: _orbController,
      builder: (context, child) {
        final x = math.sin(
              _orbController.value * math.pi * 2,
            ) *
            25;

        final y = math.cos(
              _orbController.value * math.pi * 2,
            ) *
            20;

        return Stack(
          children: [
            Positioned(
              top: -150 + y,
              right: -120 + x,
              child: _glow(
                430,
                const Color(0xFF00E0B8),
              ),
            ),
            Positioned(
              top: 470 + y,
              left: -200 - x,
              child: _glow(
                430,
                const Color(0xFF176BFF),
              ),
            ),
            Positioned(
              bottom: -180 - y,
              right: -120 - x,
              child: _glow(
                400,
                const Color(0xFF7B4DFF),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _glow(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(.035),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.13),
            blurRadius: 150,
            spreadRadius: 35,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ENTRY ANIMATION
  // ============================================================

  Widget _animatedItem(
    double begin,
    Widget child,
  ) {
    final animation = CurvedAnimation(
      parent: _entryController,
      curve: Interval(
        begin,
        math.min(begin + .18, 1),
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              25 * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale =
                1 + (_pulseController.value * .035);

            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF63FFE3),
                  Color(0xFF00A98F),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00DDBA)
                      .withOpacity(.3),
                  blurRadius: 25,
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF05201B),
              size: 26,
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'AroCareX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'AI HEALTH COMPANION',
              style: TextStyle(
                color: Color(0xFF5FE4CE),
                fontSize: 8,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const Spacer(),

        _glassButton(
          Icons.search_rounded,
          _openSearch,
        ),

        const SizedBox(width: 8),

        _glassButton(
          Icons.notifications_none_rounded,
          _openNotifications,
        ),

        const SizedBox(width: 8),

        _glassButton(
          Icons.person_outline_rounded,
          _openProfile,
        ),
      ],
    );
  }

  Widget _glassButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.065),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(.1),
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  Widget _greeting() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'THURSDAY • AUG 20',
          style: TextStyle(
            color: Colors.white.withOpacity(.38),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Good evening 👋',
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Let’s take care of you today.',
          style: TextStyle(
            color: Color(0xFF5FE4CE),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LIVING HEALTH ORB
  // ============================================================

  Widget _livingHealthOrb() {
    return GestureDetector(
      onTap: _openHealth,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse =
              1 + (_pulseController.value * .025);

          return Transform.scale(
            scale: pulse,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF17213A)
                    .withOpacity(.96),
                const Color(0xFF10192F)
                    .withOpacity(.96),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF63FFE3)
                  .withOpacity(.13),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D9B4)
                    .withOpacity(.08),
                blurRadius: 45,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 650) {
                return Row(
                  children: [
                    Expanded(
                      child: _healthOrb(),
                    ),
                    Expanded(
                      child: _healthStatus(),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _healthOrb(),
                  const SizedBox(height: 15),
                  _healthStatus(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _healthOrb() {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _orbRing(230, .08),
          _orbRing(185, .14),
          _orbRing(145, .2),

          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _orbController.value *
                    math.pi *
                    2,
                child: child,
              );
            },
            child: SizedBox(
              width: 205,
              height: 205,
              child: CustomPaint(
                painter: _OrbitPainter(),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 +
                    (_pulseController.value * .045),
                child: child,
              );
            },
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF8BFFE9),
                    Color(0xFF00AD91),
                    Color(0xFF063A34),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5BF)
                        .withOpacity(.45),
                    blurRadius: 55,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  SizedBox(height: 3),
                  Text(
                    '88',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'HEALTH',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 7,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 20,
            right: 25,
            child: _floatingBadge(
              Icons.water_drop_rounded,
              '62%',
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: _floatingBadge(
              Icons.bolt_rounded,
              '88%',
            ),
          ),
        ],
      ),
    );
  }

  Widget _orbRing(
    double size,
    double opacity,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF5FE4CE)
              .withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _floatingBadge(
    IconData icon,
    String value,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: const Color(0xFF64F7DF),
              ),
              const SizedBox(width: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _healthStatus() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF5FE4CE)
                  .withOpacity(.1),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Text(
              '● BODY STATUS: STABLE',
              style: TextStyle(
                color: Color(0xFF5FE4CE),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Your body is\nin a good rhythm.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Your wellness signals look balanced today. Keep your momentum going.',
            style: TextStyle(
              color: Colors.white.withOpacity(.52),
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 17),

          _smallActionButton(
            'Explore my health',
            Icons.arrow_forward_rounded,
            _openHealth,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAILY MISSIONS
  // ============================================================

  Widget _dailyMissionCard() {
    final progress =
        completedMissions / 4;

    return _glassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.track_changes_rounded,
                const Color(0xFFFFC857),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today’s health mission',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Small actions • big difference',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$completedMissions/4',
                style: const TextStyle(
                  color: Color(0xFFFFD36B),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor:
                  Colors.white.withOpacity(.07),
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFFFFC857),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              _mission(
                '💧',
                'Drink water',
                completedMissions >= 1,
              ),
              _mission(
                '🚶',
                'Move 10 min',
                completedMissions >= 2,
              ),
              _mission(
                '🥗',
                'Healthy food',
                completedMissions >= 3,
              ),
              _mission(
                '😴',
                'Sleep on time',
                completedMissions >= 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mission(
    String emoji,
    String title,
    bool done,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!done) {
            completedMissions++;
          }
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 300),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: done
              ? const Color(0xFF50E3C2)
                  .withOpacity(.1)
              : Colors.white.withOpacity(.045),
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: done
                ? const Color(0xFF50E3C2)
                    .withOpacity(.25)
                : Colors.white.withOpacity(.07),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style:
                  const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: done
                    ? const Color(0xFF69F2D6)
                    : Colors.white70,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (done) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF69F2D6),
                size: 13,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // VITAL GRID
  // ============================================================

  Widget _vitalGrid(bool desktop) {
    final cards = [
      _vitalCard(
        Icons.favorite_rounded,
        const Color(0xFFFF5C76),
        'Heart',
        '72',
        'BPM',
        'Resting normally',
        true,
        _openHeartRate,
      ),
      _vitalCard(
        Icons.nightlight_round,
        const Color(0xFF8875FF),
        'Sleep',
        '7.4',
        'HRS',
        'Good recovery',
        false,
        _openSleep,
      ),
      _vitalCard(
        Icons.bolt_rounded,
        const Color(0xFFFFC44D),
        'Energy',
        '88',
        '%',
        'High energy',
        true,
        _openEnergy,
      ),
    ];

    if (desktop) {
      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 13),
          Expanded(child: cards[1]),
          const SizedBox(width: 13),
          Expanded(child: cards[2]),
        ],
      );
    }

    return Column(
      children: [
        cards[0],
        const SizedBox(height: 13),
        cards[1],
        const SizedBox(height: 13),
        cards[2],
      ],
    );
  }

  Widget _vitalCard(
    IconData icon,
    Color color,
    String title,
    String value,
    String unit,
    String subtitle,
    bool chart,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: _glassCard(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _iconBox(icon, color),
                const Spacer(),
                const Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white24,
                  size: 17,
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 3),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: color,
                      fontSize: 8,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: color,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),

            if (chart) ...[
              const SizedBox(height: 13),
              SizedBox(
                height: 27,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _ecgController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _ECGPainter(
                        color,
                        _ecgController.value,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  Widget _checkHealthCard() {
    return GestureDetector(
      onTap: _openCheckHealth,
      child: _glassCard(
        child: Row(
          children: [
            _iconBox(
              Icons.health_and_safety_rounded,
              const Color(0xFF5FE4CE),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check my health',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Create a personal wellness summary',
                    style: TextStyle(color: Colors.white54, fontSize: 9),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white54,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
  // DAILY SIGNALS
  // ============================================================

  Widget _signalsGrid(bool desktop) {
    final air = GestureDetector(
      onTap: _openAirQuality,
      child: _airCard(),
    );

    final hydration = GestureDetector(
      onTap: _openHealth,
      child: _hydrationCard(),
    );

    if (desktop) {
      return Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(child: air),
          const SizedBox(width: 13),
          Expanded(child: hydration),
        ],
      );
    }

    return Column(
      children: [
        air,
        const SizedBox(height: 13),
        hydration,
      ],
    );
  }

  Widget _airCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _cardHeading(
            Icons.air_rounded,
            const Color(0xFF5DB6FF),
            'Air quality',
            'LIVE',
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Text(
                '42',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 39,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF63E4A4)
                      .withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  'GOOD',
                  style: TextStyle(
                    color: Color(0xFF63E4A4),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          const Text(
            'Air around you is comfortable.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              _miniValue('PM2.5', '12'),
              _miniValue('PM10', '24'),
              _miniValue('TEMP', '29°'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hydrationCard() {
    final percentage =
        waterGlasses / 8;

    return _glassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _cardHeading(
            Icons.water_drop_rounded,
            const Color(0xFF4AAEFF),
            'Hydration',
            'TODAY',
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              const Text(
                '1.25 L',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '$waterGlasses / 8',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor:
                  Colors.white.withOpacity(.07),
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFF43AFFF),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Keep going — you’re doing well.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (waterGlasses < 8) {
                    setState(() {
                      waterGlasses++;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF43AFFF)
                        .withOpacity(.12),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: Color(0xFF43AFFF),
                        size: 14,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'ADD',
                        style: TextStyle(
                          color: Color(0xFF43AFFF),
                          fontSize: 8,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOOD
  // ============================================================

  Widget _moodCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'A simple check-in for your mind.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 17),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: moods.map((mood) {
              final selected =
                  selectedMood == mood;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMood = mood;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? const Color(0xFF5FE4CE)
                            .withOpacity(.15)
                        : Colors.white
                            .withOpacity(.045),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF5FE4CE)
                          : Colors.white
                              .withOpacity(.07),
                      width: selected ? 2 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color:
                                  const Color(
                                0xFF5FE4CE,
                              ).withOpacity(.15),
                              blurRadius: 18,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      mood,
                      style:
                          const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (selectedMood.isNotEmpty) ...[
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Thanks for checking in $selectedMood',
                style: const TextStyle(
                  color: Color(0xFF5FE4CE),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // AI ASSISTANT
  // ============================================================

  Widget _aiAssistantCard() {
    return GestureDetector(
      onTap: _openAI,
      child: Container(
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1C3262),
              Color(0xFF25194C),
            ],
          ),
          border: Border.all(
            color:
                const Color(0xFF8D9EFF)
                    .withOpacity(.17),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFF5D68FF)
                      .withOpacity(.12),
              blurRadius: 40,
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 +
                      (_pulseController.value *
                          .06),
                  child: child,
                );
              },
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF9A9FFF),
                      Color(0xFF5967FF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(0xFF6670FF)
                              .withOpacity(.25),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Talk to AroCareX AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ask about wellness, lifestyle, medicines and general health.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: _openAI,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(.09),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MEDICINE TIMELINE
  // ============================================================

  Widget _medicineTimeline() {
    return GestureDetector(
      onTap: _openMedicine,
      child: _glassCard(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _iconBox(
                  Icons.medication_rounded,
                  const Color(0xFFB785FF),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medicine timeline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Today’s medication schedule',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white30,
                  size: 15,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _medicineRow(
              '08:00 AM',
              'Morning medicine',
              true,
            ),

            _timelineLine(),

            _medicineRow(
              '01:00 PM',
              'Afternoon medicine',
              true,
            ),

            _timelineLine(),

            _medicineRow(
              '08:00 PM',
              'Evening medicine',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _medicineRow(
    String time,
    String title,
    bool completed,
  ) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? const Color(0xFF5FE4CE)
                : const Color(0xFFB785FF),
            boxShadow: [
              BoxShadow(
                color: (completed
                        ? const Color(0xFF5FE4CE)
                        : const Color(0xFFB785FF))
                    .withOpacity(.25),
                blurRadius: 10,
              ),
            ],
          ),
          child: completed
              ? const Icon(
                  Icons.check,
                  size: 10,
                  color: Color(0xFF05201B),
                )
              : null,
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 65,
          child: Text(
            time,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: completed
                  ? Colors.white54
                  : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Text(
          completed
              ? 'DONE'
              : 'UPCOMING',
          style: TextStyle(
            color: completed
                ? const Color(0xFF5FE4CE)
                : const Color(0xFFFFC86B),
            fontSize: 7,
            fontWeight: FontWeight.w900,
            letterSpacing: .7,
          ),
        ),
      ],
    );
  }

  Widget _timelineLine() {
    return Container(
      margin:
          const EdgeInsets.only(left: 7),
      height: 18,
      width: 1,
      color: Colors.white12,
    );
  }

  // ============================================================
  // FAMILY HEALTH
  // ============================================================

  Widget _familyHealthCard() {
    return _glassCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: _openFamilyHealth,

            child: Row(
              children: [
                _iconBox(
                  Icons.family_restroom_rounded,
                  const Color(0xFF67D6FF),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family health',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'One place for everyone you care about',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns:
                      familyExpanded ? .5 : 0,
                  duration:
                      const Duration(
                    milliseconds: 250,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          AnimatedCrossFade(
            duration:
                const Duration(milliseconds: 300),
            crossFadeState: familyExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild:
                const SizedBox.shrink(),
            secondChild: Padding(
              padding:
                  const EdgeInsets.only(
                top: 18,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _familyMember(
                      '👧',
                      'Child',
                      'Active',
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _familyMember(
                      '👩',
                      'Parent',
                      'Good',
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _familyMember(
                      '👴',
                      'Grandparent',
                      'Stable',
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

  Widget _familyMember(
    String emoji,
    String name,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(.04),
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color:
              Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style:
                const TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            status,
            style: const TextStyle(
              color: Color(0xFF5FE4CE),
              fontSize: 7,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORTS
  // ============================================================

  Widget _reportsCard() {
    return GestureDetector(
      onTap: _openReports,
      child: _glassCard(
        child: Row(
          children: [
            _iconBox(
              Icons.description_outlined,
              const Color(0xFFFF906E),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical reports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Reports, history and AI insights',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white30,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMERGENCY
  // ============================================================

  Widget _emergencyCard() {
    return GestureDetector(
      onTap: _openEmergency,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final opacity =
              .10 +
              (_pulseController.value * .08);

          return Container(
            padding:
                const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(24),
              color:
                  const Color(0xFF491E27)
                      .withOpacity(.65),
              border: Border.all(
                color:
                    const Color(0xFFFF6378)
                        .withOpacity(opacity),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(0xFFFF536D)
                          .withOpacity(.04),
                  blurRadius: 25,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFFF536D)
                        .withOpacity(.12),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.emergency_rounded,
                color: Color(0xFFFF6378),
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Quick access when every second matters',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFFF536D),
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.call_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _bottomNavigation() {
    return Positioned(
      left: 14,
      right: 14,
      bottom: 14,
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF111A2E)
                      .withOpacity(.94),
              borderRadius:
                  BorderRadius.circular(28),
              border: Border.all(
                color:
                    Colors.white.withOpacity(.1),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _bottomItem(
                  Icons.grid_view_rounded,
                  'Home',
                  true,
                  null,
                ),
                _bottomItem(
                  Icons.favorite_border_rounded,
                  'Health',
                  false,
                  _openHealth,
                ),
                _floatingAI(),
                _bottomItem(
                  Icons.medication_outlined,
                  'Medicine',
                  false,
                  _openMedicine,
                ),
                _bottomItem(
                  Icons.person_outline_rounded,
                  'Profile',
                  false,
                  _openProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(
    IconData icon,
    String title,
    bool active,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: active
                  ? const Color(0xFF5FE4CE)
                  : Colors.white38,
              size: 21,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingAI() {
    return GestureDetector(
      onTap: _openAI,
      child: Transform.translate(
        offset: const Offset(0, -15),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 59,
              height: 59,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF8491FF),
                    Color(0xFF5B55E8),
                  ],
                ),
                border: Border.all(
                  color:
                      const Color(0xFF061513),
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(0xFF6C6CFF)
                            .withOpacity(
                      .25 +
                          (_pulseController
                                  .value *
                              .18),
                    ),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMON WIDGETS
  // ============================================================

  Widget _glassCard({
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:
                const Color(0xFF121A2B).withOpacity(.90),
            borderRadius:
                BorderRadius.circular(25),
            border: Border.all(
              color:
                  const Color(0xFF7180AA).withOpacity(.20),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _iconBox(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    String label,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4BAF9E),
            fontSize: 8,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _cardHeading(
    IconData icon,
    Color color,
    String title,
    String label,
  ) {
    return Row(
      children: [
        _iconBox(icon, color),
        const SizedBox(width: 11),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(.3),
            fontSize: 7,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _miniValue(
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallActionButton(
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            colors: [
              Color(0xFF5DF2D8),
              Color(0xFF00B49A),
            ],
          ),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF06231F),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: const Color(0xFF06231F),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ECG PAINTER
// ============================================================

class _ECGPainter extends CustomPainter {
  final Color color;
  final double progress;

  _ECGPainter(
    this.color,
    this.progress,
  );

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(.75)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    final startX =
        -size.width * progress;

    path.moveTo(
      startX,
      size.height * .55,
    );

    for (double x = startX;
        x < size.width;
        x += 45) {
      final base =
          size.height * .55;

      path.lineTo(
        x + 10,
        base,
      );

      path.lineTo(
        x + 17,
        size.height * .25,
      );

      path.lineTo(
        x + 23,
        size.height * .78,
      );

      path.lineTo(
        x + 30,
        size.height * .12,
      );

      path.lineTo(
        x + 37,
        base,
      );

      path.lineTo(
        x + 45,
        base,
      );
    }

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ECGPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.color != color;
  }
}

// ============================================================
// ORBIT PAINTER
// ============================================================

class _OrbitPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2 - 8;

    final paint = Paint()
      ..color = const Color(0xFF67FFE5)
          .withOpacity(.35)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final angle =
          (math.pi * 2 / 5) * i;

      final x =
          center.dx +
          math.cos(angle) * radius;

      final y =
          center.dy +
          math.sin(angle) * radius;

      canvas.drawCircle(
        Offset(x, y),
        3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _OrbitPainter oldDelegate,
  ) {
    return false;
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


class EnergyPage extends StatefulWidget {
  const EnergyPage({super.key});

  @override
  State<EnergyPage> createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage> {
  double _level = 0.75;
  double? _lastLogged;

  String get _energyLabel {
    if (_level < .35) return 'Low energy';
    if (_level < .70) return 'Moderate energy';
    return 'High energy';
  }

  String get _suggestion {
    if (_level < .35) {
      return 'Take a short rest, drink some water, and consider whether you need food or a break.';
    }
    if (_level < .70) {
      return 'A short walk, some water, or a brief screen break may help you reset.';
    }
    return 'You’re feeling energized. Use it for a task that matters, and remember to pace yourself.';
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_level * 100).round();
    return Scaffold(
      backgroundColor: const Color(0xFF080D1B),
      appBar: AppBar(
        title: const Text('Energy & Focus'),
        backgroundColor: const Color(0xFF111A2E),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF24345B), Color(0xFF141D35)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.bolt_rounded,
                    color: Color(0xFFFFC44D), size: 32),
                const SizedBox(height: 12),
                Text('$percent%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900)),
                Text(_energyLabel,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Slider(
                  value: _level,
                  onChanged: (value) => setState(() => _level = value),
                  activeColor: const Color(0xFFFFC44D),
                  inactiveColor: Colors.white24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Low', style: TextStyle(color: Colors.white54)),
                    Text('High', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            color: const Color(0xFF141E31),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('A small reset',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(_suggestion,
                      style: const TextStyle(
                          color: Colors.white70, height: 1.45)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => setState(() => _lastLogged = _level),
            icon: const Icon(Icons.check_rounded),
            label: const Text('Log how I feel'),
          ),
          if (_lastLogged != null) ...[
            const SizedBox(height: 12),
            Text(
              'Last check-in: ' + (_lastLogged! * 100).round().toString() + '%',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'This is a personal check-in, not a medical measurement.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

