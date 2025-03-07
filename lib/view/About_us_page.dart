import 'package:flutter/material.dart';
import 'package:graduate/widget/app_color.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().green,
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/me.jpg",width: 80,height: 120,),

            const SizedBox(height: 16),
            const Text(
              "Nguyễn Hưng Thịnh",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Ha Noi university of industry",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              "Provider: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/firebase_logo.png", width: 60),
                const SizedBox(width: 20),
                Image.asset("assets/images/cloudinary_logo.png", width: 60),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "This is a mobile app can help people classify vegetable",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
