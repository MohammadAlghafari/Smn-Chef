import 'package:food_delivery_owner/src/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userName", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time',descending:true)
        .snapshots();
  }


  Future<void> addMessage(String nSeen,String chatRoomId, String restauranID,
      String restauranName,chatMessageData,String orderid)async{
    Future<DocumentReference> doc_ref=Firestore.instance.collection("chatRoom")
        .document(chatRoomId.toString().trim())
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
    // ignore: missing_return
    await doc_ref.then((value){
      print("doc id:"+value.documentID);
      Firestore.instance.collection("chatRoom")
          .document(chatRoomId.toString().trim())
          .collection("chats").document(value.documentID).update({"documentID":value.documentID.toString()});
    });
    var users=[
      currentUser.value.name,
      "rest:"+restauranID,
      "restName:"+restauranName,
      "id:"+orderid,
      currentUser.value.id
    ];
    Firestore.instance.document('chatRoom/$chatRoomId').get().then((onexist){
      if(!onexist.exists){
        Firestore.instance.collection("chatRoom")
            .document(chatRoomId.toString().trim())
            .set({
          'chatRoomId': '${chatRoomId.toString().trim()}',
          'nSeen':"${nSeen.toString()}",
          'kseen':"",
          'useen':"",
          "users":users
        });
      }else{
        Firestore.instance.collection("chatRoom")
            .document(chatRoomId.toString().trim())
            .update({
          'nSeen':"${nSeen.toString()}",
        });
      }});

  }


  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  Future<void> updateSeen(String chatRoomId,String docID)async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .document(docID).update({"seen":"seen"});
  }
  Future<void> checkAnotherUserSeen(String chatRoomId,String numberofnotseen)async{
    return Firestore.instance.collection("chatRoom")
        .document(chatRoomId.toString().trim())
        .update({
      'kseen':"$numberofnotseen"
    });
  }
}
