import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String age = '';
  String height = '';
  String bloodGroup = '';

  bool notifications = true;
  bool reminders = true;
  bool darkMode = false;

  List<MedicalReport> reports = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadReports();
  }

  // ============================================================
  // PROFILE STORAGE
  // ============================================================

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      name = prefs.getString('profile_name') ?? '';
      age = prefs.getString('profile_age') ?? '';
      height = prefs.getString('profile_height') ?? '';
      bloodGroup = prefs.getString('profile_blood') ?? '';
    });
  }

  Future<void> _saveProfile({
    required String newName,
    required String newAge,
    required String newHeight,
    required String newBlood,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_name', newName);
    await prefs.setString('profile_age', newAge);
    await prefs.setString('profile_height', newHeight);
    await prefs.setString('profile_blood', newBlood);

    if (!mounted) return;

    setState(() {
      name = newName;
      age = newAge;
      height = newHeight;
      bloodGroup = newBlood;
    });
  }

  // ============================================================
  // MEDICAL REPORT STORAGE
  // ============================================================

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();

    final savedReports = prefs.getStringList('medical_reports');

    if (savedReports == null) return;

    final loadedReports = <MedicalReport>[];

    for (final item in savedReports) {
      try {
        final json = jsonDecode(item);

        loadedReports.add(
          MedicalReport.fromJson(
            Map<String, dynamic>.from(json),
          ),
        );
      } catch (_) {
        // Ignore corrupted report entries.
      }
    }

    if (!mounted) return;

    setState(() {
      reports = loadedReports;
    });
  }

  Future<void> _saveReports() async {
    final prefs = await SharedPreferences.getInstance();

    final data = reports
        .map((report) => jsonEncode(report.toJson()))
        .toList();

    await prefs.setStringList(
      'medical_reports',
      data,
    );
  }

  // ============================================================
  // UPLOAD REPORT
  // ============================================================

  Future<void> _uploadMedicalReport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'webp',
        ],
        withData: true,
      );

      if (result == null) {
        return;
      }

      final file = result.files.single;

      if (file.bytes == null) {
        _showMessage(
          'Unable to read the selected file.',
        );
        return;
      }

      final nameController = TextEditingController(
        text: file.name.contains('.')
            ? file.name.substring(
                0,
                file.name.lastIndexOf('.'),
              )
            : file.name,
      );

      final reportName = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Name Medical Report',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Report name',
                hintText: 'Example: Blood Test',
                prefixIcon: Icon(
                  Icons.description_outlined,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final value =
                      nameController.text.trim();

                  Navigator.pop(
                    dialogContext,
                    value.isEmpty
                        ? file.name
                        : value,
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      nameController.dispose();

      if (reportName == null) {
        return;
      }

      final extension =
          file.extension?.toLowerCase() ?? '';

      final newReport = MedicalReport(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        name: reportName,
        fileName: file.name,
        extension: extension,
        fileBytes: Uint8List.fromList(file.bytes!),
        date: DateTime.now(),
      );

      setState(() {
        reports.insert(0, newReport);
      });

      await _saveReports();

      _showMessage(
        'Medical report uploaded successfully.',
      );
    } catch (e) {
      _showMessage(
        'Unable to upload the report.',
      );
    }
  }

  // ============================================================
  // DELETE REPORT
  // ============================================================

  Future<void> _deleteReport(
    MedicalReport report,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Report?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${report.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      reports.removeWhere(
        (item) => item.id == report.id,
      );
    });

    await _saveReports();

    _showMessage(
      'Medical report deleted.',
    );
  }

  // ============================================================
  // OPEN REPORT
  // ============================================================

  void _viewReport(MedicalReport report) {
    final isImage = [
      'jpg',
      'jpeg',
      'png',
      'webp',
    ].contains(report.extension);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportViewerPage(
          report: report,
          isImage: isImage,
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // MAIN PROFILE
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EFE6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF17231D),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          child: Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  22,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF263D30),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EFE8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFB9D0BC),
                          width: 4,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 58,
                        color: Color(0xFF52695A),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      name.isEmpty ? 'Your Profile' : name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'AROCAREX AI MEMBER',
                      style: TextStyle(
                        color: Color(0xFFAFC2B4),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _sectionLabel(
                'PERSONAL INFORMATION',
              ),

              const SizedBox(height: 10),

              _profileAction(
                icon: Icons.person_outline_rounded,
                title: 'Personal Details',
                subtitle:
                    'View your personal information',
                iconColor: const Color(0xFF4F6F59),
                onTap: _openPersonalDetails,
              ),

              _profileAction(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                subtitle:
                    'Update your personal information',
                iconColor: const Color(0xFF8768C7),
                onTap: _openEditProfile,
              ),

              const SizedBox(height: 22),

              _sectionLabel('MEDICAL'),

              const SizedBox(height: 10),

              _profileAction(
                icon: Icons.description_outlined,
                title: 'Medical Reports',
                subtitle:
                    '${reports.length} report${reports.length == 1 ? '' : 's'} stored',
                iconColor: const Color(0xFF3D91C7),
                onTap: _openMedicalReports,
              ),

              const SizedBox(height: 22),

              _sectionLabel('APP'),

              const SizedBox(height: 10),

              _profileAction(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle:
                    'Notifications and preferences',
                iconColor: const Color(0xFF68758E),
                onTap: _openSettings,
              ),

              _profileAction(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle:
                    'Manage your privacy preferences',
                iconColor: const Color(0xFF536D9A),
                onTap: _openPrivacy,
              ),

              const SizedBox(height: 18),

              GestureDetector(
                onTap: _showLogoutDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9E9),
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: const Color(0xFFFFCACA),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFD64D55),
                        size: 20,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFFD64D55),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'AROCAREX AI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xFF8C968E),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Your digital health companion',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9DA59E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MEDICAL REPORT PAGE
  // ============================================================

  void _openMedicalReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicalReportsPage(
          reports: reports,
          onUpload: _uploadMedicalReport,
          onDelete: _deleteReport,
          onView: _viewReport,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  void _openEditProfile() {
    final nameController =
        TextEditingController(text: name);

    final ageController =
        TextEditingController(text: age);

    final heightController =
        TextEditingController(text: height);

    final bloodController =
        TextEditingController(text: bloodGroup);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (pageContext) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3EFE6),

            appBar: AppBar(
              backgroundColor: const Color(0xFFF3EFE6),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xFF17231D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(
                color: Color(0xFF17231D),
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCE9DF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 55,
                      color: Color(0xFF52695A),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Update Your Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17231D),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _inputField(
                    controller: nameController,
                    label: 'Name',
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: ageController,
                    label: 'Age',
                    hint: 'Enter your age',
                    icon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: heightController,
                    label: 'Height (cm)',
                    hint: 'Enter your height',
                    icon: Icons.height_rounded,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: bloodController,
                    label: 'Blood Group',
                    hint: 'Example: O+',
                    icon: Icons.bloodtype_outlined,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _saveProfile(
                          newName:
                              nameController.text.trim(),
                          newAge:
                              ageController.text.trim(),
                          newHeight:
                              heightController.text.trim(),
                          newBlood:
                              bloodController.text.trim(),
                        );

                        if (!pageContext.mounted) {
                          return;
                        }

                        Navigator.pop(pageContext);

                        _showMessage(
                          'Profile updated successfully.',
                        );
                      },
                      icon: const Icon(
                        Icons.save_rounded,
                      ),
                      label: const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF314E3E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).then((_) {
      nameController.dispose();
      ageController.dispose();
      heightController.dispose();
      bloodController.dispose();
    });
  }

  // ============================================================
  // PERSONAL DETAILS
  // ============================================================

  void _openPersonalDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimpleProfilePage(
          title: 'Personal Details',
          icon: Icons.person_outline_rounded,
          color: const Color(0xFF4F6F59),
          children: [
            _infoCard(
              'Name',
              name.isEmpty ? 'Not added' : name,
              Icons.person_outline,
            ),
            _infoCard(
              'Age',
              age.isEmpty ? 'Not added' : '$age years',
              Icons.cake_outlined,
            ),
            _infoCard(
              'Height',
              height.isEmpty
                  ? 'Not added'
                  : '$height cm',
              Icons.height_rounded,
            ),
            _infoCard(
              'Blood Group',
              bloodGroup.isEmpty
                  ? 'Not added'
                  : bloodGroup,
              Icons.bloodtype_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatefulBuilder(
          builder: (context, setPageState) {
            return Scaffold(
              backgroundColor:
                  const Color(0xFFF3EFE6),

              appBar: AppBar(
                backgroundColor:
                    const Color(0xFFF3EFE6),
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Color(0xFF17231D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconTheme:
                    const IconThemeData(
                  color: Color(0xFF17231D),
                ),
              ),

              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _settingsTile(
                    icon:
                        Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle:
                        'Receive health notifications',
                    value: notifications,
                    onChanged: (value) {
                      setPageState(() {
                        notifications = value;
                      });
                    },
                  ),
                  _settingsTile(
                    icon: Icons.alarm_outlined,
                    title: 'Medicine Reminders',
                    subtitle:
                        'Get medicine reminders',
                    value: reminders,
                    onChanged: (value) {
                      setPageState(() {
                        reminders = value;
                      });
                    },
                  ),
                  _settingsTile(
                    icon:
                        Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle:
                        'Change app appearance',
                    value: darkMode,
                    onChanged: (value) {
                      setPageState(() {
                        darkMode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _settingsInfo(
                    Icons.info_outline,
                    'About AroCareX AI',
                    'Your digital health companion.',
                  ),
                  _settingsInfo(
                    Icons.verified_outlined,
                    'App Version',
                    'AroCareX AI 1.0.0',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  void _openPrivacy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimpleProfilePage(
          title: 'Privacy',
          icon: Icons.lock_outline_rounded,
          color: const Color(0xFF536D9A),
          children: [
            _infoCard(
              'Your Data',
              'Your profile information is used to personalize the app.',
              Icons.storage_outlined,
            ),
            _infoCard(
              'Health Information',
              'Only provide health information that is necessary.',
              Icons.health_and_safety_outlined,
            ),
            _infoCard(
              'Account Security',
              'Keep your account credentials private.',
              Icons.security_outlined,
            ),
            _infoCard(
              'Privacy Control',
              'You control the information you provide.',
              Icons.privacy_tip_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // UI HELPERS
  // ============================================================

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.7,
          color: Color(0xFF7C877F),
        ),
      ),
    );
  }

  Widget _profileAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
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
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF17231D),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF7D857F),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF9AA29C),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: Color(0xFF52695A),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFE7EEE8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF52695A),
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
                    fontSize: 12,
                    color: Color(0xFF7D857F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17231D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF52695A),
        secondary: Icon(
          icon,
          color: const Color(0xFF52695A),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _settingsInfo(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF52695A),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// MEDICAL REPORT MODEL
// ====================================================================

class MedicalReport {
  final String id;
  final String name;
  final String fileName;
  final String extension;
  final Uint8List fileBytes;
  final DateTime date;

  MedicalReport({
    required this.id,
    required this.name,
    required this.fileName,
    required this.extension,
    required this.fileBytes,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fileName': fileName,
      'extension': extension,
      'fileBytes': base64Encode(fileBytes),
      'date': date.toIso8601String(),
    };
  }

  factory MedicalReport.fromJson(
    Map<String, dynamic> json,
  ) {
    return MedicalReport(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Medical Report',
      fileName: json['fileName'] ?? '',
      extension: json['extension'] ?? '',
      fileBytes: base64Decode(
        json['fileBytes'] ?? '',
      ),
      date: DateTime.tryParse(
            json['date'] ?? '',
          ) ??
          DateTime.now(),
    );
  }
}

// ====================================================================
// MEDICAL REPORTS PAGE
// ====================================================================

class MedicalReportsPage extends StatefulWidget {
  final List<MedicalReport> reports;
  final Future<void> Function() onUpload;
  final Future<void> Function(MedicalReport) onDelete;
  final void Function(MedicalReport) onView;

  const MedicalReportsPage({
    super.key,
    required this.reports,
    required this.onUpload,
    required this.onDelete,
    required this.onView,
  });

  @override
  State<MedicalReportsPage> createState() =>
      _MedicalReportsPageState();
}

class _MedicalReportsPageState
    extends State<MedicalReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EFE6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Medical Reports',
          style: TextStyle(
            color: Color(0xFF17231D),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF17231D),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: const Color(0xFF314E3E),
        foregroundColor: Colors.white,
        onPressed: () async {
          await widget.onUpload();

          if (mounted) {
            setState(() {});
          }
        },
        icon: const Icon(
          Icons.upload_file_rounded,
        ),
        label: const Text(
          'Upload Report',
        ),
      ),

      body: widget.reports.isEmpty
          ? _emptyReports()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ),
              itemCount: widget.reports.length,
              itemBuilder: (context, index) {
                final report =
                    widget.reports[index];

                return _reportCard(report);
              },
            ),
    );
  }

  Widget _emptyReports() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFE3ECE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 55,
                color: Color(0xFF52695A),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Medical Reports',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17231D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Upload your medical reports here.\n'
              'PDF and image files are supported.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () async {
                await widget.onUpload();

                if (mounted) {
                  setState(() {});
                }
              },
              icon: const Icon(
                Icons.upload_file,
              ),
              label: const Text(
                'Upload First Report',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF314E3E),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportCard(
    MedicalReport report,
  ) {
    final isPdf = report.extension == 'pdf';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),

        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isPdf
                ? const Color(0xFFFFE4E4)
                : const Color(0xFFE3EEF7),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Icon(
            isPdf
                ? Icons.picture_as_pdf
                : Icons.image_outlined,
            color: isPdf
                ? const Color(0xFFD65353)
                : const Color(0xFF3D91C7),
            size: 27,
          ),
        ),

        title: Text(
          report.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${report.extension.toUpperCase()} • '
            '${_formatDate(report.date)}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'view') {
              widget.onView(report);
            } else if (value == 'delete') {
              _confirmDelete(report);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                  ),
                  SizedBox(width: 10),
                  Text('View'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),

        onTap: () {
          widget.onView(report);
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    MedicalReport report,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Report?',
          ),
          content: Text(
            'Delete "${report.name}" permanently?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await widget.onDelete(report);

      if (mounted) {
        setState(() {});
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ====================================================================
// REPORT VIEWER
// ====================================================================

class ReportViewerPage extends StatelessWidget {
  final MedicalReport report;
  final bool isImage;

  const ReportViewerPage({
    super.key,
    required this.report,
    required this.isImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          report.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: isImage
          ? Center(
              child: InteractiveViewer(
                child: Image.memory(
                  report.fileBytes,
                  fit: BoxFit.contain,
                ),
              ),
            )
          : SfPdfViewer.memory(
              report.fileBytes,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
            ),
    );
  }
}

// ====================================================================
// SIMPLE PROFILE PAGE
// ====================================================================

class SimpleProfilePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const SimpleProfilePage({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EFE6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF17231D),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF17231D),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 55,
                    color: color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ...children,
          ],
        ),
      ),
    );
  }
}

