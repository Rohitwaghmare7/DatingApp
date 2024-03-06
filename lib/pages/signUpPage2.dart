import 'dart:io';
import 'package:datingapp/pages/signUpPage3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp2 extends StatefulWidget {
  final String firstName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String age;

  SignUp2({
    required this.firstName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.age,
  });

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;
  final ImagePicker _picker = ImagePicker();

  bool isFloatingButtonVisible() {
    int selectedCount = 0;
    if (_image1 != null) selectedCount++;
    if (_image2 != null) selectedCount++;
    if (_image3 != null) selectedCount++;
    if (_image4 != null) selectedCount++;
    return selectedCount >= 4;
  }

  bool _uploading = false;

  String? _image1Url;
  String? _image2Url;
  String? _image3Url;
  String? _image4Url;

  Future<String> uploadImageToStorage(File imageFile) async {
    String email = widget.email;
    String imageName = 'image${DateTime.now().millisecondsSinceEpoch}.png';
    Reference ref =
        FirebaseStorage.instance.ref().child('$email/image/${imageName}');
    UploadTask uploadTask =
        ref.putFile(imageFile, SettableMetadata(contentType: 'image/png'));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    print("this is download URL: " + downloadURL);
    return downloadURL;
  }

  Future<void> uploadImages() async {
    try {
      setState(() {
        _uploading = true;
      });

      if (_image1 != null) {
        _image1Url = await uploadImageToStorage(_image1!);
      }

      if (_image2 != null) {
        _image2Url = await uploadImageToStorage(_image2!);
      }

      if (_image3 != null) {
        _image3Url = await uploadImageToStorage(_image3!);
      }

      if (_image4 != null) {
        _image4Url = await uploadImageToStorage(_image4!);
      }
    } catch (e) {
      print("Error uploading images: $e");
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> getImage(int boxNumber) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        switch (boxNumber) {
          case 1:
            _image1 = File(pickedFile.path);
            break;
          case 2:
            _image2 = File(pickedFile.path);
            break;
          case 3:
            _image3 = File(pickedFile.path);
            break;
          case 4:
            _image4 = File(pickedFile.path);
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: const FaIcon(
                    FontAwesomeIcons.userLarge,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    '''it's really all in the\npresentation, right?''',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      height: 0.9,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => getImage(1),
                          child: Container(
                            height: h * 0.2,
                            width: w * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: _image1 != null
                                  ? DecorationImage(
                                      image: FileImage(_image1!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image1 == null
                                ? const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => getImage(2),
                          child: Container(
                            height: h * 0.2,
                            width: w * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: _image2 != null
                                  ? DecorationImage(
                                      image: FileImage(_image2!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image2 == null
                                ? const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => getImage(3),
                          child: Container(
                            height: h * 0.2,
                            width: w * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: _image3 != null
                                  ? DecorationImage(
                                      image: FileImage(_image3!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image3 == null
                                ? const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => getImage(4),
                          child: Container(
                            height: h * 0.2,
                            width: w * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: _image4 != null
                                  ? DecorationImage(
                                      image: FileImage(_image4!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image4 == null
                                ? const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 40,
                                  )
                                : null,
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
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "upload at least 2 photos",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 0.9,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "Avoid blurry images",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 0.9,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_uploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: isFloatingButtonVisible()
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                uploadImages().then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp3(
                        firstName: widget.firstName,
                        email: widget.email,
                        phoneNumber: widget.phoneNumber,
                        dateOfBirth: widget.dateOfBirth,
                        gender: widget.gender,
                        image1: _image1Url!,
                        image2: _image2Url!,
                        image3: _image3Url!,
                        image4: _image4Url!,
                        age: widget.age,
                      ),
                    ),
                  );
                });
              },
              child: const FaIcon(
                FontAwesomeIcons.angleRight,
                color: Colors.black,
              ),
            )
          : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
