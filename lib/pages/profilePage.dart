import 'dart:io';

import 'package:datingapp/pages/HomePage.dart';
import 'package:datingapp/pages/checkUser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  Map<String, dynamic>? userData;
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl; // Added to store the profile image URL

  TextEditingController _interestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchUserDetails();
    _loadProfileImageUrl(); // Load the profile image URL when initializing the page
  }

  @override
  void dispose() {
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> fetchUserDetails() async {
    String? email = user.email;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (snapshot.exists) {
      setState(() {
        userData = snapshot.data();
      });
    }
  }

  Future<void> _loadProfileImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageUrl = prefs.getString('profile_image_url');
    if (imageUrl != null) {
      setState(() {
        _profileImageUrl = imageUrl;
      });
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    String email = user.email!;
    String imageName =
        'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = FirebaseStorage.instance.ref().child('$email/$imageName');
    UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .update({'image1Url': url});

      // Save the profile image URL to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profile_image_url', url);

      // Update the state with the new profile image URL
      setState(() {
        _profileImageUrl = url;
      });

      // Call fetchUserDetails after the image is uploaded
      fetchUserDetails();
    });
  }

  Future<void> _getImageAndUpload() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadImage(File(pickedFile.path));
    }
  }

  Future<void> _showEditDialog(String fieldName, String description) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$description',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _interestsController,
                        maxLines: 5,
                        decoration: InputDecoration(),
                      ),
                    ],
                  ),
                ),
                Divider(height: 0),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Update user data based on fieldName
                        String? email = user.email;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(email)
                            .update({fieldName: _interestsController.text});

                        setState(() {
                          _interestsController.clear();
                        });

                        // Call fetchUserDetails after the data is updated
                        fetchUserDetails();

                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            if (userData != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${userData!['firstName']}',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 30),
              if (userData!['image1Url'] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: w * 0.8,
                          height: h * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userData!['image1Url']),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            onPressed: _getImageAndUpload,
                            icon: Icon(Icons.edit),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "In a few words...",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            userData!['interests'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : userData!['interests'],
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 0.9,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            _showEditDialog(
                                'interests', "Tell us about your interests")
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "About",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.userLarge,
                          color: Colors.black,
                          size: 17,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['firstName'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : userData!['firstName'],
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            _showEditDialog('firstName', 'Enter your name...')
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.scale,
                          size: 18,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['height'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : "${userData!['height']} ft",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              {_showEditDialog('height', "Enter your Height")},
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 18,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['dateOfBirth'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : "${userData!['dateOfBirth']}",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            _showEditDialog(
                                'dateOfBirth', "Enter your date of birth..")
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.phone,
                          color: Colors.black,
                          size: 17,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['phoneNumber'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : "${userData!['phoneNumber']}",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            _showEditDialog('phoneNumber', 'Enter phone number')
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.pray,
                          color: Colors.black,
                          size: 17,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['religion'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : "${userData!['religion']}",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            _showEditDialog('religion', 'Enter your religion')
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.smoking,
                          color: Colors.black,
                          size: 17,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['smoke'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : "${userData!['smoke']}",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              {_showEditDialog('smoke', 'Do you Smoke')},
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.family_restroom),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            userData!['status'] == null
                                ? "Tell us about your interests, hobbies or \nanything your future crush must have. "
                                : "${userData!['status']}",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              {_showEditDialog('status', 'Enter your status')},
                          icon: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: h * 0.06,
                        width: w * 0.8,
                        child: ElevatedButton(
                          onPressed: () => {
                            FirebaseAuth.instance.signOut().then(
                              (value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CheckUser()));
                              },
                            )
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: GoogleFonts.getFont('Poppins',
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ] else ...[
              Container(
                height: h,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
