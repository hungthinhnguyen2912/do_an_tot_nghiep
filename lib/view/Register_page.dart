import 'package:flutter/material.dart';
import 'package:graduate/service/auth_service.dart';
import 'package:graduate/view/Log_in_page.dart';
import 'package:graduate/widget/Text_field.dart';
import 'package:graduate/widget/app_color.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final TextEditingController _emailController = TextEditingController();

final TextEditingController _passController = TextEditingController();

final TextEditingController _nameController = TextEditingController();

final TextEditingController _confirmPassword = TextEditingController();

AuthService _auth = Get.put(AuthService());

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/ic_register.png'),
              SizedBox(height: 30),
              MyTextField(
                hintText: "User name",
                obs: false,
                controller: _nameController,
              ),
              SizedBox(height: 30),
              MyTextField(
                hintText: "Email",
                obs: false,
                controller: _emailController,
              ),
              SizedBox(height: 30),
              MyTextField(
                hintText: "Password",
                obs: true,
                controller: _passController,
              ),
              SizedBox(height: 30),
              MyTextField(
                hintText: "Confirm password",
                obs: true,
                controller: _confirmPassword,
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  print("Email: ${_emailController.text}");
                  print("Password: ${_passController.text}");

                  if (_emailController.text.trim().isEmpty ||
                      _passController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter email and password.");
                    return;
                  }
                  _auth.register(_emailController.text, _passController.text, _nameController.text);
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor().white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(color: AppColor().gray),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account ?  ",
                    style: TextStyle(fontSize: 20, color: AppColor().white),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.off(LogInPage());
                    },
                    child: Text("Log in", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
