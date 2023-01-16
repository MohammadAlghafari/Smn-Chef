import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_owner/src/repository/add_chat.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/chat.dart';
import '../models/conversation.dart';
import '../repository/chat_repository.dart';
import '../repository/notification_repository.dart';
import '../repository/user_repository.dart';

class ChatController extends ControllerMVC {
  Conversation conversation;
  ChatRepository _chatRepository;
  Stream<QuerySnapshot> conversations;
  Stream<QuerySnapshot> chats;
  GlobalKey<ScaffoldState> scaffoldKey;

  ChatController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _chatRepository = new ChatRepository();
//    _createConversation();
  }

  signIn() {
    //_chatRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
//    _chatRepository.signInWithToken(currentUser.value.apiToken);
  }

  createConversation(Conversation _conversation) async {
//    _conversation.lastMessageTime = DateTime.now().toUtc().millisecondsSinceEpoch;
//    _conversation.readByUsers = [currentUser.value.id];
//    setState(() {
//      conversation = _conversation;
//    });
    _chatRepository.createConversation(conversation).then((value) {
      listenForChats(conversation);
    });
  }

  listenForConversations() async {
    _chatRepository
        .getUserConversations(currentUser.value.id)
        .then((snapshots) {
      setState(() {
        conversations = snapshots;
      });
    });
  }

  listenForChats(Conversation _conversation) async {
    _conversation.readByUsers.add(currentUser.value.id);
    _chatRepository.getChats(_conversation).then((snapshots) {
      setState(() {
        chats = snapshots;
      });
    });
  }

  addMessage(
      Conversation _conversation, String text, int len, String restaurant_id) {
    Chat _chat = new Chat(text, DateTime.now().toUtc().millisecondsSinceEpoch,
        currentUser.value.id);
    if (_conversation.id == null) {
      _conversation.id = UniqueKey().toString();
      createConversation(_conversation);
    }
    _conversation.lastMessage = text;
    _conversation.lastMessageTime = _chat.time;
    _conversation.readByUsers = [currentUser.value.id];
    _chatRepository.addMessage(_conversation, _chat).then((value) async {
      for (var i = 0; i < _conversation.users.length; i++) {
        if (_conversation.users[i].id != currentUser.value.id) {
          /// set data of message on php host
          if (len == 0 || len == null) {
            print("not chat found");
            await setChatInfo("${restaurant_id}",
                "${_conversation.users[i].id}", "${_conversation.id}");
          }
          await setChatMessageInfo("$text", restaurant_id, _conversation.id,
              currentUser.value.id.toString(), "0");
          sendNotification(
              text,
              S.of(context).newMessageFrom + " " + currentUser.value.name,
              _conversation.users[i]);
          break;
        }
      }
    });
  }

  Future<void> removeConversation(
    String conversationId,
  ) async{
    return await _chatRepository.removeConversation(conversationId);
  }

  orderSnapshotByTime(AsyncSnapshot snapshot) {
    final docs = snapshot.data.documents;
    docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
      var time1 = a.get('time');
      var time2 = b.get('time');
      return time2.compareTo(time1) as int;
    });
    return docs;
  }
}
