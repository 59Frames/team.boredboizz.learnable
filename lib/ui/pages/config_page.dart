import 'package:learnable/auth.dart';
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/data/rest_api.dart';
import 'package:learnable/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> implements BaseNotifier, AuthStateListener {

  var authStateProvider = AuthStateProvider();

  _ConfigPageState(){
    authStateProvider.subscribe(this);
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations().applicationName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  _setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var languageCode = prefs.getString("languageCode");
    AppLocalizations().setLanguageCode(languageCode != null ? languageCode : 'de');

    RestAPI();
  }

  @override
  void onLocalDataHasBeenLoaded() {
    print("Database is ready to use");
    try {
      Navigator.of(context).pushReplacementNamed("/home");
    } catch (exception) { print(exception.toString()); }
  }

  @override
  void onAuthStateChanged(AuthState state) {
    try {
      if (state == AuthState.LOGGED_IN){
        CachedBase().addNotifier(this);
        CachedBase().build();
      }
      else
        Navigator.of(context).pushReplacementNamed("/login");
    } catch (exception) { print(exception.toString()); }
  }
}
