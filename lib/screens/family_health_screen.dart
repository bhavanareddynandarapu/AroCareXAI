import 'dart:ui';
import 'package:flutter/material.dart';
import 'medicine_screen.dart';
import 'report_screen.dart';
import 'ai_chat_screen.dart';

class FamilyHealthScreen extends StatefulWidget {
  const FamilyHealthScreen({super.key});

  @override
  State<FamilyHealthScreen> createState() => _FamilyHealthScreenState();
}

class _FamilyHealthScreenState extends State<FamilyHealthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  int selectedMember = 0;

  final List<FamilyMember> members = [
    FamilyMember(
      name: "You",
      relation: "Self",
      age: 21,
      emoji: "🧑",
      heartRate: "72",
      hydration: 6,
      sleep: "7.4",
      medicines: 1,
      reports: 2,
      emergency: "112",
    ),
    FamilyMember(
      name: "Mom",
      relation: "Mother",
      age: 45,
      emoji: "👩",
      heartRate: "76",
      hydration: 5,
      sleep: "7.1",
      medicines: 2,
      reports: 3,
      emergency: "112",
    ),
    FamilyMember(
      name: "Dad",
      relation: "Father",
      age: 50,
      emoji: "👨",
      heartRate: "74",
      hydration: 6,
      sleep: "6.8",
      medicines: 2,
      reports: 4,
      emergency: "112",
    ),
    FamilyMember(
      name: "Child",
      relation: "Child",
      age: 10,
      emoji: "👧",
      heartRate: "82",
      hydration: 5,
      sleep: "8.2",
      medicines: 0,
      reports: 1,
      emergency: "112",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  FamilyMember get currentMember => members[selectedMember];

  void _openMedicine() => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicineScreen()));
  void _openReports() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen()));
  void _openAI() => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIChatScreen()));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final desktop = width > 850;

    return Scaffold(
      backgroundColor: const Color(0xFF071715),
      body: Stack(
        children: [
          _background(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                desktop ? 55 : 18,
                18,
                desktop ? 55 : 18,
                40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),

                      const SizedBox(height: 30),

                      _title(),

                      const SizedBox(height: 25),

                      _familySelector(),

                      const SizedBox(height: 25),

                      _memberHero(),

                      const SizedBox(height: 25),

                      _sectionTitle(
                        "Health overview",
                        "LIVE PROFILE",
                      ),

                      const SizedBox(height: 15),

                      desktop
                          ? Row(
                              children: [
                                Expanded(child: _heartCard()),
                                const SizedBox(width: 14),
                                Expanded(child: _hydrationCard()),
                                const SizedBox(width: 14),
                                Expanded(child: _sleepCard()),
                              ],
                            )
                          : Column(
                              children: [
                                _heartCard(),
                                const SizedBox(height: 14),
                                _hydrationCard(),
                                const SizedBox(height: 14),
                                _sleepCard(),
                              ],
                            ),

                      const SizedBox(height: 25),

                      desktop
                          ? Row(
                              children: [
                                Expanded(child: _medicineCard()),
                                const SizedBox(width: 14),
                                Expanded(child: _reportsCard()),
                              ],
                            )
                          : Column(
                              children: [
                                _medicineCard(),
                                const SizedBox(height: 14),
                                _reportsCard(),
                              ],
                            ),

                      const SizedBox(height: 25),

                      _aiInsight(),

                      const SizedBox(height: 25),

                      _emergencyCard(),

                      const SizedBox(height: 25),

                      _addMemberButton(),
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

  // ============================================================
  // BACKGROUND
  // ============================================================

  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -160,
          right: -100,
          child: _glow(
            400,
            const Color(0xFF00E0B8),
          ),
        ),
        Positioned(
          top: 450,
          left: -180,
          child: _glow(
            380,
            const Color(0xFF176BFF),
          ),
        ),
        Positioned(
          bottom: -180,
          right: -120,
          child: _glow(
            400,
            const Color(0xFF7040FF),
          ),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(.05),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.12),
            blurRadius: 150,
            spreadRadius: 25,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(.1),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 13),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AroCareX",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "FAMILY HEALTH",
                style: TextStyle(
                  color: Color(0xFF5FE4CE),
                  fontSize: 8,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.06),
            border: Border.all(
              color: Colors.white.withOpacity(.1),
            ),
          ),
          child: const Icon(
            Icons.family_restroom_rounded,
            color: Color(0xFF5FE4CE),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TITLE
  // ============================================================

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ONE FAMILY.",
          style: TextStyle(
            color: Colors.white.withOpacity(.35),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          "Everyone's health,",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),

        const Text(
          "in one place.",
          style: TextStyle(
            color: Color(0xFF5FE4CE),
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Monitor and manage the health of your family members.",
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FAMILY SELECTOR
  // ============================================================

  Widget _familySelector() {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: members.length + 1,
        itemBuilder: (context, index) {
          if (index == members.length) {
            return _addMemberSmall();
          }

          final member = members[index];
          final selected = selectedMember == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMember = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 105,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: selected
                    ? const Color(0xFF103A34)
                    : Colors.white.withOpacity(.045),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF5FE4CE)
                      : Colors.white.withOpacity(.08),
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00DDBA)
                              .withOpacity(.12),
                          blurRadius: 25,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    member.name,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.relation,
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // MEMBER HERO
  // ============================================================

  Widget _memberHero() {
    final member = currentMember;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(.08, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(member.name),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF123C36),
              Color(0xFF0A2421),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF5FE4CE).withOpacity(.12),
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final scale =
                    1 + (_animationController.value * .04);

                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.06),
                  border: Border.all(
                    color: const Color(0xFF5FE4CE)
                        .withOpacity(.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    member.emoji,
                    style: const TextStyle(fontSize: 39),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${member.relation} • ${member.age} years",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _statusDot(),
                      const SizedBox(width: 7),
                      const Text(
                        "Health status stable",
                        style: TextStyle(
                          color: Color(0xFF63E4A4),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white30,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF63E4A4),
      ),
    );
  }

  // ============================================================
  // HEALTH CARDS
  // ============================================================

  Widget _heartCard() {
    final member = currentMember;

    return _healthCard(
      icon: Icons.favorite_rounded,
      color: const Color(0xFFFF6078),
      title: "Heart rate",
      value: member.heartRate,
      unit: "BPM",
      subtitle: "Within normal range",
    );
  }

  Widget _hydrationCard() {
    final member = currentMember;

    return _healthCard(
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF4AAEFF),
      title: "Hydration",
      value: "${member.hydration}",
      unit: "/ 8",
      subtitle: "Glasses today",
    );
  }

  Widget _sleepCard() {
    final member = currentMember;

    return _healthCard(
      icon: Icons.nightlight_round,
      color: const Color(0xFF8875FF),
      title: "Sleep",
      value: member.sleep,
      unit: "HRS",
      subtitle: "Good recovery",
    );
  }

  Widget _healthCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String unit,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.055),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      unit,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MEDICINE
  // ============================================================

  Widget _medicineCard() {
    final count = currentMember.medicines;
    return _largeCard(
      icon: Icons.medication_rounded,
      color: const Color(0xFFB785FF),
      title: 'Medicines',
      subtitle: count == 0 ? 'No medicines scheduled' : '$count medicines scheduled today',
      trailing: count == 0 ? 'OPEN' : '$count',
      onTap: _openMedicine,
    );
  }

  Widget _reportsCard() {
    final count = currentMember.reports;
    return _largeCard(
      icon: Icons.description_outlined,
      color: const Color(0xFFFF906E),
      title: 'Medical records',
      subtitle: '$count records shown • Tap to upload or view',
      trailing: 'OPEN',
      onTap: _openReports,
    );
  }

  // ============================================================
  // AI INSIGHT
  Widget _aiInsight() {
    final member = currentMember;

    return GestureDetector(
      onTap: () {
        _showMessage(
          "AroCareX AI",
          "AI insights for ${member.name}:\n\n"
              "• Heart rate: ${member.heartRate} BPM\n"
              "• Hydration: ${member.hydration}/8 glasses\n"
              "• Sleep: ${member.sleep} hours\n\n"
              "Keep following healthy daily habits.",
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF202B5C),
              Color(0xFF291A4C),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF8995FF).withOpacity(.15),
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9B9FFF),
                        Color(0xFF5B62EF),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6A70FF)
                            .withOpacity(
                          .15 +
                              (_animationController.value * .2),
                        ),
                        blurRadius: 25,
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

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AroCareX AI Insight",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Get a simple health summary for this family member.",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white70,
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
      onTap: _showEmergency,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFF491E27).withOpacity(.65),
          border: Border.all(
            color: const Color(0xFFFF6378).withOpacity(.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFF536D).withOpacity(.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.emergency_rounded,
                color: Color(0xFFFF6378),
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emergency support",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Quick access to emergency services",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFF536D),
                borderRadius: BorderRadius.circular(13),
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
  // ADD MEMBER
  // ============================================================

  Widget _addMemberButton() {
    return GestureDetector(
      onTap: _addMember,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF5FE4CE).withOpacity(.08),
          border: Border.all(
            color: const Color(0xFF5FE4CE).withOpacity(.2),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Color(0xFF5FE4CE),
              size: 21,
            ),
            SizedBox(width: 8),
            Text(
              "ADD FAMILY MEMBER",
              style: TextStyle(
                color: Color(0xFF5FE4CE),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMemberSmall() {
    return GestureDetector(
      onTap: _addMember,
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(.035),
          border: Border.all(
            color: Colors.white.withOpacity(.1),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Color(0xFF5FE4CE),
              size: 28,
            ),
            SizedBox(height: 7),
            Text(
              "ADD",
              style: TextStyle(
                color: Color(0xFF5FE4CE),
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LARGE CARD
  // ============================================================

  Widget _largeCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.055),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: Colors.white.withOpacity(.08),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  trailing,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white30,
                  size: 13,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

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
            letterSpacing: 1.4,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String title,
    String message,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF102A26),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF00B89F),
                      foregroundColor:
                          const Color(0xFF06211C),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EMERGENCY DIALOG
  // ============================================================

  void _showEmergency() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(23),
          decoration: const BoxDecoration(
            color: Color(0xFF241517),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Emergency Support",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 18),

              _emergencyRow(
                "108",
                "Ambulance",
                Icons.local_hospital_rounded,
              ),

              _emergencyRow(
                "112",
                "Emergency",
                Icons.emergency_rounded,
              ),

              _emergencyRow(
                "100",
                "Police",
                Icons.local_police_rounded,
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _emergencyRow(
    String number,
    String title,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF6578),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Text(
            number,
            style: const TextStyle(
              color: Color(0xFFFF6578),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD MEMBER
  // ============================================================

  void _addMember() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext)
                .viewInsets
                .bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF102A26),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add family member",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Create a simple health profile.",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                _input(
                  controller: nameController,
                  label: "Name",
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 12),

                _input(
                  controller: ageController,
                  label: "Age",
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final name =
                          nameController.text.trim();

                      final age =
                          int.tryParse(
                                ageController.text,
                              ) ??
                              0;

                      if (name.isEmpty || age <= 0) {
                        return;
                      }

                      setState(() {
                        members.add(
                          FamilyMember(
                            name: name,
                            relation: "Family",
                            age: age,
                            emoji: "👤",
                            heartRate: "--",
                            hydration: 0,
                            sleep: "--",
                            medicines: 0,
                            reports: 0,
                            emergency: "112",
                          ),
                        );

                        selectedMember =
                            members.length - 1;
                      });

                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF5FE4CE),
                      foregroundColor:
                          const Color(0xFF06211C),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "SAVE MEMBER",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF5FE4CE),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF5FE4CE),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FAMILY MEMBER MODEL
// ============================================================

class FamilyMember {
  final String name;
  final String relation;
  final int age;
  final String emoji;

  final String heartRate;
  final int hydration;
  final String sleep;

  final int medicines;
  final int reports;
  final String emergency;

  FamilyMember({
    required this.name,
    required this.relation,
    required this.age,
    required this.emoji,
    required this.heartRate,
    required this.hydration,
    required this.sleep,
    required this.medicines,
    required this.reports,
    required this.emergency,
  });
}