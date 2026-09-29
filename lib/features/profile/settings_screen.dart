import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/colors/app_colors.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = 'EN';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => language = prefs.getString('app_language') ?? 'EN');
  }

  Future<void> _setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
    setState(() => language = lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Language', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                _langButton('AR'),
                const SizedBox(width: 8),
                _langButton('EN'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _langButton(String lang) {
    final selected = language == lang;
    return GestureDetector(
      onTap: () => _setLanguage(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.fieldBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(lang, style: TextStyle(color: selected ? Colors.white : Colors.black)),
      ),
    );
  }
}
