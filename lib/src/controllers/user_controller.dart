import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_owner/src/elements/MobileVerificationBottomSheetWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.of(context).these_credentials_do_not_match_our_records),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void register() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.of(context).thisAccountNotExist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  bool checkRegister() {
    Overlay.of(context).insert(loader);
    repository.checkRegister(user).then((value) {
      if (value['data']['email'] == '1' && value['data']['phone'] == '1') {
        loader?.remove();
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return MobileVerificationBottomSheetWidget(
                scaffoldKey: scaffoldKey, phone: user.phone);
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ).then((value) {
          if (value != null && value) register();
        });
      } else {
        loader?.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).email_or_phone_already_exist)));
        return false;
      }
    }).catchError((e) {
      loader?.remove();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).these_credentials_do_not_match_our_records),
      ));
    });
    return false;
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
