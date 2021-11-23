//@dart=2.9
import 'package:flutter/material.dart';

import 'communication/signal_r.dart';
import 'view/player.dart';
import 'view/link_page.dart';
import 'view/profile.dart';
//import 'package:localstorage/localstorage.dart';
//import 'view/player.dart';

void main() {
  runApp(MyApp());
}

/*
void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
        '/second': (context) => Launcher(),
        '/profile': (context) => const profile(),
      },
    ),
  );
}
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Launcher(),
      },
    );
  }
}


/*
Map Map_storage = {};
String data_ = "";
int increment = 0;
void main() {
  runApp(
    const MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(),
    ),
  );
}
*/
/*

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  final LocalStorage storage = LocalStorage('Storage_data');

  @override
  void initState() {
    super.initState();
    initdata();
  }

  Future<void> initdata() async {
    await Future.delayed(const Duration(seconds: 2));
    Map ReadRawMap = storage.getItem('data');
    data_ = ReadRawMap['Token'];
    print(data_);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('storage'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              setState(() {
                increment++;
                Map_storage['Token'] = increment.toString();
                print(Map_storage['Token']);
                storage.setItem('data', Map_storage);
                Map Read_raw_map = storage.getItem('data');
                print(Read_raw_map);
                data_ = Read_raw_map['Token'];
                increment = int.parse(data_);
              });
            },
            child: Text("เพิ่มข้อมูล"),
          ),
          Text(data_),
        ],
      )),
    );
  }
}
*/
