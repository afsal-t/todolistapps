import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String userName = 'User';
  String userImageUrl = '';
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firebase
  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'User';
        userImageUrl = user.photoURL ?? '';
      });
      _nameController.text = userName; // Pre-fill the text controller
    }
  }

  // Update user name
  Future<void> _updateUserName() async {
    final User? user = _auth.currentUser;
    if (user != null && _nameController.text.isNotEmpty) {
      await user.updateDisplayName(_nameController.text);
      setState(() {
        userName = _nameController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User name updated successfully!")),
      );
    }
  }

  // Pick image from gallery and upload to Firebase Storage
  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        final ref = _storage.ref().child('user_images/${_auth.currentUser?.uid}.jpg');
        await ref.putFile(File(image.path)); // Upload the image
        final url = await ref.getDownloadURL();
        await _auth.currentUser?.updatePhotoURL(url);
        setState(() {
          userImageUrl = url;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile image updated successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload image: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: userImageUrl.isNotEmpty
                        ? NetworkImage(userImageUrl)
                        : null,
                    child: userImageUrl.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _pickAndUploadImage,
                        child: const Text(
                          "Change Profile Picture",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Name Edit Section
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Edit Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black54),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _updateUserName,
                child: const Text(
                  "Save Name",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),

              // Settings Sections (Notifications, General, About, Account)
              _buildSectionTile('Notifications', () {
                // Navigate to notifications settings
              }),
              _buildSectionTile('General', () {
                // Navigate to general settings
              }),
              _buildSectionTile('About', () {
                // Navigate to about page
              }),
              _buildSectionTile('Account', () {
                // Navigate to account settings
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTile(String title, VoidCallback onTap) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }
}
