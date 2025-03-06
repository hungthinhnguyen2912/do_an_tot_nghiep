import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduate/widget/app_color.dart';

import '../P.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

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
              color: Colors.white,
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
                      if(P.auth.avaUrl.value == "") {
                        return SizedBox(
                          child: GestureDetector(
                            child: IconButton(onPressed: () {}, icon: Icon(Icons.add_circle,size: 24,))
                          ),
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150',
                          ), // Thay ảnh avatar
                        );
                      }
                    }),
                    const SizedBox(width: 12),
                    Obx(
                      () => Text(
                        P.auth.nameUser.value.isNotEmpty
                            ? P.auth.nameUser.value
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildSettingsTile(String title, IconData icon, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: () {},
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
