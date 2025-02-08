import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';
import '../model/user_model.dart';
import 'auth_services.dart';

class FireStoreService {
  FireStoreService._();

  static FireStoreService fireStoreService = FireStoreService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String userCollection = "Users";
  String chatRoomCollection = "Chatroom";

  // TODO : To Add Users
  Future<void> addUser({required UserModel user}) async {
    await fireStore.collection(userCollection).doc(user.email).set(user.toMap);
  }

  // TODO : Fetch Users
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers() {
    String email = AuthService.authService.currentUser?.email ?? "";
    return fireStore
        .collection(userCollection)
        .where("email", isNotEqualTo: email)
        .snapshots();
  }

  // TODO: Fetch Single User
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchSingleUser() async {
    String email = AuthService.authService.currentUser?.email ?? "";
    return await fireStore.collection(userCollection).doc(email).get();
  }

  // Chats Logic

  String createDocId({
    required String sender,
    required String receiver,
  }) {
    List users = [sender, receiver];

    users.sort();

    String docId = users.join('_');

    return docId;
  }

  void sentChat({required ChatModal chatModal}) {
    String docId =
        createDocId(sender: chatModal.sender, receiver: chatModal.receiver);

    fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .add(chatModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChats({
    required String sender,
    required String receiver,
  }) {
    String docId = createDocId(sender: sender, receiver: receiver);

    return fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  void deleteChat({
    required String sender,
    required String receiver,
    required String id,
  }) {
    String docId = createDocId(sender: sender, receiver: receiver);

    fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .delete();
  }

  void updateChat({
    required String sender,
    required String receiver,
    required String id,
    required String msg,
  }) {
    String docId = createDocId(sender: sender, receiver: receiver);
    fireStore
        .collection(chatRoomCollection)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .update({
      'msg': msg,
    });
  }
}
