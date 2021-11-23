import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'dart:async';

// ignore: non_constant_identifier_names
String conn_Id = "None";
bool state_conn = false;

class SignalRtest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter test Signal_R',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SignalR_Test'),
    );
  }
}

// ignore: camel_case_types
class SignalR_func {
  // ignore: non_constant_identifier_names
  Future<void> StartConnection() async {
    // ignore: unnecessary_new
    boothHub = new HubConnectionBuilder()
        //  .withUrl("https://serialapi-kq2.conveyor.cloud/cs3serialhub")
        .withUrl("https://localhost:44377/myHub")
        .build();

    try {
      await boothHub.start();
      print("boothHub.start() OK  01:");
      print(boothHub.connectionId);
      state_conn = true;
    } catch (e) {
      state_conn = false;
    }

    /*
    boothHub.on('', (message) async {
      print(message.toString());
      print("ReplyFromServer OK 03:");
    });
    */
  }

  //////////////////////////////////////////////
  // ignore: non_constant_identifier_names
  Future<void> update_state_control(int stateJoystick) async {
    try {
      await boothHub.invoke("JoyStick", args: <int>[stateJoystick]);
      print("JoyStick control OK 02:==>" + stateJoystick.toString());
      //await boothHub.stop();
    } catch (error) {
      /*
      print('ไม่สำเร็จล่ะ เพราะ $error');
      print("Starting......");
      StartConnection();
      */
    }
  }

  Future<void> invoke_data_(String header, String Json_data) async {
    try {
      await boothHub.invoke(header, args: <String>[Json_data]);
      print("header=>" + header + "OK!");
      //await boothHub.stop();
    } catch (error) {
      print(error);
      /*
      print('ไม่สำเร็จล่ะ เพราะ $error');
      print("Starting......");
      StartConnection();
      */
    }
  }
}

class My_SignalR_func extends SignalR_func {}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SignalRtestState createState() => _SignalRtestState();
}

var boothHub;

class _SignalRtestState extends State<MyHomePage> {
  void initState() {
    super.initState();
    print("Starting......");
    My_SignalR_func().StartConnection();
  }

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  // SendData();
                },
                child: Text("Get_connection_ID")),
            Text(
              conn_Id,
              style: (TextStyle(fontSize: 20, color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
