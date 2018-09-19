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
    var loginBtn = RaisedButton(
      padding: const EdgeInsets.all(16.0),
      onPressed: _submit,
      child: Text(
        localizations.signIn,
        style: TextStyle(
            color: colorConfig.PRIMARY_ICON_COLOR
        ),
      ),
      color: colorConfig.PRIMARY_COLOR_LIGHT,
    );

    var loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          localizations.signInToLearnable,
          style: TextStyle(
              fontSize: 24.0,
              color: colorConfig.PRIMARY_ICON_COLOR
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: colorConfig.PRIMARY_COLOR.withRed(colorConfig.PRIMARY_COLOR.red+8).withGreen(colorConfig.PRIMARY_COLOR.green+8).withBlue(colorConfig.PRIMARY_COLOR.blue+8)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onSaved: (val) => _q = val,
                    validator: (val) {
                      return val.length < 4
                          ? localizations.usernameOrEmailMustHaveAtLeastForCharacters
                          : null;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      color: colorConfig.PRIMARY_ICON_COLOR,
                      decorationColor: colorConfig.PRIMARY_ICON_COLOR
                    ),
                    decoration: InputDecoration(
                      labelText: localizations.usernameOrEmail,
                      labelStyle: TextStyle(
                        color: colorConfig.PRIMARY_ICON_COLOR,
                      ),
                      icon: Icon(Icons.email, color: colorConfig.PRIMARY_ICON_COLOR,),
                      errorStyle: TextStyle(
                        color: colorConfig.PRIMARY_ICON_COLOR,
                      ),
                      border: InputBorder.none
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorConfig.PRIMARY_COLOR.withRed(colorConfig.PRIMARY_COLOR.red+8).withGreen(colorConfig.PRIMARY_COLOR.green+8).withBlue(colorConfig.PRIMARY_COLOR.blue+8)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onSaved: (val) => _password = val,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: colorConfig.PRIMARY_ICON_COLOR
                    ),
                    decoration: InputDecoration(
                      labelText: localizations.password,
                      labelStyle: TextStyle(
                        color: colorConfig.PRIMARY_ICON_COLOR,
                      ),
                      icon: Icon(Icons.fingerprint, color: colorConfig.PRIMARY_ICON_COLOR,),
                      border: InputBorder.none
                    ),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        _isLoading ? CircularProgressIndicator() : loginBtn
      ],
    );

    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      backgroundColor: colorConfig.PRIMARY_COLOR,
      body: Container(
        child: Center(
          child: loginForm,
        ),
      ),
    );
  }

  void _submit() {
    final form = formKey.currentState;

    if(form.validate()){
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_q, _password, 0);
    }
  }

  void _showSnackBar(String text){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
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
    CachedBase().setUp().then((n){
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed("/home");
    });
    setState(() => _isLoading = false);
    AuthStateProvider().notify(AuthState.LOGGED_IN);
  }
}

