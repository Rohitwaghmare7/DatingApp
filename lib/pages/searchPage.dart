import 'package:datingapp/pages/userProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const SearchBar({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    if (onChanged != null) onChanged!("");
                  },
                  child: Icon(Icons.clear,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                )
              : null,
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                controller: _searchController,
                onChanged: (value) {
                  _search(value);
                },
              ),
              SizedBox(height: 10),
              if (_searchController.text.isEmpty && _recentSearches.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Recent',
                        style: GoogleFonts.getFont('Ubuntu',
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _recentSearches.map((search) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () {
                              _searchController.text =
                                  search; // Set searched text to search bar
                              _search(search); // Perform search
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: w * 0.9,
                                  height: h * 0.07, // Adjusted width here
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 233, 228, 229),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            search,
                                            style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.clear),
                                          color: Colors.black,
                                          onPressed: () {
                                            setState(() {
                                              _recentSearches.remove(search);
                                              _saveRecentSearches();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['image1Url'] ?? ''),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(user['firstName'] ?? ''),
                ),
                subtitle: Text(user['interests'] is List
                    ? user['interests'].join(', ')
                    : user['interests']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(user: user),
                    ),
                  );
                  // Add the search query to recent searches
                  setState(() {
                    String search = _searchController.text;
                    if (!_recentSearches.contains(search)) {
                      _recentSearches.add(search);
                      _saveRecentSearches();
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _search(String value) async {
    Future.delayed(Duration(milliseconds: 500), () async {
      if (value.isNotEmpty) {
        final snapshot =
            await FirebaseFirestore.instance.collection('users').get();
        setState(() {
          _users = snapshot.docs
              .map((doc) => doc.data())
              .where((user) =>
                  (user['firstName'] != null &&
                      user['firstName']
                          .toLowerCase()
                          .contains(value.toLowerCase())) ||
                  (user['interests'] != null &&
                      user['interests']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase())))
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _users.clear();
        });
      }
    });
  }
}
