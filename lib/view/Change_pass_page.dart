import 'package:flutter/material.dart';

import '../P.dart';
import '../widget/Text_field.dart';
import '../widget/app_color.dart';

class ChangePassPage extends StatelessWidget {
  ChangePassPage({super.key});
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
        backgroundColor: AppColor().green,
      ),
      backgroundColor: AppColor().green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(hintText: "Old password", obs: true, controller: _oldPassController),
              SizedBox(height: 30,),
              MyTextField(hintText: "New password", obs: true, controller: _newPassController),
              SizedBox(height: 30,),
              InkWell(
                onTap: () async {
                    P.auth.reauthenticateAndChangePassword(_oldPassController.text, _newPassController.text);
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor().white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('Change pass',style: TextStyle(color: AppColor().gray),)),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
