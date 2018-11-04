import 'dart:async';

import 'package:learnable/models/events.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:learnable/utils/network_util.dart';
import 'package:learnable/utils/preference_util.dart';

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
  static const _GET_EVENT_MEMBERS_URL = _BASE_URL+"eventmembers";
  static const _GET_TEACHERS_URL = _BASE_URL+"teachers";
  static const _GET_MEMBERS_URL = _BASE_URL+"users";


  static Map<String, String> headers = Map();

  final NetworkUtil _netUtil = NetworkUtil();

  factory RestAPI() => _instance;

  RestAPI._internal(){
    Pretender().getString("Authorization").then((token) => headers["Authorization"] = token);
  }

  Future login(String query, String password, int rememberMe) {
    Map<String, String> body = Map();

    body['email'] = query;
    body['password'] = password;
    body['remember_me'] = '$rememberMe';

    return _netUtil.post(_AUTH_URL, body: body).then((dynamic res) async {
      //if(res["error"]) throw Exception(res["error_msg"]);

      String token = "Bearer ${res["access_token"]}";
      headers["Authorization"] = token;
      Pretender().putString("Authorization", token);

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

  Future<Map<int, Class>> getClasses() async {
    return _netUtil.get(
        _GET_CLASSES_URL,
        headers: headers
    ).then((dynamic res){
      Map<int, Class> map = Map();

      for (var row in res){
        Class c = Class(row).fromMap();
        map[c.id] = c;
      }

      return map;
    });
  }

  Future<Map<int, Event>> getEvents() async {
    return _netUtil.get(
        _GET_EVENTS_URL,
        headers: headers
    ).then((dynamic res){
      Map<int, Event> map = Map();
      for (var row in res){
        Event e = Event(row["event"]).fromMap();
        map[e.id] = e;
      }
      return map;
    });
  }

  Future<Map<int, EventType>> getEventTypes() async {
    return _netUtil.get(
      _GET_EVENT_TYPES_URL,
      headers: headers
    ).then((dynamic res) {
      Map<int, EventType> map = Map();
      for (var row in res){
        EventType e = EventType(row).fromMap();
        map[e.id] = e;
      }
      return map;
    });
  }

  Future<Map<int, Lesson>> getLessons() async {
    return _netUtil.get(
      _GET_LESSONS_URL,
      headers: headers
    ).then((dynamic res) {
      Map<int, Lesson> map = Map();
      for (var row in res){
        Lesson l = Lesson(row).fromMap();
        map[l.id] = l;
      }
      return map;
    });
  }

  Future<Map<int, School>> getSchools() async {
    return _netUtil.get(
      _GET_SCHOOLS_URL,
      headers: headers
    ).then((dynamic res) {
      Map<int, School> map = Map();
      for (var row in res){
        School s = School(row).fromMap();
        map[s.id] = s;
      }
      return map;
    });
  }

  Future<Map<int, Course>> getCourses() async {
    return _netUtil.get(
        _GET_COURSES_URL,
        headers: headers
    ).then((dynamic res) {
      Map<int, Course> map = Map();
      for (var row in res){
        Course c = Course(row).fromMap();
        map[c.id] = c;
      }
      return map;
    });
  }

  Future<Map<int, Teacher>> getTeachers() async {
    return _netUtil.get(
        _GET_TEACHERS_URL,
        headers: headers
    ).then((dynamic res) {
      Map<int, Teacher> map = Map();
      for (var row in res){
        Teacher t = Teacher(row).fromMap();
        map[t.id] = t;
      }
      return map;
    });
  }

  Future<Event> getEventById(int id) async {
    var url = "$_GET_EVENTS_URL/$id";
    return _netUtil.get(
        url,
        headers: headers
    ).then((dynamic res) async {
      var e = Event(res).fromMap();
      return e;
    });
  }
  
  Future<School> getSchoolById(int id) async {
    var url = "$_GET_SCHOOLS_URL/$id";
    return _netUtil.get(
        url,
        headers: headers
    ).then((dynamic res) async {
      return School(res).fromMap();
    });
  }

  Future<Course> getCourseById(int id) async {
    var url = "$_GET_COURSES_URL/$id";
    return _netUtil.get(
        url,
        headers: headers
    ).then((dynamic res){
      return Course(res).fromMap();
    });
  }

  Future<Class> getClassById(int id) async {
    var url = "$_GET_CLASSES_URL/$id";
    return _netUtil.get(
        url,
        headers: headers
    ).then((dynamic res) async {
      var c = Class(res).fromMap();
      return c;
    });
  }

  Future<Map<int, Member>> getClassMembers(int classId) async {
    return _netUtil.get(
      "$_GET_CLASS_MEMBERS_URL/class/$classId",
      headers: headers
    ).then((dynamic res) {
      Map<int, Member> map = Map();
      for (var row in res){
        var members = row["members"];
        for (var member in members){
          Member m = Member(member["user"]).fromMap();
          map[m.id] = m;
        }
      }
      print(res);
      return map;
    });
  }

  Future<Member> getMemberById(int id) async {
    var url = "$_GET_MEMBERS_URL/$id";
    return _netUtil.get(
      url,
      headers: headers
    ).then((res) => Member(res).fromMap());
  }

  Future<EventType> getEventTypeById(int id) async {
    var url = "$_GET_EVENT_TYPES_URL/$id";
    return _netUtil.get(
        url,
        headers: headers
    ).then((res) => EventType(res).fromMap());
  }

  Future<Lesson> getLessonById(int id) async {
    var url = "$_GET_LESSONS_URL/$id";
    return _netUtil.get(
      url,
      headers: headers
    ).then((res) => Lesson(res).fromMap());
  }

  Future<Teacher> getTeacherById(int id) async {
    var url = "$_GET_TEACHERS_URL/$id";
    return _netUtil.get(
        url,
        headers: headers
    ).then((dynamic res) => Teacher(res).fromMap());
  }
}