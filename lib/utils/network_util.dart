import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

enum NetworkState {ONLINE, OFFLINE}

abstract class NetworkStateListener {
  void onNetworkStateChanged(NetworkState state);
}

class NetworkUtil {

  NetworkState _state;

  static NetworkUtil _instance = NetworkUtil._internal();
  List<NetworkStateListener> _subscribers;

  NetworkUtil._internal(){
    _subscribers = List();
  }

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = JsonDecoder();

  bool isConnected = false;
  var _subscription;

  Future<dynamic> get(String url, {Map<String, String> headers}){
    if (isConnected){
      return http.get(url, headers: headers).then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw Exception("Error while fetching data");
        }

        return _decoder.convert(res);
      });
    } else throw Exception("Error while fetching data. Device is not online");
  }

  Future<dynamic> post (String url, {Map<String, String> headers, body, encoding}){
    if (isConnected){
      return http.post(url, body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw Exception("Error while fetching data");
        }

        return _decoder.convert(res);
      }).catchError((error){
        print(error);
      });
    } else throw Exception("Error while fetching data. Device is not online");
  }

  void subscribe(NetworkStateListener subscriber){
    _subscribers.add(subscriber);
  }

  void activateConnectionSubscription(){
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isConnected = result == ConnectivityResult.none
          ? false
          : true;

      if(!isConnected){
        this._state = NetworkState.OFFLINE;
        notify(NetworkState.OFFLINE);
      } else {
        this._state = NetworkState.ONLINE;
        notify(NetworkState.ONLINE);
      }
    });
  }

  void dispose(){
    _subscription.cancel();
  }

  void notify(NetworkState state){
    print("changing network state to ${state.toString()}");
    _subscribers.forEach((NetworkStateListener s) => s.onNetworkStateChanged(state));
  }
}