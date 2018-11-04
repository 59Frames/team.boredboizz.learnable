import 'dart:async';

import 'package:learnable/auth.dart';
import 'package:learnable/data/database_helper.dart';
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/ui/logic/login_screen_presenter.dart';
import 'package:learnable/color_config.dart' as colorConfig;
import 'package:learnable/utils/network_util.dart';

final localizations = AppLocalizations();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginScreenContract {

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _q, _password;

  LoginScreenPresenter _presenter;

  _LoginPageState() {
    _presenter = LoginScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {

    final assetsImage = AssetImage('assets/images/axolotl.png');
    final axolotlImage = Image(image: assetsImage);

    var loginBtn = InkWell(
        onTap: _submit,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: colorConfig.PRIMARY_COLOR_DARK,
              border: Border.all(
                  color: colorConfig.PRIMARY_COLOR_DARK,
                  width: 2.0
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          child: Text(
            localizations.signIn,
            style: TextStyle(
                color: colorConfig.BRIGHT_FONT_COLOR,
                fontSize: 16.0
            ),
          ),
        )
    );

    var loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        axolotlImage,
        Text(
          localizations.signInToLearnable,
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: colorConfig.PRIMARY_COLOR_DARK
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            autovalidate: true,
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: colorConfig.PAGE_BACKGROUND_COLOR.withRed(colorConfig.PAGE_BACKGROUND_COLOR.red+8).withGreen(colorConfig.PAGE_BACKGROUND_COLOR.green+8).withBlue(colorConfig.PAGE_BACKGROUND_COLOR.blue+8)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) => _q = val,
                    validator: _validateEmail,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: colorConfig.DARK_FONT_COLOR,
                      decorationColor: colorConfig.DARK_FONT_COLOR
                    ),
                    decoration: InputDecoration(
                      labelText: localizations.email,
                      labelStyle: TextStyle(
                        color: colorConfig.DARK_FONT_COLOR,
                      ),
                      icon: Icon(Icons.email, color: colorConfig.PRIMARY_COLOR_DARK,),
                      errorStyle: TextStyle(
                        color: colorConfig.BAD_COLOR,
                      ),
                      errorMaxLines: 2,
                      border: InputBorder.none
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorConfig.PAGE_BACKGROUND_COLOR.withRed(colorConfig.PAGE_BACKGROUND_COLOR.red+8).withGreen(colorConfig.PAGE_BACKGROUND_COLOR.green+8).withBlue(colorConfig.PAGE_BACKGROUND_COLOR.blue+8)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onSaved: (val) => _password = val,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: colorConfig.DARK_FONT_COLOR
                    ),
                    decoration: InputDecoration(
                      labelText: localizations.password,
                      labelStyle: TextStyle(
                        color: colorConfig.DARK_FONT_COLOR,
                      ),
                      icon: Icon(Icons.fingerprint, color: colorConfig.PRIMARY_COLOR_DARK,),
                      border: InputBorder.none
                    ),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        _isLoading ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorConfig.PRIMARY_COLOR_DARK),
        ) : loginBtn
      ],
    );

    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      backgroundColor: colorConfig.PAGE_BACKGROUND_COLOR,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: loginForm,
          ),
        ),
      ),
    );
  }

  void _submit() {
    formKey.currentState.save();
    final form = formKey.currentState;

    if(NetworkUtil().isConnected){
      if(form.validate()){
        setState(() => _isLoading = true);
        form.save();
        _presenter.doLogin(_q, _password, 0);
      }
    } else {
      onLoginError(AppLocalizations().isOffline);
    }
  }

  void _showSnackBar(String text){
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: colorConfig.PRIMARY_COLOR_DARK,
      )
    );
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return localizations.enterValidEmail;
    else
      return null;
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(error);
    setState(() => _isLoading = false);
  }

  @override
  Future onLoginSuccess() async {
    _showSnackBar("${User().email} ${localizations.successfullySignedIn}");
    var db = DatabaseHelper();
    await db.deleteUser();
    await db.saveUser();
    setState(() => _isLoading = false);
    CachedBase().setUp().then((n){
      Navigator.of(context).pushReplacementNamed("/home");
    });
    AuthStateProvider().notify(AuthState.LOGGED_IN);
  }
}

