import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datingapp/pages/userInfo.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserInfoPage()));
                },
                child: Text(
                  "your Likes",
                  style: GoogleFonts.getFont('Ubuntu',
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: Color.fromARGB(255, 255, 68, 130),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(user.email).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final userAddress = snapshot.data!['city'];
                      final userGender = snapshot.data!['gender'];
                      final oppositeGender =
                          userGender == 'Male' ? 'Female' : 'Male';
                      return StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('users')
                            .where('city', isEqualTo: userAddress)
                            .where('gender', isEqualTo: oppositeGender)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Text('No users found');
                          } else {
                            final users = snapshot.data!.docs
                                .where((doc) => doc['email'] != user.email)
                                .toList();
                            if (users.isEmpty) {
                              return Text('No users found');
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: Column(
                                  children: users.map((oppositeUser) {
                                    return Container(
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 22),
                                                  child: Text(
                                                    "${oppositeUser['firstName']},",
                                                    style: GoogleFonts.getFont(
                                                        'Inter',
                                                        color: Colors.black,
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 0),
                                                  child: Text(
                                                    oppositeUser['age'],
                                                    style: GoogleFonts.getFont(
                                                        'Poppins',
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            oppositeUser['interests'] != null
                                                ? Container(
                                                    width: w * 0.8,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Text(
                                                        oppositeUser[
                                                            'interests'],
                                                        style:
                                                            GoogleFonts.getFont(
                                                                'Poppins',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  )
                                                : Text(""),
                                            SizedBox(height: 10),
                                            Container(
                                              width: w * 0.8,
                                              height: h * 0.45,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      oppositeUser[
                                                              'image1Url'] ??
                                                          ''),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 12, 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 233, 228, 229),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          19, 8, 12, 8),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons
                                                              .location_on),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            oppositeUser[
                                                                'city'],
                                                            style: GoogleFonts
                                                                .getFont(
                                                                    'Poppins',
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 15, 0),
                                                    child: HeartIcon(
                                                      userRef: _firestore
                                                          .collection('users')
                                                          .doc(user.email),
                                                      oppositeUserRef:
                                                          oppositeUser
                                                              .reference,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10)
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HeartIcon extends StatefulWidget {
  final DocumentReference userRef;
  final DocumentReference oppositeUserRef;

  HeartIcon({required this.userRef, required this.oppositeUserRef});

  @override
  _HeartIconState createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon> {
  bool _isLiked = false;
  late String likeDocId;

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  Future<void> _loadLikedStatus() async {
    DocumentSnapshot docSnapshot = await widget.userRef
        .collection('likes')
        .doc(widget.oppositeUserRef.id)
        .get();

    if (mounted) {
      setState(() {
        _isLiked = docSnapshot.exists;
        likeDocId = docSnapshot.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
        color: _isLiked ? Colors.pink : null,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
        });
        if (_isLiked) {
          widget.userRef
              .collection('likes')
              .doc(widget.oppositeUserRef.id)
              .set({
            'userRef': widget.oppositeUserRef,
            'timestamp': DateTime.now(),
          }).then((value) {
            setState(() {
              likeDocId = widget.oppositeUserRef.id;
            });
          });
        } else {
          widget.userRef.collection('likes').doc(likeDocId).delete();
        }
      },
    );
  }
}
