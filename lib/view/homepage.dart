import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('Home Screen'),
        ],
      )),
    );
  }
}
