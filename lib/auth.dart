import 'package:learnable/data/cached_base.dart';
import 'package:learnable/data/rest_api.dart';
import 'package:learnable/models/user.dart';

import 'data/database_helper.dart';

enum AuthState {LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

class AuthStateProvider {
  static final AuthStateProvider _instance = AuthStateProvider._internal();

  bool _isLoggedIn = false;
  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;

  AuthStateProvider._internal() {
    _subscribers = List();
    initState();
  }

  void initState() async {
    var db = DatabaseHelper();

    var isLoggedIn = await db.isLoggedIn();

    if (isLoggedIn){
      _isLoggedIn = true;
      notify(AuthState.LOGGED_IN);
    }
    else{
      _isLoggedIn = false;
      notify(AuthState.LOGGED_OUT);
    }
  }

  bool isLoggedIn() {
    return _isLoggedIn;
  }

  void subscribe(AuthStateListener subscriber){
    _subscribers.add(subscriber);
  }

  void dispose(AuthStateListener subscriber){
    for (var s in _subscribers){
      if (s == subscriber)
        _subscribers.remove(s);
    }
  }

  void notify(AuthState state){
    print("changing auth state to ${state.toString()}");
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }

  void logout(){
    User().reset();
    DatabaseHelper().deleteUser();
    CachedBase().clean();
    RestAPI().logout();
    this.notify(AuthState.LOGGED_OUT);
  }
}