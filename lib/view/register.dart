// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ufokatcher_app/storage/storage.dart';
import 'package:ufokatcher_app/view/link_page.dart';
import '/communication/api.dart';
import '/view/profile.dart';
import 'link_page.dart';

String Username_input = "";
String Password_input = "";
String Password_input_confirm = "";
String Email_input = "";
bool Register_menu_state = true;
String User_token = "";

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'โปรไฟล์';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyRegister(),
      ),
      initialRoute: '/',
      routes: {
        '/main': (context) => Launcher(),
        //  '/second': (context) => SecondScreen(),
        '/second': (context) => MyProfile(),
      },
    );
    /*
    MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyRegister(),
      ),
    );
    */
  }
}

// Create a Form widget.
class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  MyRegisterState createState() {
    return MyRegisterState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyRegisterState extends State<MyRegister> {
  @override
  void initState() {
    super.initState();

    check_token_exp_state(); //ถ้า Token ยังไม่หมดอายุ ไปหน้า Profile
  }

  Future check_token_exp_state() async {
    await Storage_data().Token_initial();
    //await Future.delayed(const Duration(seconds: 1));

    String token_checking = "";
    token_checking = Storage_data().Token_Getting();
    try {
      if (token_checking.length > 10) {
        print('Token_result.....');
        print(token_checking);
        User_token = token_checking;
        Navigator.pushNamed(context, '/second');
      } else {
        print("token_checking no data");
        print(token_checking);
      }
    } catch (e) {}
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      labelText: 'Username',
                      hintText: 'กรุณาระบุ Username ที่ต้องการใช้งาน',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (value) {
                    Username_input = value.toString();
                  },
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดอย่าเว้นว่าง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  cursorHeight: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelText: 'Password',
                      hintText: 'กรุณาระบุรหัสผ่านอย่างน้อย 8 ตัว',
                      labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (value) {
                    Password_input = value.toString();
                  },
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดอย่าเว้นว่าง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Register_menu_state
                    ? Container(
                        child: Column(
                        children: <Widget>[
                          TextFormField(
                            cursorHeight: 5,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                labelText: 'Confirm Password',
                                hintText: 'กรุณายืนยันรหัสผ่านอย่างน้อย 8 ตัว',
                                labelStyle: TextStyle(color: Colors.blue)),
                            onChanged: (value) {
                              Password_input_confirm = value.toString();
                            },
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'โปรดอย่าเว้นว่าง';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                labelText: 'E-mail',
                                hintText: 'กรุณาระบุอีเมลล์',
                                labelStyle: TextStyle(color: Colors.blue)),
                            onChanged: (value) {
                              Email_input = value.toString();
                            },
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'โปรดอย่าเว้นว่าง';
                              }
                              return null;
                            },
                          )
                        ],
                      ))
                    : Container(),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Row(
                children: <Widget>[
                  Register_menu_state
                      ? Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool Register_succeed = false;
                                Map http_status_ = {};
                                var http_raw_state;
                                if (Password_input_confirm == Password_input &&
                                    Register_menu_state == true) {
                                  try {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'กำลังสมัครสมาชิกสำหรับ Admin'),
                                          duration: Duration(seconds: 1)),
                                    );

                                    await api_controller()
                                        .createUser(Username_input,
                                            Password_input, Email_input, true)
                                        // ignore: avoid_print
                                        .then(
                                            (value) => http_raw_state = value);

                                    http_status_ =
                                        jsonDecode(http_raw_state.body);
                                    String text_snackBar =
                                        http_status_['message'];
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(text_snackBar),
                                          duration: Duration(seconds: 1)),
                                    );
                                    http_raw_state.statusCode == 200
                                        ? Register_succeed = true
                                        : null;
                                    await Future.delayed(
                                        const Duration(seconds: 3));
                                  } catch (e) {
                                    print(e.toString());
                                    String text_snackBar =
                                        'ไม่สามารถดำเนินการได้ รหัสข้อผิดพลาด==>' +
                                            http_raw_state.statusCode
                                                .toString();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(text_snackBar)),
                                    );
                                  }
                                  /////
                                } else if (Password_input_confirm !=
                                        Password_input &&
                                    Register_menu_state == true) {
                                  String text_snackBar =
                                      'กรุณาใส่รหัสผ่านให้ตรงกัน' +
                                          http_raw_state.statusCode.toString();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(text_snackBar)),
                                  );
                                }
                                if (Register_menu_state == false ||
                                    Register_succeed == true) {
                                  try {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'กำลังเข้าสู่ระบบ...........'),
                                          duration: Duration(seconds: 1)),
                                    );

                                    await api_controller()
                                        .User_login(Username_input,
                                            Password_input, true)
                                        // ignore: avoid_print
                                        .then(
                                            (value) => http_raw_state = value);

                                    http_status_ =
                                        jsonDecode(http_raw_state.body);
                                    String text_snackBar =
                                        http_status_['token'];
                                    User_token = text_snackBar;
                                    Storage_data().Token_Saving(text_snackBar);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Token=>" + text_snackBar),
                                          duration: Duration(seconds: 1)),
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    Navigator.pushNamed(context, '/second');
                                  } catch (e) {
                                    print(e.toString());
                                    String text_snackBar =
                                        'ไม่สามารถเข้าสู่ระบบได้ กรุณาลองใหม่';

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(text_snackBar)),
                                    );
                                  }
                                  Register_succeed = false;
                                }
                              }
                            },
                            child: Text(Register_menu_state
                                ? 'สมัครสมาชิก Admin'
                                : 'เข้าสู่ระบบ Admin'),
                          ),
                        )
                      : Container(),
                  Register_menu_state
                      ? Container(
                          child: SizedBox(
                            width: 20,
                          ),
                        )
                      : Container(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool Register_succeed = false;
                        Map http_status_ = {};
                        var http_raw_state;
                        if (Password_input_confirm == Password_input &&
                            Register_menu_state == true) {
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('กำลังสมัครสมาชิกสำหรับ User'),
                                  duration: Duration(seconds: 1)),
                            );

                            await api_controller()
                                .createUser(Username_input, Password_input,
                                    Email_input, false)
                                // ignore: avoid_print
                                .then((value) => http_raw_state = value);

                            http_status_ = jsonDecode(http_raw_state.body);
                            String text_snackBar = http_status_['message'];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(text_snackBar),
                                  duration: Duration(seconds: 1)),
                            );
                            await Future.delayed(const Duration(seconds: 1));
                            http_raw_state.statusCode == 200
                                ? Register_succeed = true
                                : null;
                            await Future.delayed(const Duration(seconds: 3));
                          } catch (e) {
                            print(e.toString());
                            String text_snackBar =
                                'ไม่สามารถดำเนินการได้ รหัสข้อผิดพลาด==>' +
                                    http_raw_state.statusCode.toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(text_snackBar)),
                            );
                          }
                          /////
                        } else if (Password_input_confirm != Password_input &&
                            Register_menu_state == true) {
                          String text_snackBar = 'กรุณาใส่รหัสผ่านให้ตรงกัน' +
                              http_raw_state.statusCode.toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(text_snackBar)),
                          );
                        }
                        if (Register_menu_state == false ||
                            Register_succeed == true) {
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('กำลังเข้าสู่ระบบ...........'),
                                  duration: Duration(seconds: 1)),
                            );

                            await api_controller()
                                .User_login(
                                    Username_input, Password_input, false)
                                // ignore: avoid_print
                                .then((value) => http_raw_state = value);

                            http_status_ = jsonDecode(http_raw_state.body);
                            String text_snackBar = http_status_['token'];
                            User_token = text_snackBar;
                            Storage_data().Token_Saving(text_snackBar);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Token=>" + text_snackBar),
                                  duration: Duration(seconds: 1)),
                            );
                            await Future.delayed(const Duration(seconds: 1));
                            print(Storage_data().Token_Getting());
                            Navigator.pushNamed(context, '/second');

                            /*
.then((value) => setState(() => {
                              if (Dropdown_station_name != "ไม่พบสถานี")
                                {
                                  Serial_no =
                                      Map_Station[Dropdown_station_name],
                                  read_only_state_txt_field = true,
                                  Dropdown_select_station = true,
                                  Select_station(true, false),
                                  _time = null
                                }
                              else
                                {Select_station(false, false), _time = null},
                              valve_selection = "เลือกวาล์ว",
                              valve_no_str = "0",
                            }));
                                    */
                          } catch (e) {
                            print(e.toString());
                            String text_snackBar =
                                'ไม่สามารถเข้าสู่ระบบได้ กรุณาลองใหม่';

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(text_snackBar)),
                            );
                          }
                          Register_succeed = false;
                        }
                      }
                    },
                    child: Text(
                        Register_menu_state ? 'สมัครสมาชิก' : 'เข้าสู่ระบบ'),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          Register_menu_state = !Register_menu_state;
                        });
                      },
                      child: Text(Register_menu_state
                          ? 'ต้องการเข้าสู่ระบบ ?'
                          : 'ต้องการสมัครสมาชิก ?')),
                  /*
                  ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, '/second');
                        Storage_data().Token_Saving(
                            "sssssssssssssssssssssssssssssssssssssssss");
                      },
                      child: Text("Next page"))
                      */
                ],
              )),
        ],
      ),
    );
  }
}


























/*



import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิก'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
         
        ],
      )),
    );
  }
}
*/