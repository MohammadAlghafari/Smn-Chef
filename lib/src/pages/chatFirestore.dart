import 'dart:io';
import 'dart:async';
import 'package:food_delivery_owner/src/models/constants.dart';
import 'package:food_delivery_owner/src/models/food.dart';
import 'package:food_delivery_owner/src/repository/add_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_owner/src/repository/chat_firestore.dart';
import 'package:food_delivery_owner/src/repository/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:food_delivery_owner/src/helpers/helper.dart';
import 'package:food_delivery_owner/generated/l10n.dart';

class Chat extends StatefulWidget {
  String message_id,restaurant_id,restaurant_name,chatRoomId;
  Chat({this.message_id,this.restaurant_id,this.restaurant_name,this.chatRoomId});
  @override
  _ChatState createState() => _ChatState();
}
List<int> listunseen=[];
class _ChatState extends State<Chat> {
  String restaurant_id = "";
  String order_id = "";
  int listLength=0;
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  Widget chatMessages(){
    setState(() {
      listunseen.clear();
    });
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
            reverse: true,
            itemBuilder: (context, index){
              listLength=snapshot.data.documents.length;
              if(snapshot.data.documents[index].data()["sendBy"]==currentUser.value.id&&
                  snapshot.data.documents[index].data()["seen"].toString().trim().isEmpty){
                listunseen.add(0);
               print("exist not read for market");
              }else{
                DatabaseMethods().updateSeen(widget.message_id.toString(),snapshot.data.documents[index].data()["documentID"].toString());
              }

              return MessageTile(
                message: snapshot.data.documents[index].data()["message"].toString(),
                sendByMe: currentUser.value.id == snapshot.data.documents[index].data()["sendBy"],
                timeshow:Constants.check_lang.toString() =="Home" ?
                snapshot.data.documents[index].data()["timeshow"].toString().replaceAll("ص", "AM").replaceAll("م", "PM"):
                snapshot.data.documents[index].data()["timeshow"].toString().replaceAll("AM", "ص").replaceAll("PM", "م"),
              );
            }) : Container();
      },
    );
  }
  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      String msg= messageEditingController.text.toString().trim();
      Map<String, dynamic> chatMessageMap = {
        "seen":"",
        "sendBy": currentUser.value.id,
        "restaurant_id":"${widget.restaurant_id.split("restaurant:").last.toString().split("}").first.toString()}",
        "message": messageEditingController.text.toString().trim(),
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
         'order_id':"${widget.message_id.toString()}",
        "timeshow":"${DateTime.now().year.toString()+":"+DateTime.now().month.toString()
      +":"+DateTime.now().day.toString()+"&"+DateFormat.jm().format(DateTime.now())}",
      };
      DatabaseMethods().addMessage("${currentUser.value.id+":"+listLength.toString()}","${widget.message_id.toString()}",
          "${restaurant_id}",
          widget.restaurant_name.toString().split("restaurant:").last.toString().split("}").first.toString().trim(),chatMessageMap,widget.message_id.toString());

      /// set data of message on php host
      if(listLength==0||listLength==null){
        print("not chat found");
        //setChatInfo("$restaurant_id", "$order_id");
      }
      setChatMessageInfo("$msg", restaurant_id, order_id, currentUser.value.id.toString(),"1");
      setState(() {
        messageEditingController.text = "";
      });
      DatabaseMethods().getChats("${widget.message_id.toString()}").then((val) {
        setState(() {
          chats = val;
        });
      });
      setState(() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            chatMessages();
          });
        });
        DatabaseMethods().checkAnotherUserSeen(widget.message_id.toString(),"${listunseen.length.toString()}");
      });


    }
  }
  @override
  void initState() {
    Firebase.initializeApp();
    restaurant_id =widget.restaurant_id.toString().split("restaurant:").last.toString().split("}").first.toString().trim();
    order_id = widget.message_id.toString();
    setState(() {
      Firestore.instance.collection("chatRoom")
          .document(widget.message_id.toString().trim())
          .update({
        'nSeen':"${currentUser.value.id+":"+listLength.toString()}",
      });
    });
    DatabaseMethods().getChats("${widget.message_id.toString()}").then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseMethods().checkAnotherUserSeen(widget.message_id.toString(),"${listunseen.length.toString()}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).hintColor,
        title:Text("Chat",style: TextStyle(color: Theme.of(context).primaryColor),),
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor, opacity: 12, size: 25),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
               child: chatMessages(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: Colors.black45,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none
                            ),
                          )),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: Icon(Icons.send,color: Theme.of(context).hintColor,)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String timeshow;
  MessageTile({@required this.message, @required this.sendByMe,@required this.timeshow});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            color: sendByMe?Theme.of(context).hintColor:Theme.of(context).primaryColorLight
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$message",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: sendByMe?Theme.of(context).primaryColor:Theme.of(context).hintColor,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 3,),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${timeshow.toString().split("&").last.toString()}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: sendByMe?Theme.of(context).primaryColor:Theme.of(context).hintColor,
                      fontSize: 10,
                      fontFamily: 'OverpassRegular',
                    )),
                 Visibility(
                  visible: (DateTime.now().year.toString()+":"+DateTime.now().month.toString()
                     +":"+DateTime.now().day.toString()).toString() ==timeshow.toString().split("&").first.toString()?false:true,
                   child:Text("${timeshow.toString().split("&").first.toString()}",
                     textAlign: TextAlign.start,
                     style: TextStyle(
                       color: sendByMe?Theme.of(context).primaryColor:Theme.of(context).hintColor,
                       fontSize: 9,
                       fontFamily: 'OverpassRegular',
                     )),
               ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}