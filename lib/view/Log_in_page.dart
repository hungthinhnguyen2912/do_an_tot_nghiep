import 'package:flutter/material.dart';
import 'package:graduate/service/auth_service.dart';
import 'package:graduate/view/Register_page.dart';
import 'package:graduate/widget/Text_field.dart';
import 'package:graduate/widget/app_color.dart';
import 'package:get/get.dart';
class LogInPage extends StatefulWidget {
  LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  final AuthService _auth = Get.put(AuthService());

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
              Image.asset('assets/images/ic_login.png'),
              SizedBox(height: 30,),
              MyTextField(hintText: "Email", obs: false, controller: _emailController),
              SizedBox(height: 30,),
              MyTextField(hintText: "Password", obs: true, controller: _passController),
              SizedBox(height: 30,),
              InkWell(
                onTap: () async {
                  await _auth.signIn(_emailController.text, _passController.text);
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor().white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('Log in',style: TextStyle(color: AppColor().gray),)),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New user ? ",style: TextStyle(fontSize: 20,color: AppColor().white),),
                  TextButton(onPressed: () {
                    Get.to(RegisterPage());
                  }, child: Text("Register",style: TextStyle(fontSize: 20),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}