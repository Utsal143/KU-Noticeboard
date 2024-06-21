import 'package:flutter/material.dart';
import 'package:notices_app/Presentations/post_notice.dart';
import 'package:notices_app/Widgets/Categories/HighlightsScreen.dart';
import 'package:notices_app/Widgets/Categories/KUBulletinScreen.dart';
import 'package:notices_app/Widgets/Categories/TenderProcurementScreen.dart';
import 'package:notices_app/Widgets/Categories/UniversityEvents.dart';
import 'package:notices_app/Widgets/Categories/UniversityNewsScreen.dart';
import 'package:notices_app/Widgets/Categories/UniversityNoticesScreen.dart';
import 'package:notices_app/Widgets/Categories/VacancyCareerScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/download.jpg'),
                    fit: BoxFit.cover),
              )),
          ListTile(
            title: Text('Notices'),
            onTap: () {
              _showAdminAuthDialog(context);
            },
          ),
          ExpansionTile(
            title: Text('Categories'),
            children: <Widget>[
              ListTile(
                title: Text('University News'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Universitynewsscreen()));
                },
              ),
              ListTile(
                title: Text('University Notices'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Universitynoticesscreen()));
                },
              ),
              ListTile(
                title: Text('Highlights for Students'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Highlightsscreen()));
                },
              ),
              ListTile(
                title: Text('University Events'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Universityeventsscreen()));
                },
              ),
              ListTile(
                title: Text('Vacancy and Career'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VaccancyCareerScreen()));
                },
              ),
              ListTile(
                title: Text('Tender and Procurement'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Tenderprocurementscreen()));
                },
              ),
              ListTile(
                title: Text('KU Bulletin'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Kubulletinscreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAdminAuthDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Authentication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Login'),
              onPressed: () {
                if (emailController.text == 'admin@gmail.com' &&
                    passwordController.text == 'admin') {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostNotices(),
                    ),
                  );
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid email or password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
