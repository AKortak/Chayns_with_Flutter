import 'package:flutter/material.dart';

class ChaynsBottomNavigationBar extends StatefulWidget {
  ChaynsBottomNavigationBar({Key key, this.returnToScaff}) : super(key: key);
  Function(bool) returnToScaff;

  @override
  _ChaynsBottomNavigationBarState createState() => _ChaynsBottomNavigationBarState(returnToScaff: returnToScaff);
}

class _ChaynsBottomNavigationBarState extends State<ChaynsBottomNavigationBar> {
  int _selectedIndex = 0;
  Function(bool) returnToScaff;
  _ChaynsBottomNavigationBarState({this.returnToScaff});

  void _onItemTapped(int index) {
    setState(() {
      returnToScaff(true);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //Damit sich die BottomNavigationBarItems nicht bewegen, wenn man sie anklickt.
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(255, 40, 40, 40),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          title: Text('Sites'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Nachrichten'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.euro_symbol),
          title: Text('Geld'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card),
          title: Text('Wallet'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          title: Text('Mehr'),
        ),
      ],
      unselectedIconTheme: IconThemeData(
        color: Colors.white30,
        size: 30,
      ),
      selectedIconTheme: IconThemeData(
        color: Colors.white,
        size: 30,
      ),
      currentIndex: _selectedIndex,
      unselectedFontSize: 13.0,
      unselectedItemColor: Colors.white30,
      selectedItemColor: Colors.white,
      selectedFontSize: 13.0,
      onTap: _onItemTapped,
    );
  }
}
