import 'package:datingapp/pages/signUpPage2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  // const SignUp({Key key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  int? _age;

  bool _isButtonEnabled() {
    return _firstNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedGender != null &&
        _age != null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yy').format(_selectedDate!);

        // Calculate age
        _age = _calculateAge(picked);
      });
    }
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);
    return (difference.inDays / 365).floor();
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              const FaIcon(
                FontAwesomeIcons.userLarge,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Introduce\nyourself',
                style: GoogleFonts.getFont(
                  'Poppins',
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  height:
                      0.9, // Adjust this value to reduce space between lines
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _firstNameController,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "First name",
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
                      controller: _emailController,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
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
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "Phone number",
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
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _dateController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            hintText: "DD/MM/YY",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
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
              _age != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age: $_age',
                            style: GoogleFonts.getFont('Poppins',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            width: double.infinity,
                            height: 4.0,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 50,
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: h * 0.06,
                    width: w * 0.4,
                    child: Opacity(
                      opacity: _selectedGender == 'Male'
                          ? 1.0
                          : 0.5, // Fade out if not selected
                      child: ElevatedButton(
                        onPressed: () {
                          _selectGender('Male');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (_selectedGender == 'Male') {
                              return Colors.blue.withOpacity(
                                  0.8); // Darken the color if selected
                            }
                            return Colors.blue;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Male',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const FaIcon(
                              FontAwesomeIcons.mars,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.06,
                    width: w * 0.4,
                    child: Opacity(
                      opacity: _selectedGender == 'Female'
                          ? 1.0
                          : 0.5, // Fade out if not selected
                      child: ElevatedButton(
                        onPressed: () {
                          _selectGender('Female');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (_selectedGender == 'Female') {
                              return Colors.pinkAccent.withOpacity(
                                  0.8); // Darken the color if selected
                            }
                            return Colors.pinkAccent;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Female',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const FaIcon(
                              FontAwesomeIcons.venus,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isButtonEnabled()
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Navigate to the next page and pass the text field value and selected gender
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp2(
                      firstName: _firstNameController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneNumberController.text,
                      dateOfBirth: _dateController.text,
                      gender: _selectedGender!,
                      age:_age.toString()
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
