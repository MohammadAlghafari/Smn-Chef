import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../repository/settings_repository.dart';

import '../models/chat.dart';
import '../repository/user_repository.dart';

class ChatMessageListItem extends StatelessWidget {
  final Chat chat;

  ChatMessageListItem({this.chat});

  @override
  Widget build(BuildContext context) {
    return currentUser.value.id == this.chat.userId
        ? getSentMessageLayout(context)
        : getReceivedMessageLayout(context);
  }

  Widget getSentMessageLayout(context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.2),
            borderRadius:
                setting.value.mobileLanguage.value.languageCode == 'en'
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))
                    : BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(this.chat.user.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .merge(TextStyle(fontWeight: FontWeight.w600))),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(chat.text),
                  ),
                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.only(
                  left: setting.value.mobileLanguage.value.languageCode == 'en'
                      ? 8.0
                      : 0,
                  right: setting.value.mobileLanguage.value.languageCode == 'en'
                      ? 0
                      : 8.0),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: this.chat.user.image.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReceivedMessageLayout(context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius:
                setting.value.mobileLanguage.value.languageCode == 'en'
                    ? BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))
                    : BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(
                  right: setting.value.mobileLanguage.value.languageCode == 'en'
                      ? 8.0
                      : 0,
                  left: setting.value.mobileLanguage.value.languageCode == 'en'
                      ? 0
                      : 8.0),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: this.chat.user.image.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(this.chat.user.name,
                      style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor))),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(
                      chat.text,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
