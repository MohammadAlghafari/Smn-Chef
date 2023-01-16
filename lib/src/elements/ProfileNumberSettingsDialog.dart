import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_owner/src/repository/user_repository.dart';

import '../../generated/l10n.dart';
import '../models/user.dart' as um;
import 'MobileVerificationBottomSheetWidget.dart';

class ProfileNumberSettingsDialog extends StatefulWidget {
  final um.User user;
  final VoidCallback onChanged;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProfileNumberSettingsDialog(
      {Key key, this.user, this.scaffoldKey, this.onChanged})
      : super(key: key);

  @override
  _ProfileNumberSettingsDialogState createState() =>
      _ProfileNumberSettingsDialogState();
}

class _ProfileNumberSettingsDialogState
    extends State<ProfileNumberSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  String number = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      S.of(context).profile_settings,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: '+971 26 229 9765',
                              labelText: S.of(context).phone),
                          initialValue: widget.user.phone,
                          validator: (input) => input.trim().length < 10
                              ? S.of(context).not_a_valid_phone
                              : null,
                          onChanged: (value) {
                            setState(() {
                              number = value;
                            });
                          },
                          onSaved: (input) => widget.user.phone = input,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).cancel),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (_profileSettingsFormKey.currentState.validate()) {
                            if (number != widget.user.phone && number != '') {
                              /*  await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: number,
                                timeout: const Duration(seconds: 30),
                                verificationCompleted: (_) {},
                                verificationFailed: (_) {},
                                codeSent: (ver, _) {
                                  print(ver);
                                },
                                codeAutoRetrievalTimeout: (_) {},
                              ); */
                              Navigator.of(context).pop();
                              currentUser.value.verifiedPhone = false;
                              var bottomSheetController = widget
                                  .scaffoldKey.currentState
                                  .showBottomSheet(
                                (context) =>
                                    MobileVerificationBottomSheetWidget(
                                        scaffoldKey: widget.scaffoldKey,
                                        phone: number),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              );
                              bottomSheetController.closed.then((value) {
                                if (currentUser.value.verifiedPhone) _submit();
                              });
                            } else
                              Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          S.of(context).save,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        S.of(context).editNumber,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    widget.user.phone = number;
    widget.onChanged();
  }
}
