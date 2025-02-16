import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../../services/fireStore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.sp,
        backgroundColor: const Color(0xFF25D366),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.setting);
              },
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ))
        ],
        title: Text(
          "Chats",
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60.sp), // Adjust for search bar
            child: StreamBuilder(
              stream: FireStoreService.fireStoreService.fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var data = snapshot.data;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>>? allDocs =
                      data?.docs ?? [];
                  List<UserModal> userData =
                      allDocs.map((e) => UserModal.fromMap(e.data())).toList();

                  List<UserModal> filteredUsers = userData
                      .where((user) => user.name!
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var usersInfo = filteredUsers[index];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: ListTile(
                              onTap: () {
                                Get.toNamed(AppRoutes.chat,
                                    arguments: usersInfo);
                              },
                              leading: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          padding: EdgeInsets.only(top: 16.sp),
                                          height: 280.sp,
                                          width: 160.sp,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey[300],
                                          ),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 90.sp,
                                                backgroundImage: NetworkImage(
                                                    usersInfo.image ?? ''),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 50.sp,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF25D366)
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 20.sp),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .chat_bubble_text,
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 20.sp),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        CupertinoIcons.settings,
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 20.sp),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .app_badge,
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 20.sp),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30.sp,
                                  backgroundColor: Colors.grey[300],
                                  foregroundImage:
                                      NetworkImage(usersInfo.image ?? ''),
                                  child: usersInfo.image == null ||
                                          usersInfo.image!.isEmpty
                                      ? Icon(Icons.person,
                                          size: 30.sp, color: Colors.white)
                                      : null,
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usersInfo.name ?? 'unknown',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  /// 🔍 Floating Search Bar Widget
  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      hint: 'Search Chats...',
      openAxisAlignment: 0.0,
      axisAlignment: 0.0,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      onQueryChanged: (query) {
        setState(() {
          searchQuery = query;
        });
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      debounceDelay: const Duration(milliseconds: 300),
      physics: const BouncingScrollPhysics(),
      width: 600.sp,
      borderRadius: BorderRadius.circular(20),
      automaticallyImplyBackButton: false,
      clearQueryOnClose: false,
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                searchQuery = "";
              });
            },
          ),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(0, (index) => ListTile()),
            ),
          ),
        );
      },
    );
  }
}
