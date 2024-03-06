import 'package:datingapp/pages/checkUser.dart';
import 'package:datingapp/pages/frontPage.dart';
import 'package:datingapp/pages/profilePage.dart';
import 'package:datingapp/pages/searchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FrontPage(),
    SearchPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: _pages[_selectedIndex],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => _onItemTapped(0),
                    icon: FaIcon(
                      FontAwesomeIcons.heart,
                      color: _selectedIndex == 0 ? Colors.pink : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onItemTapped(1),
                    icon: FaIcon(
                      FontAwesomeIcons.search,
                      color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onItemTapped(2),
                    icon: FaIcon(
                      FontAwesomeIcons.userLarge,
                      color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
