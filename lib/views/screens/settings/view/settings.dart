import 'package:chat_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late TextEditingController nameController;
  late TextEditingController statusController;
  late TextEditingController imageController;
  late TextEditingController passwordController;
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  File? _image;
  File? _wallpaper; // New wallpaper file

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    statusController = TextEditingController();
    imageController = TextEditingController();
    passwordController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc(user!.email)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data()!;
      setState(() {
        nameController.text = data['name'] ?? '';
        statusController.text =
            data['status'] ?? 'Hey there! I am using WhatsApp';
        imageController.text = data['image'] ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .update({
      'name': nameController.text,
      'status': statusController.text,
      'image': imageController.text,
    });

    setState(() {
      isLoading = false;
    });

    Get.snackbar("Success", "Profile updated successfully!",
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _updatePassword() async {
    if (user == null || passwordController.text.isEmpty) return;

    try {
      await user!.updatePassword(passwordController.text);
      Get.snackbar("Success", "Password updated successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to pick wallpaper
  Future<void> _pickWallpaper() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _wallpaper = File(pickedFile.path);
      });

      // Upload wallpaper to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.email)
          .update({'wallpaper': pickedFile.path});

      Get.snackbar("Success", "Wallpaper updated!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Feature Unavailable"),
            content: const Text("This feature isn't available on your device."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 22.sp,
          ),
          color: Colors.white,
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF25D366),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/whatshapp_bg.jpg',
            ),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  // Profile Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : NetworkImage(imageController.text.isEmpty
                                    ? "https://via.placeholder.com/150"
                                    : imageController.text) as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: nameController,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Your Name",
                                ),
                              ),
                              TextField(
                                controller: statusController,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Hey there! I am using WhatsApp",
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: _updateUserData,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Change Section
                  _settingsSection("Change Password", [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter new password",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save, color: Colors.green),
                            onPressed: _updatePassword,
                          ),
                        ],
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _settingsSection("Chats", [
                    _settingsTile(Icons.chat, "Chat backup", () {
                      showDialogue(context);
                    }),
                    _settingsTile(
                        Icons.wallpaper, "Chat wallpaper", _pickWallpaper),
                    if (_wallpaper != null)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_wallpaper!,
                              height: 150, fit: BoxFit.cover),
                        ),
                      ),
                  ]),

                  // Notifications Section
                  _settingsSection("Notifications", [
                    _settingsTile(Icons.notifications, "Message notifications",
                        () {
                      showDialogue(context);
                    }),
                    _settingsTile(Icons.volume_up, "Call notifications", () {
                      showDialogue(context);
                    }),
                  ]),

                  // Logout Button
                  const SizedBox(height: 20),
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout",
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offAllNamed(AppRoutes.login);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _settingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(children: children),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
