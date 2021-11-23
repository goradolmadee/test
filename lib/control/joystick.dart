import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:control_pad/control_pad.dart';

class JoyStickApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joystick',
      home: joystick_(),
    );
  }
}

var message_narrow = "None";
int distance_percent = 0;
double degree_convert = 0;
int id_narrow_joystick = 0;

//String raw = "";

class joystick_ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          JoystickView(
            size: 200,
            onDirectionChanged: (double degrees, double distanceFromCenter) {
              distance_percent = (distanceFromCenter * 200).toInt();
              degree_convert = degrees;
              // Calcu_Joystick_data(distance_percent, degree_convert);
              // print("ทิศทาง=>" + distance_percent.toString());
              //  print("องศา=>" + degree_convert.toString());
            },
          ),
          //Text(message_narrow)
          TextDisplay(),
        ],
      )),
    );
  }
}

class TextDisplay extends StatefulWidget {
  @override
  _TextDisplayState createState() => _TextDisplayState();
}

class _TextDisplayState extends State<TextDisplay> {
  @override
  void initState() {
    Timer.periodic(Duration(microseconds: 50), (Timer timer) {
      Calcu_Joystick_data(distance_percent, degree_convert);
      //print(message_narrow);
      /*
     raw = "ความห่าง =>" +
         distance_percent.toString() +
         ",เข็มทิศ =>" +
         degree_convert.toString() +
         "ทิศ====>" +
         message_narrow;
         */
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          message_narrow,
          style: TextStyle(fontSize: 20),
        )
        //Text(message_narrow)
      ],
    );
  }

  void Calcu_Joystick_data(int Distance_per, double Degree_val) {
    setState(() {
      Distance_per >= 50
          ? Degree_val >= 0 && Degree_val <= 22.49 ||
                  Degree_val > 337.5 && Degree_val <= 359.9
              ? Narrow_id(7)
              : Degree_val >= 22.5 && Degree_val <= 67.4
                  ? Narrow_id(8)
                  : Degree_val >= 67.5 && Degree_val <= 112.4
                      ? Narrow_id(1)
                      : Degree_val >= 112.5 && Degree_val <= 157.4
                          ? Narrow_id(2)
                          : Degree_val >= 157.5 && Degree_val <= 202.4
                              ? Narrow_id(3)
                              : Degree_val >= 202.5 && Degree_val <= 247.4
                                  ? Narrow_id(4)
                                  : Degree_val >= 247.5 && Degree_val <= 292.4
                                      ? Narrow_id(5)
                                      : Degree_val >= 292.5 &&
                                              Degree_val <= 337.4
                                          ? Narrow_id(6)
                                          : null
          : Narrow_id(0);
    });
  }

  void Narrow_id(int num) {
    id_narrow_joystick = num;
    switch (num) {
      case 0:
        message_narrow = "None";
        break;
      case 1:
        message_narrow = "Right";
        break;
      case 2:
        message_narrow = "RightBack";
        break;
      case 3:
        message_narrow = "Back";
        break;
      case 4:
        message_narrow = "LeftBack";
        break;
      case 5:
        message_narrow = "Left";
        break;
      case 6:
        message_narrow = "LeftFront";
        break;
      case 7:
        message_narrow = "Front";
        break;
      case 8:
        message_narrow = "RightFront";
        break;
      default:
    }
  }
}
