import 'dart:async';

import 'package:learnable/models/events.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:learnable/utils/network_util.dart';

class RestAPI {
  static final RestAPI _instance =  RestAPI._internal();

  static const _BASE_URL = "https://api.learnable.ch/api/auth/";

  static const _AUTH_URL = _BASE_URL+"login";
  static const _LOGOUT_URL = _BASE_URL+"logout";
  static const _GET_LOGGED_IN_USER = _BASE_URL + "user";
  static const _GET_EVENTS_URL = _BASE_URL+"events";
  static const _GET_EVENT_TYPES_URL = _BASE_URL+"event_types";
  static const _GET_LESSONS_URL = _BASE_URL+"lessons";
  static const _GET_CLASSES_URL = _BASE_URL+"classes";
  static const _GET_SCHOOLS_URL = _BASE_URL+"schools";
  static const _GET_COURSES_URL = _BASE_URL+"courses";
  static const _GET_CLASS_MEMBERS_URL = _BASE_URL+"classmembers";
  static const _GET_EVENT_MEMBERS = _BASE_URL+"eventmembers";


  static Map<String, String> headers = Map();

  final NetworkUtil _netUtil = NetworkUtil();

  factory RestAPI() => _instance;

  RestAPI._internal();

  Future login(String query, String password, int rememberMe) {
    Map<String, String> body = Map();

    body['email'] = query;
    body['password'] = password;
    body['remember_me'] = '$rememberMe';

    return _netUtil.post(_AUTH_URL, body: body).then((dynamic res){
      //if(res["error"]) throw Exception(res["error_msg"]);

      headers["Authorization"] = "Bearer ${res["access_token"]}";

      return;
    });
  }

  void logout(){
    _netUtil.get(_LOGOUT_URL);
  }
  
  Future<User> getLoggedInUser() async {
    return _netUtil.get(
      _GET_LOGGED_IN_USER,
      headers: headers
    ).then((dynamic res){
      //if(res["error"]) throw Exception(res["error"]);
      return User.fromMap(res);
    });
  }



  Future<Map<int, Class>> getUserClasses() async {
    return _netUtil.get(
      _GET_CLASSES_URL
    ).then((dynamic res){
      Map<int, Class> map = Map();

      for (var row in res){
        Class c = Class();
        c.initializeAsyncFromMap(row);
        map[c.id] = c;
      }

      return map;
    });
  }

  Future<Map<int, Event>> getUserEvents() async {
    return _netUtil.get(
      _GET_EVENTS_URL
    ).then((dynamic res){
      Map<int, Event> map = Map();
      for (var row in res){
        Event e = Event();
        e.initializeAsyncFromMap(row);
        map[e.id] = e;
      }
      return map;
    });
  }

  Future<Event> getEventById(int id) async {
    var url = "$_GET_EVENTS_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res) async {
      var e = Event();
      await e.initializeAsyncFromMap(res);
      return e;
    });
  }
  
  Future<School> getSchoolById(int id) async {
    var url = "$_GET_SCHOOLS_URL/$id";
    return _netUtil.get(
      url
    ).then((dynamic res) async {
      var s = School();
      await s.initializeAsyncFromMap(res);
      return s;
    });
  }

  Future<Course> getCourseById(int id) async {
    var url = "$_GET_COURSES_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res){
      return Course.fromMap(res);
    });
  }

  Future<Class> getClassById(int id) async {
    var url = "$_GET_CLASSES_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res) async {
      var c = Class();
      await c.initializeAsyncFromMap(res);
      return c;
    });
  }

  Future<Lesson> getLessonById(int id) async {
    var url = "$_GET_LESSONS_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res) async {
      var l = Lesson();
      await l.initializeAsyncFromMap(res);
      return l;
    });
  }

  Future<EventType> getEventTypeById(int id) async {
    var url = "$_GET_EVENT_TYPES_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res){
      return EventType.fromMap(res);
    });
  }
}