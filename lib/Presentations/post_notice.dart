import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notices_app/services/firebase_services.dart';

class PostNotices extends StatefulWidget {
  @override
  _PostNoticesState createState() => _PostNoticesState();
}

class _PostNoticesState extends State<PostNotices> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _noticeController = TextEditingController();
  final TextEditingController _scheduledAtController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  String _selectedCategory = 'University News'; // Default category

  Future<void> _submitNotice() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Retrieve FCM Token
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          DateTime scheduledDateTime =
              DateTime.parse(_scheduledAtController.text);
          Timestamp scheduledAt = Timestamp.fromDate(scheduledDateTime);

          await _firebaseService.addNotice(
            _titleController.text,
            _contentController.text,
            _imageController.text,
            _noticeController.text,
            scheduledAt,
            fcmToken, // Add FCM token here
            _selectedCategory, // Pass selected category
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notice posted successfully!')),
          );
          _formKey.currentState!.reset();
          _titleController.clear();
          _contentController.clear();
          _imageController.clear();
          _noticeController.clear();
          _scheduledAtController.clear();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post notice: $e')),
        );
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          final DateTime pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _scheduledAtController.text = pickedDateTime.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          'Post Notice',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _noticeController,
                decoration: InputDecoration(
                  labelText: 'Notice URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a notice URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: <String>[
                  'University News',
                  'University Notices',
                  'Highlights for Students',
                  'University Events',
                  'Vacancy and Career',
                  'Tender and Procurement',
                  'KU Bulletin'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _scheduledAtController,
                readOnly: true,
                onTap: () => _selectDateTime(context),
                decoration: InputDecoration(
                  labelText: 'Scheduled At',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a scheduled time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitNotice,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
