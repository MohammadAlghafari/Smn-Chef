import 'dart:convert';
import 'dart:io';
// import 'package:Karshah/src/models/constants.dart';
import '../models/user.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../repository/user_repository.dart' as userRepo;



Future<http.Response> setChatInfo(String restaurant_id, String user_id, String conversation_id) async {
  User _user = userRepo.currentUser.value;
  print(
      'api chat sent: https://smnfood.app/api/chat_create?user_id=${userRepo.currentUser.value.id}&conversation_id=${conversation_id.toString()}&restaurant_id=${restaurant_id}&api_token=${_user.apiToken}');
  var response = await http.post(
    'https://smnfood.app/api/chat_create',
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
     body: jsonEncode(<String, String>{
      'restaurant_id': restaurant_id,
       'conversation_id': conversation_id,
       'user_id': user_id,
       'api_token': _user.apiToken
    }),
  );
  print(response.body);
  return response;
}

Future<http.Response> setChatMessageInfo(String message, String restaurant_id,
    String conversation_id, String user_id, String is_customer) async {
  User _user = userRepo.currentUser.value;
  print(
      'api chat sent message: https://smnfood.app/api/message_create?is_customer=${is_customer}&order_id=${conversation_id.toString()}&restaurant_id=11&api_token=${_user.apiToken}&sender_id=${user_id}&message=${message}');
  var response = await http.post(
    'https://smnfood.app/api/message_create',
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: jsonEncode(<String, String>{
       'restaurant_id': restaurant_id,
      'conversation_id': conversation_id,
       'sender_id': user_id,
      'message': message,
      'api_token': _user.apiToken
    }),
  );
  print(response.body);
  return response;
}