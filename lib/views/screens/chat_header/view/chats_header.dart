import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../model/user_model.dart';

class ChatsHeader extends StatefulWidget {
  const ChatsHeader({super.key});

  @override
  State<ChatsHeader> createState() => _ChatsHeaderState();
}

class _ChatsHeaderState extends State<ChatsHeader> {
  User? user = FirebaseAuth.instance.currentUser;

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
    UserModal userModal = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.sp,
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
          "Contact Info",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF25D366),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/whatshapp_bg.jpg'),
              fit: BoxFit.cover,
              opacity: 0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircleAvatar(
                radius: 80.sp,
                backgroundImage:
                    userModal.image != null && userModal.image!.isNotEmpty
                        ? NetworkImage(userModal.image!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
              ),
            ),

            Text(
              userModal.name ?? "User",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                userModal.email ?? "Available",
                style: const TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),

            const Divider(),

            // Contact Info Section
            ListTile(
              leading: const Icon(Icons.call, color: Colors.teal),
              title: const Text("Voice Call"),
              subtitle: const Text("Tap to call"),
              onTap: () {
                showDialogue(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.teal),
              title: const Text("Video Call"),
              subtitle: const Text("Tap to video call"),
              onTap: () {
                showDialogue(context);
              },
            ),

            const Divider(),

            // Media, Links, and Docs Section
            ListTile(
              leading: const Icon(Icons.image, color: Colors.teal),
              title: const Text("Media, Links, and Docs"),
              subtitle: const Text("View shared files"),
              onTap: () {
                showDialogue(context);
              },
            ),

            // Mute Notification
            ListTile(
              leading: const Icon(Icons.notifications_off, color: Colors.teal),
              title: const Text("Mute Notifications"),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  showDialogue(context);
                },
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.lock, color: Colors.teal),
              title: const Text("Encryption"),
              subtitle: const Text("Messages are end-to-end encrypted"),
              onTap: () {
                showDialogue(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
