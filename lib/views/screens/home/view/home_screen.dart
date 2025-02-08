import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../model/user_model.dart';
import '../../../../routes/routes.dart';
import '../../../../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    log("--------------------------");
    // log("State : $state");

    if (state == AppLifecycleState.resumed) {
      log("Resumed State......");
    } else if (state == AppLifecycleState.inactive) {
      log("Inactive State......");
    } else if (state == AppLifecycleState.hidden) {
      log("Hidden State......");
    } else if (state == AppLifecycleState.paused) {
      log("Paused State......");
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            FutureBuilder(
              future: FireStoreService.fireStoreService.fetchSingleUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;

                  // Map<String, dynamic> userData = data?.data() ?? {};

                  UserModel user = UserModel.fromMap(data: data?.data() ?? {});

                  return UserAccountsDrawerHeader(
                    accountName: Text(user.name),
                    accountEmail: Text(user.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                    ),
                  );
                }
                return Container();
              },
            ),
            ListTile(
              onTap: () {
                controller.signOut();
                Get.offNamed(Routes.login);
              },
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
      ),
      body: StreamBuilder(
        stream: FireStoreService.fireStoreService.fetchUsers(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("Error : ${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data?.docs ?? [];

            List<UserModel> allUsers = allDocs
                .map(
                  (e) => UserModel.fromMap(data: e.data()),
                )
                .toList();

            return ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  var user = allUsers[index];

                  return Card(
                    child: ListTile(
                      onTap: () {
                        Get.toNamed(Routes.chat, arguments: user);
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
