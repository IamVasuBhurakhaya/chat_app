import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/chat_model.dart';
import '../../../model/user_model.dart';
import '../../../services/auth_services.dart';
import '../../../services/fcm_services.dart';
import '../../../services/firestore_service.dart';
import '../../../services/local_notification.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = Get.arguments;
    TextEditingController msgController = TextEditingController();
    TextEditingController editMSGController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25.w,
                  backgroundImage: NetworkImage(user.image),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 6,
                ),
                IconButton(
                  onPressed: () async {
                    // await NotificationService.notificationService
                    //     .showPeriodicNotification(
                    //   title: "Periodic",
                    //   body: "This is a periodic notification 😆",
                    // );

                    await NotificationService.notificationService
                        .showBigPictureNotification(
                      title: user.name,
                      body: user.email,
                      url:
                          "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgpVyWUseZodZjeS_zuX4EndfzsMKmn_j2EyS6o_mqGLKsOJjIIkRkUJ6YVtzHWSvd0c-YtW4WT9LP3ujW3BQLJoxOZ_w4tM-KuSCvV_ezS9NFS3awt6UHkX-ZGx7BQh7EdADmtNQ/s1600/Motu-Patlu-Nickelodeon-India-Nick.jpg",
                    );
                  },
                  icon: const Icon(Icons.notification_add),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FireStoreService.fireStoreService.fetchChats(
                      sender: AuthService.authService.currentUser!.email ?? "",
                      receiver: user.email),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      var data = snapShot.data;
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allData = data!.docs;

                      // log("Id : ${allData[0].id}");

                      List<ChatModal> allChats = allData
                          .map(
                            (e) => ChatModal.fromMap(data: e.data()),
                          )
                          .toList();

                      return (allChats.isNotEmpty)
                          ? ListView.builder(
                              itemCount: allChats.length,
                              itemBuilder: (context, index) {
                                log("Time : $allChats");
                                log("Time : ${allChats[index].time.toDate()}");

                                DateTime time = allChats[index].time.toDate();
                                return (allChats[index].receiver == user.email)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: GestureDetector(
                                              onLongPress: () {
                                                Get.defaultDialog(
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Get.back();

                                                          FireStoreService
                                                              .fireStoreService
                                                              .deleteChat(
                                                            sender: AuthService
                                                                    .authService
                                                                    .currentUser!
                                                                    .email ??
                                                                "",
                                                            receiver:
                                                                user.email,
                                                            id: allData[index]
                                                                .id,
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors
                                                              .red.shade200,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          editMSGController
                                                                  .text =
                                                              allChats[index]
                                                                  .msg;

                                                          Get.back();
                                                          Get.bottomSheet(
                                                            Container(
                                                              height: 100.h,
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(12),
                                                              child: TextField(
                                                                controller:
                                                                    editMSGController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      String
                                                                          msg =
                                                                          editMSGController
                                                                              .text;

                                                                      if (msg
                                                                          .isNotEmpty) {
                                                                        FireStoreService.fireStoreService.updateChat(
                                                                            sender: AuthService.authService.currentUser!.email ??
                                                                                "",
                                                                            receiver:
                                                                                user.email,
                                                                            id: allData[index].id,
                                                                            msg: msg);
                                                                      }

                                                                      Get.back();
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .update),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors
                                                              .green.shade200,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors
                                                      .deepPurple.shade100,
                                                ),
                                                child:
                                                    Text(allChats[index].msg),
                                              ),
                                            ),
                                          ),
                                          Transform.translate(
                                            offset: const Offset(0, 5),
                                            child: Text(
                                              "${time.hour % 12}:${time.minute}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.green.shade100,
                                            ),
                                            child: Text(allChats[index].msg),
                                          ),
                                        ],
                                      );
                              })
                          : Center(
                              child: Image.network(
                                  'https://cdn.dribbble.com/users/172747/screenshots/3135893/peas-nochats.gif'),
                            );
                    }
                    return Container();
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    onSubmitted: (val) async {
                      if (val.isNotEmpty) {
                        String senderEmail =
                            AuthService.authService.currentUser!.email ?? "";
                        FireStoreService.fireStoreService.sentChat(
                          chatModal: ChatModal(
                            msg: val,
                            sender: senderEmail,
                            receiver: user.email,
                            time: Timestamp.now(),
                          ),
                        );
                        await FCMService.fcmService.sendFCM(
                          title:
                              AuthService.authService.currentUser!.email ?? "",
                          body: val,
                          token: user.token,
                        );

                        // await NotificationService.notificationService
                        //     .showSimpleNotification(
                        //   title: user.name,
                        //   body: val,
                        // );
                        //
                        // await NotificationService.notificationService
                        //     .showScheduledNotification(
                        //   title: "Scheduled",
                        //   body: "This notification is scheduled...",
                        //   scheduledDate: DateTime.now().add(
                        //     const Duration(seconds: 10),
                        //   ),
                        // );
                      }

                      msgController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Enter msg",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () async {
                    String msg = msgController.text;
                    String senderEmail =
                        AuthService.authService.currentUser!.email ?? "";

                    if (msg.isNotEmpty) {
                      FireStoreService.fireStoreService.sentChat(
                        chatModal: ChatModal(
                          msg: msg,
                          sender: senderEmail,
                          receiver: user.email,
                          time: Timestamp.now(),
                        ),
                      );

                      await FCMService.fcmService.sendFCM(
                        title: AuthService.authService.currentUser!.email ?? "",
                        body: msg,
                        token: user.token,
                      );

                      // await NotificationService.notificationService
                      //     .showSimpleNotification(
                      //   title: user.name,
                      //   body: msg,
                      // );
                      //
                      // await NotificationService.notificationService
                      //     .showScheduledNotification(
                      //   title: "Scheduled",
                      //   body: "This notification is scheduled...",
                      //   scheduledDate: DateTime.now().add(
                      //     const Duration(seconds: 10),
                      //   ),
                      // );
                    }

                    msgController.clear();
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
