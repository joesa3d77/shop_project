import 'package:flutter/material.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/models/user_model.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final nameController = TextEditingController(text: widget.user?.name ?? '');
  late final phoneController = TextEditingController(text: widget.user?.phone ?? '');
  final apiClient = ApiClient();
  bool isLoading = false;

  Future<void> _save() async {
    setState(() => isLoading = true);
    try {
      await apiClient.putForm(ApiConstants.updateProfile, {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('done  ')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' error ')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(radius: 45, backgroundColor: AppColors.primarySoft, child: Icon(Icons.person, size: 45, color: AppColors.primary)),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(radius: 14, backgroundColor: AppColors.primary, child: const Icon(Icons.edit, size: 14, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(controller: nameController, hint: 'Full Name', icon: Icons.person_outline),
            const SizedBox(height: 12),
            CustomTextField(controller: phoneController, hint: 'Phone', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 24),
            CustomButton(text: 'Save', isLoading: isLoading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
