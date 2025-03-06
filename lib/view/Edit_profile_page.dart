import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../P.dart';
import '../widget/app_color.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isEditingUsername = false;
  bool isEditingEmail = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor().green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEditableTextField(
              controller: _usernameController,
              label: P.auth.nameUser.value,
              isEditing: isEditingUsername,
              onEdit: () {
                setState(() {
                  isEditingUsername = !isEditingUsername;
                });
              },
            ),
            SizedBox(height: 20),
            _buildEditableTextField(
              controller: _emailController,
              label: P.auth.emailUser.value,
              isEditing: isEditingEmail,
              onEdit: () {
                setState(() {
                  isEditingEmail = !isEditingEmail;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: onEdit,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}