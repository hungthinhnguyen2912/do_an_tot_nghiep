import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduate/view/About_us_page.dart';
import 'package:graduate/view/Change_pass_page.dart';
import 'package:graduate/view/Edit_profile_page.dart';
import 'package:graduate/widget/app_color.dart';

import '../P.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().green,
        title: Text(
          "Setting ",
          style: TextStyle(color: AppColor().white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor().green,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Obx(() {
                      if (P.auth.avaUrl.value.isEmpty) {
                        return const Icon(Icons.account_circle, size: 48, color: Colors.white);
                      } else {
                        return CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(P.auth.avaUrl.value),
                        );
                      }
                    }),
                    const SizedBox(width: 12),
                    Obx(() {
                      if (P.auth.nameUser.value.isEmpty || P.auth.nameUser.value == "Không có tên") {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      } else {
                        return Text(
                          P.auth.nameUser.value,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        );
                      }
                    }),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          height: 160,
                          child: Column(
                            children: [
                              _buildImagePickerOption("Pick Image from Gallery", Icons.image, () async {
                                await P.pickImage.pickAva();
                                await P.pickImage.uploadAvaToCloudinary();
                                await P.auth.uploadAvaUrlToFirebase(P.pickImage.avaUrl.value);
                              }),
                              const SizedBox(height: 20),
                              _buildImagePickerOption("Capture Image from Camera", Icons.camera_alt, () async {
                                await P.pickImage.captureAva();
                                await P.pickImage.uploadAvaToCloudinary();
                                await P.auth.uploadAvaUrlToFirebase(P.auth.avaUrl.value);
                              }),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add_a_photo, size: 28, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Account Settings", style: TextStyle(color: Colors.grey)),
                ),
                _buildSettingsTile("Log out", Icons.logout, onTap: () => P.auth.signOut()),
                _buildSettingsTile("Edit profile", Icons.person, onTap: () {
                  Get.to(EditProfilePage());
                }),
                _buildSettingsTile("Change password", Icons.lock, onTap: () => Get.to(ChangePassPage())),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("More", style: TextStyle(color: Colors.grey)),
                ),
                _buildSettingsTile("About us", Icons.info,onTap: () {
                  Get.to(AboutUsPage());
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildImagePickerOption(String title, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor().green,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(color: Colors.white)),
      onPressed: onTap,
    );
  }
}
