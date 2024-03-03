import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 70, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.userLarge,
                      color: Colors.white,
                    ),
                    Text(
                      'Login',
                      style: GoogleFonts.getFont('Poppins',
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.solidEnvelope,
                                color: Colors.white,
                              ),
                              SizedBox(
                                  width:
                                      8.0), // Adjust spacing between icon and text field
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: _emailController,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,

                                    isDense:
                                        true, // Reduce height of input field
                                    contentPadding: EdgeInsets
                                        .zero, // Remove internal padding
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width:
                                double.infinity, // To stretch across the screen
                            height: 4.0,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0), // Adjust spacing as needed
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Login'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
