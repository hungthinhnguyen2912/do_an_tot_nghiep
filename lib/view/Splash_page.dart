import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:graduate/widget/Bottom_navigation_bar.dart';
import 'package:graduate/widget/app_color.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    Timer(const Duration(seconds: 3), () {
      Get.off(() => BottomNavBar());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().green,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 2),
          child: Text("My app", style: TextStyle(fontSize: 32,color: AppColor().white)),
        ),
      ),
    );
  }
}