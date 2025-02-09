import 'package:chat_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../model/user_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController nameController;
  late TextEditingController imageController;
  late TextEditingController passwordController;
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            imageController.text.isEmpty
                                ? "https://via.placeholder.com/150"
                                : imageController.text),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: "Username"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: imageController,
                        decoration: const InputDecoration(
                            labelText: "Profile Image URL"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _updateUserData,
                        icon: const Icon(Icons.save),
                        label: const Text("Save Changes"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Password Change Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text("Change Password",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: "New Password"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _updatePassword,
                        icon: const Icon(Icons.lock_reset),
                        label: const Text("Update Password"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Logout Section
                _logoutTile(context),
              ],
            ),
    );
  }

  Widget _logoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text("Logout",
          style: TextStyle(fontSize: 16, color: Colors.red)),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Get.offAllNamed(AppRoutes.login); // Clears all previous routes
      },
    );
  }
}
