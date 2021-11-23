import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ufokatcher_app/view/homepage.dart';
import '/communication/api.dart';
import 'register.dart';
import 'link_page.dart';
import 'package:ufokatcher_app/main.dart';
import 'package:ufokatcher_app/storage/storage.dart';

String User_permission_info = "................";
String Admin_permission_info = "................";

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfile> {
  // const _MyAppState({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    Auto_check_permission(); //ถ้า Token ยังไม่หมดอายุ ไปหน้า Profile
  }

  Future Auto_check_permission() async {
    bool UserSession = false;
    bool UserAdminSession = false;
    await api_controller()
        .User_permission_check(User_token)
        .then((value) => User_permission_info = value.body);
    setState(() {
      if (User_permission_info.length > 0) {
        UserSession = true;
        User_permission_info;
      } else {
        UserSession = false;
        User_permission_info = "ไม่พบข้อมูล";
      }
    });

    await api_controller()
        .Admin_permission_check(User_token)
        .then((value) => Admin_permission_info = value.body);
    setState(() {
      if (Admin_permission_info.length > 0) {
        Admin_permission_info;
        UserAdminSession = true;
      } else {
        UserAdminSession = false;
        Admin_permission_info = "ไม่พบข้อมูล";
      }
    });
    if (UserSession == false &&
        UserAdminSession == false &&
        User_token.length > 10) {
      Storage_data().Token_Erase();
      // Navigator.pop(context);
      User_permission_info = "Token หมดอายุ";
      Admin_permission_info = "Token หมดอายุ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรไฟล์ของฉัน"),
      ),
      body: Center(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  /*
                  ElevatedButton(
                      onPressed: () async {
                        await api_controller()
                            .User_permission_check(User_token)
                            .then((value) => User_permission_info = value.body);
                        setState(() {
                          if (User_permission_info.length > 0) {
                            User_permission_info;
                          } else {
                            User_permission_info = "ไม่พบข้อมูล";
                          }
                        });

                        await api_controller()
                            .Admin_permission_check(User_token)
                            .then(
                                (value) => Admin_permission_info = value.body);
                        setState(() {
                          if (Admin_permission_info.length > 0) {
                            Admin_permission_info;
                          } else {
                            Admin_permission_info = "ไม่พบข้อมูล";
                          }
                        });
                      },
                      child: const Text("ตรวจสอบสิทธิ์ผู้ใช้งาน")),
                      */
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      "สิทธิ์ผู้ใช้งาน ระดับ Player =>" + User_permission_info),
                  Text(
                      "สิทธิ์ผู้ใช้งาน ระดับ Admin =>" + Admin_permission_info),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          User_permission_info = "................";
                          Admin_permission_info = "................";
                        });
                      },
                      child: Text("Clear ข้อมูล")),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          User_permission_info = "................";
                          Admin_permission_info = "................";
                        });
                        // Navigator.pop(context);

                        // Navigator.popUntil(
                        //      context, ModalRoute.withName("/main"));
                        //  Navigator.of(context).pushNamedAndRemoveUntil(
                        //     '/main', (Route<dynamic> route) => true);
                        Storage_data().Token_Erase();
                        Navigator.pop(context);

                        // Navigator.pushNamed(context, '/main');
                      },
                      child: Text("ออกจากระบบ"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
