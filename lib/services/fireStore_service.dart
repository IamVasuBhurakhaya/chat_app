import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_model.dart';
import '../model/user_model.dart';
import 'auth_services.dart';

class FireStoreService {
  FireStoreService._();
  static FireStoreService fireStoreService = FireStoreService._();

  var fireStore = FirebaseFirestore.instance;
  String collectionName = "Users";
  String chatRoomCollectionName = "Chatroom";

  Future<void> addUsers({required UserModal modal}) async {
    await fireStore
        .collection(collectionName)
        .doc(modal.email)
        .set(modal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers() {
    String email = FirebaseAuthService.auth.statusUser?.email ?? '';

    return fireStore
        .collection(collectionName)
        .where("email", isNotEqualTo: email)
        .snapshots();
  }

  String getDocId({required String senderMail, required String receiverMail}) {
    List user = [senderMail, receiverMail];
    user.sort();
    String docId = user.join('_');
    return docId;
  }

  void sentChat({required ChatModal modal}) {
    String docId =
        getDocId(senderMail: modal.sender, receiverMail: modal.receiver);
    fireStore
        .collection(chatRoomCollectionName)
        .doc(docId)
        .collection('Chats')
        .add(modal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChats(
      {required String senderMail, required String receiverMail}) {
    String docId = getDocId(
      senderMail: senderMail,
      receiverMail: receiverMail,
    );
    return fireStore
        .collection(chatRoomCollectionName)
        .doc(docId)
        .collection('Chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future<void> deleteChats(
      {required String sender, required String receiver, required String id}) {
    String docId = getDocId(
      senderMail: sender,
      receiverMail: receiver,
    );

    return fireStore
        .collection(chatRoomCollectionName)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .delete();
  }

  Future<void> editChats(
      {required String sender,
      required String receiver,
      required String id,
      required String msg}) {
    String docId = getDocId(senderMail: sender, receiverMail: receiver);

    return fireStore
        .collection(chatRoomCollectionName)
        .doc(docId)
        .collection('Chats')
        .doc(id)
        .update({'msg': msg});
  }
}
