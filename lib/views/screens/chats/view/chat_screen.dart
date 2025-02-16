import 'dart:io';
import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/services/fireStore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../model/chat_model.dart';
import '../../../../services/auth_services.dart';
import '../../../../services/fcm_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  TextEditingController msgController = TextEditingController();
  TextEditingController editMsgController = TextEditingController();
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    UserModal user = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.sp,
        backgroundColor: Color(0xFF25D366),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 22.sp,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.chatHeader, arguments: user);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.name}",
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "${user.email}",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            image: wallpaperUrl != null
                ? DecorationImage(
                    image: FileImage(File(wallpaperUrl!)),
                    fit: BoxFit.cover,
                    opacity: 0.1,
                  )
                : null, //
          ),
          child: Column(
            children: [
              SizedBox(
                height: 12.h,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FireStoreService.fireStoreService.fetchChats(
                      senderMail:
                          FirebaseAuthService.auth.statusUser!.email ?? '',
                      receiverMail: user.email!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;

                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allChats = data!.docs;

                      List<ChatModal> allChatData = allChats
                          .map(
                            (e) => ChatModal.mapToModel(m1: e.data()),
                          )
                          .toList();

                      return ListView.builder(
                        itemCount: allChatData.length,
                        itemBuilder: (context, index) {
                          DateTime time = allChatData[index].time.toDate();
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
                                          "${time.day} / ${time.month} / ${time.year}"),
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
                                                        FireStoreService
                                                            .fireStoreService
                                                            .deleteChats(
                                                          sender:
                                                              FirebaseAuthService
                                                                      .auth
                                                                      .statusUser!
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
                                                                        FireStoreService.fireStoreService.editChats(
                                                                            sender: FirebaseAuthService.auth.statusUser!.email ??
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
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF25D366)
                                                      .withOpacity(0.5),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFF25D366),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(18),
                                                    topRight:
                                                        Radius.circular(18),
                                                    bottomLeft:
                                                        Radius.circular(18),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      allChatData[index].msg,
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
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
                                                    0.6),
                                            decoration: BoxDecoration(
                                              color: Colors.black45
                                                  .withOpacity(0.3),
                                              border: Border.all(
                                                  color: Colors.black45),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(18),
                                                topRight: Radius.circular(18),
                                                bottomRight:
                                                    Radius.circular(18),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${allChatData[index].msg}",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
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
                        FireStoreService.fireStoreService.sentChat(
                          modal: ChatModal(
                            msg: msg,
                            sender:
                                FirebaseAuthService.auth.statusUser!.email ??
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
                    FireStoreService.fireStoreService.sentChat(
                      modal: ChatModal(
                        msg: value,
                        sender:
                            FirebaseAuthService.auth.statusUser!.email ?? '',
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
