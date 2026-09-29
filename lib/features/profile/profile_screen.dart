import 'package:flutter/material.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/token_storage.dart';
import '../../core/models/user_model.dart';
import '../get_started/get_started_screen.dart';
import '../orders/orders_screen.dart';
import '../favorites/favorites_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final apiClient = ApiClient();
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final response = await apiClient.get(ApiConstants.getUserData);
      final data = response.data is Map && response.data['data'] is Map
          ? response.data['data']
          : response.data;
      setState(() {
        user = UserModel.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await TokenStorage.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primarySoft,
                    backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
                        ? NetworkImage(user!.image!)
                        : null,
                    child: (user?.image == null || user!.image!.isEmpty)
                        ? const Icon(Icons.person, size: 45, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(user?.name ?? 'User full Name',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _ProfileTile(
              icon: Icons.person_outline,
              title: 'My Profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
              ).then((_) => _loadUser()),
            ),
            _ProfileTile(
              icon: Icons.receipt_long_outlined,
              title: 'My Orders',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              ),
            ),
            _ProfileTile(
              icon: Icons.favorite_border,
              title: 'My Favorites',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
            ),
            _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            const Divider(height: 30),
            _ProfileTile(
              icon: Icons.logout,
              title: 'Log Out',
              color: AppColors.primary,
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _ProfileTile({required this.icon, required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      trailing: color == null ? const Icon(Icons.chevron_right, color: AppColors.grey) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
