import 'dart:io';
import 'package:datingapp/pages/HomePage.dart';
import 'package:datingapp/pages/locationPage.dart';
import 'package:datingapp/pages/signUpPage4.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp3 extends StatefulWidget {
  final String firstName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String age;

  SignUp3(
      {required this.firstName,
      required this.email,
      required this.phoneNumber,
      required this.dateOfBirth,
      required this.gender,
      required this.image1,
      required this.image2,
      required this.image3,
      required this.image4,
      required this.age});

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _somkeController = TextEditingController();
  TextEditingController _religionController = TextEditingController();

  bool isButtonVisible() {
    return _passwordController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _statusController.text.isNotEmpty &&
        _somkeController.text.isNotEmpty &&
        _religionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: const FaIcon(
                FontAwesomeIcons.userLarge,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                'Some More\nInformation',
                style: GoogleFonts.getFont(
                  'Poppins',
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  height:
                      0.9, // Adjust this value to reduce space between lines
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Column(
                children: [
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.digitsOnly
                    // ],
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Height ft.",
                      hintStyle: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Column(
                children: [
                  TextField(
                    controller: _statusController,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Your Status",
                      hintStyle: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Column(
                children: [
                  TextField(
                    controller: _somkeController,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Do you smoke?",
                      hintStyle: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Column(
                children: [
                  TextField(
                    controller: _religionController,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Your religion?",
                      hintStyle: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: isButtonVisible()
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Navigate to the next page and pass the text field value and selected gender
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationPage(
                      firstName: widget.firstName,
                      email: widget.email,
                      phoneNumber: widget.phoneNumber,
                      dateOfBirth: widget.dateOfBirth,
                      gender: widget.gender,
                      image1: widget.image1,
                      image2: widget.image2,
                      image3: widget.image3,
                      image4: widget.image4,
                      password: _passwordController.text,
                      height: _heightController.text,
                      status: _statusController.text,
                      smoke: _somkeController.text,
                      religion: _religionController.text,
                      age: widget.age,
                    ),
                  ),
                );
              },
              child: FaIcon(
                FontAwesomeIcons.angleRight,
                color: Colors.black,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
