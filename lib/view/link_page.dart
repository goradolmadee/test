// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ufokatcher_app/view/profile.dart';
import 'homepage.dart';
import 'register.dart';

class Launcher extends StatefulWidget {
  @override
// ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

//class _LauncherState extends State<Launcher> {
class _LauncherState extends State<Launcher> {
  // const FirstScreen({Key? key}) : super(key: key);
  int _currentIndex = 4;
  final List<Widget> _pageWidget = <Widget>[
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    Register(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //    title: const Text('First Screen'),
      //  ),
      body: _pageWidget.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.4),
        selectedFontSize: 14,
        unselectedFontSize: 11,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          const BottomNavigationBarItem(
            title: Text('หน้าหลัก'),
            icon: Icon(FontAwesomeIcons.home),
          ),
          const BottomNavigationBarItem(
            title: Text('อันดับ'),
            icon: Icon(FontAwesomeIcons.chartArea),
          ),
          const BottomNavigationBarItem(
            title: Text('แจ้งเตือน'),
            icon: Icon(FontAwesomeIcons.bell),
          ),
          const BottomNavigationBarItem(
            title: Text('ตะกร้า'),
            icon: Icon(FontAwesomeIcons.shoppingCart),
          ),
          const BottomNavigationBarItem(
            title: Text('ระบบสมาชิก'),
            tooltip: "สมัครสมาชิกเลย!!!",
            icon: Icon(
              FontAwesomeIcons.userAlt,
              //color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    );
  }
}


/*
class _LauncherState extends State<Launcher> {
  int _currentIndex = 4;
  final List<Widget> _pageWidget = <Widget>[
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    Register(),
    profile(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.4),
        selectedFontSize: 14,
        unselectedFontSize: 11,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          const BottomNavigationBarItem(
            title: Text('หน้าหลัก'),
            icon: Icon(FontAwesomeIcons.home),
          ),
          const BottomNavigationBarItem(
            title: Text('อันดับ'),
            icon: Icon(FontAwesomeIcons.chartArea),
          ),
          const BottomNavigationBarItem(
            title: Text('แจ้งเตือน'),
            icon: Icon(FontAwesomeIcons.bell),
          ),
          const BottomNavigationBarItem(
            title: Text('ตะกร้า'),
            icon: Icon(FontAwesomeIcons.shoppingCart),
          ),
          const BottomNavigationBarItem(
            title: Text('ระบบสมาชิก'),
            tooltip: "สมัครสมาชิกเลย!!!",
            icon: Icon(
              FontAwesomeIcons.userAlt,
              //color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    );
  }
}

*/
