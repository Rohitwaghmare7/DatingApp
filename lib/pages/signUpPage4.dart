import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datingapp/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp4 extends StatefulWidget {
  final String firstName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String password;
  final String height;
  final String status;
  final String smoke;
  final String religion;
  final String address;
  final String postalCode;
  final String city;
  final String country;
  final String age;

  SignUp4(
      {required this.firstName,
      required this.email,
      required this.phoneNumber,
      required this.dateOfBirth,
      required this.gender,
      required this.image1,
      required this.image2,
      required this.image3,
      required this.image4,
      required this.password,
      required this.height,
      required this.status,
      required this.smoke,
      required this.religion,
      required this.address,
      required this.postalCode,
      required this.city,
      required this.country,
      required this.age});

  @override
  State<SignUp4> createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUp4> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String interests = "";
  bool _isLoading = false;

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: widget.email.trim(),
        password: widget.password.trim(),
      );
      print("user Created");

      await addUserDetails(
          widget.firstName.trim(),
          widget.email.trim(),
          widget.phoneNumber.trim(),
          widget.dateOfBirth.trim(),
          widget.gender.trim(),
          widget.height.trim(),
          widget.status.trim(),
          widget.smoke.trim(),
          widget.religion.trim(),
          widget.image1.trim(),
          widget.image2.trim(),
          widget.image3.trim(),
          widget.image4.trim(),
          widget.address.trim(),
          widget.city.trim(),
          widget.country.trim(),
          widget.postalCode.trim(),
          interests,
          widget.age.trim());
    } catch (e) {
      print("Error: $e");
      // Handle errors here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addUserDetails(
      String firstName,
      String email,
      String phoneNumber,
      String dateOfBirth,
      String gender,
      String height,
      String status,
      String smoke,
      String religion,
      String image1,
      String image2,
      String image3,
      String image4,
      String address,
      String city,
      String country,
      String postalCode,
      String interests,
      String age) async {
    await _firestore.collection('users').doc(email).set({
      "firstName": firstName,
      "email": email,
      "phoneNumber": phoneNumber,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "height": height,
      "status": status,
      "smoke": smoke,
      "religion": religion,
      "image1Url": image1,
      "image2Url": image2,
      "image3Url": image3,
      "image4Url": image4,
      "address": address,
      "city": city,
      "country": country,
      "postalCode": postalCode,
      "interests": interests,
      "age": age
    }).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: Text(
                      'Welcome',
                      style: GoogleFonts.getFont('Poppins',
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: w * 0.7,
                  height: h * 0.3,
                  child: Image.asset("assets/sittedCouple.png"),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => signUp(),
                    child: Container(
                      height: h * 0.06,
                      width: w * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Continue',
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
