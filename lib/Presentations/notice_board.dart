import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notices_app/Presentations/all_notices.dart';
import 'package:notices_app/Widgets/app_drawer.dart';
import 'package:notices_app/Widgets/category_section.dart';
import 'package:notices_app/Widgets/notices_card.dart';
import 'package:notices_app/services/firebase_services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({Key? key}) : super(key: key);

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const DefaultTextStyle(
          style: TextStyle(color: Colors.white, fontSize: 20),
          child: Text('KU-Noticeboard'),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            child:
                Image.asset('assets/images/KU-logo.png', width: 50, height: 50),
            onTap: () {
              const kuUrl = 'https://ku.edu.np/';
              _launchURL(kuUrl);
            },
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/image.png', // replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Blurred overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchController.text = query.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent News and Notices',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(228, 0, 0, 0))),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllRecentNoticesScreen(recentNotices: []),
                            ),
                          );
                        },
                        child: const Text('See All',
                            style: TextStyle(color: Colors.indigo)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<List<QueryDocumentSnapshot>>(
                    stream: _firebaseService.getNoticesStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        List<QueryDocumentSnapshot> notices = snapshot.data!;

                        // Filter out documents without 'created_at'
                        notices = notices.where((doc) {
                          final data = doc.data() as Map<String, dynamic>?;
                          return data != null && data.containsKey('created_at');
                        }).toList();

                        // Sort notices by 'created_at' in descending order
                        notices.sort((a, b) {
                          Timestamp? aTimestamp = a['created_at'] as Timestamp?;
                          Timestamp? bTimestamp = b['created_at'] as Timestamp?;
                          return bTimestamp
                                  ?.compareTo(aTimestamp ?? Timestamp(0, 0)) ??
                              0;
                        });

                        // Split notices into carousel and below tag notices
                        List<QueryDocumentSnapshot> carouselNotices = [];
                        List<QueryDocumentSnapshot> belowTagNotices = [];
                        for (var i = 0; i < notices.length; i++) {
                          if (i < 7) {
                            carouselNotices.add(notices[i]);
                          } else {
                            belowTagNotices.add(notices[i]);
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (carouselNotices.isNotEmpty)
                              CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 1.3,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.9,
                                ),
                                items: carouselNotices.map((document) {
                                  var notice =
                                      document.data() as Map<String, dynamic>;
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return NoticeCard(
                                        title: notice['title'] ?? '',
                                        subtitle: notice['content'] ?? '',
                                        imageUrl: notice['image'] ?? '',
                                        author: 'Admin',
                                        elevation: 5,
                                        noticesUrl: notice['noticesUrl'] ?? '',
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 20),
                            const Text('Departmental',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            CategorySection(),
                            const SizedBox(height: 10),
                            if (belowTagNotices.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: belowTagNotices.map((document) {
                                  var notice =
                                      document.data() as Map<String, dynamic>;
                                  return NoticeCard(
                                    title: notice['title'] ?? '',
                                    subtitle: notice['content'] ?? '',
                                    imageUrl: notice['image'] ?? '',
                                    author: 'Admin',
                                    elevation: 5,
                                    noticesUrl: notice['noticesUrl'] ?? '',
                                  );
                                }).toList(),
                              ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        print('Firebase error: ${snapshot.error}');
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
