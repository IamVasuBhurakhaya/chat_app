import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for time formatting
import '../../../../model/user_model.dart';
import '../../../../routes/routes.dart';
import '../../../../services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = Get.put(HomeController());
  List<UserModal> allUsers = [];
  List<UserModal> filteredUsers = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    var snapshot = await FirestoreService.fireStoreService.fetchUsers().first;
    var docs = snapshot.docs;
    setState(() {
      allUsers = docs.map((e) => UserModal.fromMap(e.data())).toList();
      filteredUsers = allUsers;
    });
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = query.isEmpty
          ? allUsers
          : allUsers
              .where((user) =>
                  user.name?.toLowerCase().contains(query.toLowerCase()) ??
                  false)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: _filterUsers,
              )
            : Text("WhatsApp",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => setState(() => isSearching = true),
            ),
          if (isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchController.clear();
                  _filterUsers("");
                });
              },
            ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text("New group"), value: "new_group"),
              const PopupMenuItem(
                  child: Text("New broadcast"), value: "new_broadcast"),
              const PopupMenuItem(child: Text("Settings"), value: "settings"),
              const PopupMenuItem(child: Text("Log out"), value: "logout"),
            ],
            onSelected: (value) {
              if (value == "logout") {
                controller.logOut();
              } else if (value == "settings") {
                Get.toNamed(AppRoutes.setting);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          var usersInfo = filteredUsers[index];
          return StreamBuilder<QuerySnapshot>(
            stream: FirestoreService.fireStoreService.fetchLastMessage(
              senderMail: FirebaseAuthService.auth.checkUserStatus?.email ?? '',
              receiverMail: usersInfo.email ?? '',
            ),
            builder: (context, snapshot) {
              String lastMessage = "No messages yet";
              String lastMessageTime = "";

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var messageData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                lastMessage = messageData['msg'] ?? "No messages yet";
                Timestamp? timestamp = messageData['time'];

                if (timestamp != null) {
                  DateTime dateTime = timestamp.toDate();
                  lastMessageTime = DateFormat('hh:mm a')
                      .format(dateTime); // 12-hour format with AM/PM
                }
              }

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.chat, arguments: usersInfo);
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: usersInfo.image != null
                          ? NetworkImage(usersInfo.image!)
                          : null,
                      child: usersInfo.image == null
                          ? const Icon(Icons.person,
                              color: Colors.white, size: 30)
                          : null,
                    ),
                    title: Text(
                      "${usersInfo.name}",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Text(
                      lastMessageTime,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}
