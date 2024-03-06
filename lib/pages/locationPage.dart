import 'dart:async';
import 'package:datingapp/pages/signUpPage4.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPage extends StatefulWidget {
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
  final String age;

  LocationPage({
    required this.firstName,
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
    required this.age
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  String? city;
  String? country;
  String? postalCode;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.locality}, ${place.country}';
        city = ' ${place.locality}';
        country = '${place.country}';
        postalCode = '${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.location,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Location',
                style: GoogleFonts.getFont(
                  'Poppins',
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              height: h * 0.06,
              width: w * 0.7,
              child: ElevatedButton(
                onPressed: _getCurrentPosition,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: Text(
                  'Get Location',
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w * 0.8,
                child: Text(
                  _currentAddress != null ? 'Address: $_currentAddress' : "",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: Positioned(
        bottom: 16,
        right: 16,
        child: _currentAddress != null
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp4(
                        firstName: widget.firstName,
                        email: widget.email,
                        phoneNumber: widget.phoneNumber,
                        dateOfBirth: widget.dateOfBirth,
                        gender: widget.gender,
                        image1: widget.image1,
                        image2: widget.image2,
                        image3: widget.image3,
                        image4: widget.image4,
                        password: widget.password,
                        height: widget.height,
                        status: widget.status,
                        smoke: widget.smoke,
                        religion: widget.religion,
                        address: _currentAddress!,
                        postalCode: postalCode!,
                        country: country!,
                        city: city!,
                        age:widget.age
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_forward, color: Colors.black),
              )
            : Text(""),
      ),
    );
  }
}
