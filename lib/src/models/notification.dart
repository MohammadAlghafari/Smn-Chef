import 'dart:convert';

import '../helpers/custom_trace.dart';

class Notification {
  String id;
  String type;
  String message;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    if(jsonMap.isNotEmpty)
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : '';
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      message = jsonMap['data'] != null ? json.decode(jsonMap['data'])['message'].toString()  : '';
      data = jsonMap['data'] != null ? {} : {};
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = jsonMap['created_at'] != null ? DateTime.parse(jsonMap['created_at']) : new DateTime(0);
    } catch (e) {
      id = '';
      type = '';
      message = '';
      data = {};
      read = false;
      createdAt = new DateTime(0);
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
