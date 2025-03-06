import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.settings, color: Colors.white),
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
                        return SizedBox(child: Icon(Icons.account_circle));
                      } else {
                        return CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(P.auth.avaUrl.value),
                        );
                      }
                    }),
                    const SizedBox(width: 12),
                    Obx(() {
                      if (P.auth.nameUser.value.isEmpty ||
                          P.auth.nameUser.value == "Không có tên") {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      } else {
                        return Text(
                          P.auth.nameUser.value,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        );
                      }
                    }),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: 160,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    await P.pickImage.pickAva();
                                    await P.pickImage.uploadAvaToCloudinary();
                                    await P.auth.uploadAvaUrlToFirebase(
                                      P.pickImage.avaUrl.value,
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "Pick Image from Gallery",
                                      style: TextStyle(color: AppColor().white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    P.pickImage.captureAva();
                                    P.pickImage.uploadAvaToCloudinary();
                                    P.auth.uploadAvaUrlToFirebase(
                                      P.auth.avaUrl.value,
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "Capture Image from Camera",
                                      style: TextStyle(color: AppColor().white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add_circle, size: 24),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Account Settings",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                _buildSettingsTile(
                  "Log out",
                  Icons.logout,
                  onTap: () {
                    P.auth.signOut();
                  },
                ),
                _buildSettingsTile("Edit profile", Icons.person),
                _buildSettingsTile("Change password", Icons.lock),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("More", style: TextStyle(color: Colors.grey)),
                ),
                _buildSettingsTile("About us", Icons.info),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: Colors.black54),
      title: Text(title),
      trailing: Switch(value: value, onChanged: (val) {}),
    );
  }
}
