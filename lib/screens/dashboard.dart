import 'package:flutter/material.dart';

import 'profile.dart';
import 'health_screen.dart';
import 'medicine_screen.dart';
import 'emergency_screen.dart';
import 'air_quality_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  final pages = [
    const HomeDashboard(),
    const HealthScreen(),
    const MedicineScreen(),
    const EmergencyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F9FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "AroCareX AI",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Health",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: "Medicine",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: "SOS",
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Hello 👋",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AirQualityScreen(),
      ),
    );
  },
  child: const DashboardTile(
    icon: Icons.air,
    title: "Air Quality",
    subtitle: "Check AQI around you",
  ),
),
          const Text(
            "Your AI health companion",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.cyan,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  "AI Health Score",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "92",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Health Tracking",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: const [
              Expanded(
                child: HealthCard(
                  icon: Icons.favorite,
                  title: "Heart",
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: HealthCard(
                  icon: Icons.bedtime,
                  title: "Sleep",
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: const [
              Expanded(
                child: HealthCard(
                  icon: Icons.directions_walk,
                  title: "Activity",
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: HealthCard(
                  icon: Icons.water_drop,
                  title: "Water",
                  color: Colors.blue,
                ),
              ),
            ],
          ),
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AirQualityScreen(),
      ),
    );
  },
  child: const DashboardTile(
    icon: Icons.air,
    title: "Air Quality",
    subtitle: "Check AQI around you",
  ),
),
          const SizedBox(height: 25),

          const DashboardTile(
            icon: Icons.medication,
            title: "Medicine Reminder",
            subtitle: "Next dose at 8:00 PM",
          ),

          const DashboardTile(
            icon: Icons.smart_toy,
            title: "AI Health Assistant",
            subtitle: "Ask health questions",
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AirQualityScreen(),
                ),
              );
            },
            child: const DashboardTile(
              icon: Icons.air,
              title: "Air Quality",
              subtitle: "Check AQI around you",
            ),
          ),

          const SizedBox(height: 15),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmergencyScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.emergency,
                    color: Colors.red,
                    size: 35,
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Emergency SOS",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

class HealthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const HealthCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DashboardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}