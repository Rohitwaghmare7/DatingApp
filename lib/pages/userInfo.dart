import 'package:datingapp/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:datingapp/pages/UserProfilePage.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<List<Map<String, dynamic>>> _likedUsersFuture;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _likedUsersFuture = _fetchLikedUsers();
  }

  Future<List<Map<String, dynamic>>> _fetchLikedUsers() async {
    try {
      final List<Map<String, dynamic>> users = [];

      QuerySnapshot likesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email!)
          .collection('likes')
          .get();

      List<String> likedUserIds =
          likesSnapshot.docs.map((doc) => doc.id).toList();

      for (String likedUserId in likedUserIds) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(likedUserId)
            .get();

        if (userSnapshot.exists) {
          users.add(userSnapshot.data() as Map<String, dynamic>);
        }
      }

      return users;
    } catch (error) {
      print('Error fetching liked users: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(18, 15, 0, 0),
          child: GestureDetector(
            onTap: () {
               Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()));
            },
            child: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "your Likes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _likedUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final likedUsers = snapshot.data ?? [];
            return likedUsers.isEmpty
                ? Center(child: Text('No liked users found.'))
                : ListView.builder(
                    itemCount: likedUsers.length,
                    itemBuilder: (context, index) {
                      var likedUser = likedUsers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserProfilePage(user: likedUser),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(likedUser['firstName']),
                          subtitle: Text(likedUser['email']),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    NetworkImage(likedUser['image1Url'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.solidHeart,
                              color: Color.fromARGB(255, 255, 109, 158),
                            ),
                            onPressed: () async {
                              try {
                                // Get the liked user's document ID
                                String likedUserId = likedUser['email'];

                                // Delete the liked user from the likes collection
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.email!)
                                    .collection('likes')
                                    .doc(likedUserId)
                                    .delete();

                                // Refresh the UI to reflect the changes
                                setState(() {
                                  likedUsers.removeAt(index);
                                });
                              } catch (error) {
                                print('Error deleting user from likes: $error');
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
