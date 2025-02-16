import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String msg, sender, receiver;
  Timestamp time;

  ChatModal(
      {required this.msg,
      required this.sender,
      required this.receiver,
      required this.time});

  factory ChatModal.mapToModel({required Map m1}) => ChatModal(
        msg: m1['msg'],
        sender: m1['sender'],
        receiver: m1['receiver'],
        time: m1['time'],
      );

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'sender': sender,
        'receiver': receiver,
        'time': time,
      };
}
