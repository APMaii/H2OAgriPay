
import 'package:flutter/material.dart';

import 'turnover_page.dart';
import 'payment_page.dart';
import 'setting_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const TurnoverPage(),
    const PaymentPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), // Finance Icon
            label: 'Turnover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment), // Payment Icon
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Settings Icon
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}


