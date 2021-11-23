import 'package:flutter/material.dart';
import '/communication/signal_r.dart';
import '/control/joystick.dart';
import '/communication/video_streaming.dart';
import 'dart:async';
import 'package:control_pad/control_pad.dart';

const int delay_send_data_joystick = 50; //1000ms(50std).
String Signal_r_online_state = "Connecting....";
bool State_joystick_changed = false;
int previous_value_joystick = 0;
bool first_time_update = false;
bool first_update_zero_joystick = false;

class player_page extends StatelessWidget {
  const player_page({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const My_player_page(title: 'Flutter Demo Home Page'),
    );
  }
}

class My_player_page extends StatefulWidget {
  const My_player_page({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<My_player_page> createState() => _My_player_page_State();
}

class _My_player_page_State extends State<My_player_page> {
  @override
  void initState() {
    My_SignalR_func().StartConnection();
    print(state_conn);

    Timer.periodic(Duration(milliseconds: delay_send_data_joystick),
        (Timer timer) {
      // print(id_narrow_joystick);
      // update_state_joystick(id_narrow_joystick);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              // margin: const EdgeInsets.all(15.0),
              //  padding: const EdgeInsets.all(100.0),
              //height: MediaQuery.of(context).size.width,
              //  width: MediaQuery.of(context).size.width,

              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Camera_screen(),
            ),
          ),
          Container(
              //height: 50,
              //padding: EdgeInsets.all(10.0),

              color: Colors.tealAccent[100],
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration:
                    //BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    const BoxDecoration(
                        image: DecorationImage(
                  alignment: Alignment.center,
                  matchTextDirection: true,
                  repeat: ImageRepeat.noRepeat,
                  image: AssetImage("assets/images/ufokatcher01_pic.jpg"),
                )),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //padding: const EdgeInsets.fromLTRB(50, 0, 0, 50),
                  children: <Widget>[
                    JoystickView(
                      size: 150,
                      onDirectionChanged:
                          (double degrees, double distanceFromCenter) {
                        distance_percent = (distanceFromCenter * 200).toInt();
                        degree_convert = degrees;
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // ignore: deprecated_member_use
                        OutlineButton(
                          borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                              style: BorderStyle.solid),
                          onPressed: () {},
                          child: const Text(
                            "จับเวลา",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ignore: deprecated_member_use
                        OutlineButton(
                          borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                              style: BorderStyle.solid),
                          onPressed: () {},
                          child: const Text(
                            "คีบ",
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                "วนซ้าย",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                "วนขวา",
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      )

/*

          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: JoyStickApp(),),           
            Expanded(
                child: Text(
              Signal_r_online_state,
              style: TextStyle(
                  fontSize: 30,
                  color: state_conn ? Colors.greenAccent : Colors.red),
            )),
           
            Expanded(
              child: Camera_screen(),
            )
          ],
        ),
      )
      
      
      */

          ),
    );
  }

  void update_state_joystick(int value_joystick) {
    if (first_time_update == false) {
      setState(() {
        if (state_conn == true) {
          Signal_r_online_state = "Online";
        } else {
          //  Signal_r_online_state = "Offline";
        }
      });
    }
    if (state_conn) {
      first_time_update = true;
      if (previous_value_joystick != value_joystick) {
        State_joystick_changed = false;
        previous_value_joystick = value_joystick;
      } else {
        State_joystick_changed = true;
      }

      if (State_joystick_changed == true) {
        value_joystick != 0
            ? My_SignalR_func().update_state_control(value_joystick)
            : null;
        first_update_zero_joystick = false;
      } else {
        if (first_update_zero_joystick == false) {
          first_update_zero_joystick = true;
          My_SignalR_func().update_state_control(0);
        }
      }
    }
  }
}
