import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;
import '../models/user.dart' as userModel;
import '../repository/user_repository.dart';
import 'BlockButtonWidget.dart';

class MobileVerificationBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String phone;

  MobileVerificationBottomSheetWidget({Key key, this.scaffoldKey, this.phone})
      : super(key: key);

  @override
  _MobileVerificationBottomSheetWidgetState createState() =>
      _MobileVerificationBottomSheetWidgetState();
}

class _MobileVerificationBottomSheetWidgetState
    extends State<MobileVerificationBottomSheetWidget> {
  String errorMessage;
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    verifyPhone();
    super.initState();
  }

  verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    void smsCodeSent(String verId, [int forceCodeResent]) {
      print('verId: ' + verId);
      setState(() {
        currentUser.value.verificationId = verId;
      });
    }

    ;

    final PhoneVerificationCompleted _verifiedSuccess =
        (AuthCredential auth) {};
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {};
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  verifyCode(String code) async {
    print(currentUser.value.verificationId);
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: currentUser.value.verificationId ?? '', smsCode: code);

    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      currentUser.value.verifiedPhone = true;
      Navigator.of(widget.scaffoldKey.currentContext).pop(true);
    }).catchError((e) {
      setState(() {
        errorMessage = e.toString().split('\]').last;
      });
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.4),
              blurRadius: 30,
              offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: ListView(
              padding:
                  EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
              children: <Widget>[
                Text(
                  S.of(context).verifyPhoneNumber,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                errorMessage == null
                    ? Text(
                        S
                            .of(context)
                            .weAreSendingOtpToValidateYourMobileNumberHang,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        errorMessage ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .merge(TextStyle(color: Colors.redAccent)),
                        textAlign: TextAlign.center,
                      ),
                SizedBox(height: 15),
                PinPut(
                  fieldsCount: 6,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(color: Colors.redAccent)),
                  submittedFieldDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent)),
                  selectedFieldDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent)),
                  followingFieldDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber[700])),
                  onClipboardFound: (code) {
                    //verifyCode(code);
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: textController,
                ),
                SizedBox(height: 15),
                Text(
                  S.of(context).smsHasBeenSentTo + ' ' + widget.phone,
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),
                BlockButtonWidget(
                  onPressed: textController.text == '' ||
                          textController.text == null ||
                          textController.text.length < 6
                      ? null
                      : () => verifyCode(textController.text),
                  color: Theme.of(context).accentColor,
                  text: Text(S.of(context).verify.toUpperCase(),
                      style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: config.App(context).appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
