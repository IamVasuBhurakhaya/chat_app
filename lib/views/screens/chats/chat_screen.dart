import 'dart:io';

import 'package:chat_app/controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../model/chat_model.dart';
import '../../../model/user_model.dart';
import '../../../services/auth_services.dart';
import '../../../services/fcm_services.dart';
import '../../../services/firestore_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? wallpaperUrl;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadWallpaper();
  }

  Future<void> _loadWallpaper() async {
    if (user == null) return;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc(user!.email)
        .get();

    if (snapshot.exists && snapshot.data()?['wallpaper'] != null) {
      setState(() {
        wallpaperUrl = snapshot.data()?['wallpaper'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModal user = Get.arguments;
    TextEditingController msgController = TextEditingController();
    TextEditingController editMsgController = TextEditingController();
    HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
          decoration: BoxDecoration(
            image: wallpaperUrl != null
                ? DecorationImage(
                    image: FileImage(File(wallpaperUrl!)),
                    fit: BoxFit.cover,
                    opacity: 0.1,
                  )
                : null, // No wallpaper set, fallback to default
          ),
          child: Column(
            children: [
              SizedBox(
                height: 12.h,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, size: 26.sp),
                  ),
                  CircleAvatar(
                    radius: 20.sp,
                    foregroundImage: NetworkImage(user.image!),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.name}",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${user.email}",
                        style: TextStyle(fontSize: 10.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.video_call_rounded),
                  SizedBox(width: 12.w),
                  const Icon(Icons.call),
                  SizedBox(width: 6.w),
                ],
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder(
                  stream: FirestoreService.fireStoreService.fetchChats(
                      senderMail:
                          FirebaseAuthService.auth.checkUserStatus!.email ?? '',
                      receiverMail: user.email!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;

                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allChats = data!.docs;

                      List<ChatModal> allChatData = allChats
                          .map(
                            (e) => ChatModal.fromMap(data: e.data()),
                          )
                          .toList();

                      // log("${allChatData}");
                      return ListView.builder(
                        itemCount: allChatData.length,
                        itemBuilder: (context, index) {
                          DateTime time = allChatData[index].time.toDate();
                          // log("${allChatData[index].time.toDate().day}/${allChatData[index].time.toDate().month}");
                          return Column(
                            children: [
                              (time.day == DateTime.now().day &&
                                      time.month == DateTime.now().month &&
                                      time.year == DateTime.now().year)
                                  ? const Text("Today")
                                  : (time.day ==
                                              DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 1))
                                                  .day &&
                                          time.month ==
                                              DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 1))
                                                  .month &&
                                          time.year ==
                                              DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 1))
                                                  .year)
                                      ? const Text("Yesterday")
                                      : Text(
                                          "${time.day}:${time.month}:${time.year}"),
                              (allChatData[index].receiver == user.email)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: GestureDetector(
                                            onLongPress: () {
                                              Get.defaultDialog(
                                                content: Row(
                                                  mainAxisAlignment:
                                                      (DateTime.now()
                                                                  .difference(
                                                                      time)
                                                                  .inMinutes <=
                                                              10)
                                                          ? MainAxisAlignment
                                                              .spaceAround
                                                          : MainAxisAlignment
                                                              .center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        FirestoreService
                                                            .fireStoreService
                                                            .deleteChats(
                                                          sender: FirebaseAuthService
                                                                  .auth
                                                                  .checkUserStatus!
                                                                  .email ??
                                                              "",
                                                          receiver:
                                                              user.email ?? '',
                                                          id: allChats[index]
                                                              .id,
                                                        );
                                                        Get.back();
                                                      },
                                                      label:
                                                          const Text("Delete"),
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    ),
                                                    Visibility(
                                                      visible: (DateTime.now()
                                                              .difference(time)
                                                              .inMinutes <=
                                                          10),
                                                      child:
                                                          ElevatedButton.icon(
                                                        label:
                                                            const Text("Edit"),
                                                        onPressed: () {
                                                          editMsgController
                                                                  .text =
                                                              allChatData[index]
                                                                  .msg;
                                                          Get.back();

                                                          Get.bottomSheet(
                                                            Container(
                                                              height: 100.h,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              child: TextField(
                                                                controller:
                                                                    editMsgController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  fillColor: Colors
                                                                      .lightBlueAccent
                                                                      .withOpacity(
                                                                          0.4),
                                                                  filled: true,
                                                                  border:
                                                                      const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.blue),
                                                                  ),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      String
                                                                          msg =
                                                                          editMsgController
                                                                              .text;
                                                                      if (msg
                                                                          .isNotEmpty) {
                                                                        FirestoreService.fireStoreService.editChats(
                                                                            sender: FirebaseAuthService.auth.checkUserStatus!.email ??
                                                                                '',
                                                                            receiver:
                                                                                user.email!,
                                                                            id: allChats[index].id,
                                                                            msg: msg);
                                                                      }
                                                                      Get.back();
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .send),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.edit),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: IntrinsicWidth(
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.6,
                                                  minWidth: 0.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 160, 219, 246),
                                                  border: Border.all(
                                                      color: Colors.lightBlue),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(22),
                                                    topRight:
                                                        Radius.circular(24),
                                                    bottomLeft:
                                                        Radius.circular(22),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: const EdgeInsets.all(4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${allChatData[index].msg}",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                        "${time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Text("${time.hour % 12}:${time.minute}"),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IntrinsicWidth(
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 147, 233, 150),
                                              border: Border.all(
                                                  color: Colors.green),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.all(4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${allChatData[index].msg}",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    "${time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              // Spacer(),
              TextField(
                controller: msgController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  hintText: "Write Something...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      String msg = msgController.text;

                      if (msg.isNotEmpty) {
                        FirestoreService.fireStoreService.sentChat(
                          modal: ChatModal(
                            msg: msg,
                            sender: FirebaseAuthService
                                    .auth.checkUserStatus!.email ??
                                '',
                            receiver: user.email!,
                            time: Timestamp.now(),
                          ),
                        );
                        FCMService.fcmService.sendFCM(
                            title: user.name ?? '',
                            body: msg,
                            token: user.token!);

                        msgController.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    FirestoreService.fireStoreService.sentChat(
                      modal: ChatModal(
                        msg: value,
                        sender:
                            FirebaseAuthService.auth.checkUserStatus!.email ??
                                '',
                        receiver: user.email!,
                        time: Timestamp.now(),
                      ),
                    );

                    FCMService.fcmService.sendFCM(
                        title: user.name ?? '',
                        body: value,
                        token: user.token!);
                  }
                  msgController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
