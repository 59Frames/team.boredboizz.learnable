import 'dart:async';

import 'package:learnable/models/events.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:learnable/utils/network_util.dart';

class RestAPI {
  static final RestAPI _instance =  RestAPI._internal();

  static const _BASE_URL = "https://api.learnable.ch/api/auth/";

  static const _AUTH_URL = _BASE_URL+"login";
  static const _GET_LOGGED_IN_USER = _BASE_URL + "user";

  static const _DATA_URL = _BASE_URL + "/data";

  static const _TOKEN_URL = _BASE_URL + "/token";
  static const _LOGIN_USER_URL = _BASE_URL + "/login";
  static const _GET_LOCATIONS_URL = _DATA_URL + "/locations";
  static const _GET_SCHOOLS_URL = _DATA_URL + "/schools";
  static const _GET_CLASSES_URL = _DATA_URL + "/classes";
  static const _GET_COURSES_URL = _DATA_URL + "/courses";
  static const _GET_LESSONS_URL = _DATA_URL + "/lessons";
  static const _GET_CLASS_TEACHERS_URL = _GET_LESSONS_URL + "/whereClass";
  static const _GET_LESSONS_BY_DATE_URL = _GET_LESSONS_URL + "/whereDate";
  static const _GET_USER_URL = _DATA_URL + "/users";
  static const _GET_TEACHER_URL = _GET_USER_URL + "/teachers";
  static const _GET_USER_CLASSES_URL = _DATA_URL + "/classmembers/pupil";
  static const _GET_CLASS_MEMBERS_URL = _DATA_URL + "/classmembers/class";
  static const _GET_EVENTS_URL = _DATA_URL + "/events";
  static const _GET_EVENT_TYPES_URL = _DATA_URL + "/event_types";
  static const _GET_EVENT_MEMBERS_URL = _DATA_URL + "/eventmembers";

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
  
  Future<User> getLoggedInUser() async {
    return _netUtil.get(
      _GET_LOGGED_IN_USER,
      headers: headers
    ).then((dynamic res){
      //if(res["error"]) throw Exception(res["error"]);
      return User.fromMap(res);
    });
  }

  Future<List<int>> getUserClasses(User user) async {
    var url = "$_GET_USER_CLASSES_URL/${user.id}";
    return _netUtil.get(
      url
    ).then((dynamic res){
      List<int> list = List();

      for (var row in res){
        list.add(row['class']);
      }

      return list;
    });
  }

  Future<List<int>> getClassTeachers(int id) async {
    var url = "$_GET_CLASS_TEACHERS_URL/$id";
    return _netUtil.get(
      url
    ).then((dynamic res){
      List<int> list = List();

      for (var row in res){
        list.add(row['teacher']);
      }

      return list;
    });
  }

  Future<Map<int, Lesson>> getClassLessons(int id) async {
    var url = "$_GET_CLASS_TEACHERS_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res){
      Map<int, Lesson> map = Map();

      for (var row in res){
        var l = Lesson();
        l.initializeAsyncFromMap(row);
        map[l.id] = l;
      }

      return map;
    });
  }

  Future<Map<int, Lesson>> getLessonsByDate(String date) async {
    var url = "$_GET_LESSONS_BY_DATE_URL/$date";
    return _netUtil.get(
        url
    ).then((dynamic res){
      Map<int, Lesson> map = Map();

      for (var row in res){
        var l = Lesson();
        l.initializeAsyncFromMap(row);
        map[l.id] = l;
      }

      return map;
    });
  }

  Future<List<int>> getClassMemberIds(int id) async {
    var url = "$_GET_CLASS_MEMBERS_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res) async {
      List<int> list = List();
      for (var row in res){
        list.add(row['pupil']);
      }
      return list;
    });
  }

  Future<Map<int, Member>> getClassMembers(int id) async {
    var url = "$_GET_CLASS_MEMBERS_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res) async {
      Map<int, Member> members = Map();
      for (var row in res){
        await getMemberById(row['pupil']).then((member) => members[member.id] = member );
      }
      return members;
    });
  }

  Future<List<int>> getUserEvents(User user) async {
    var url = "$_GET_EVENT_MEMBERS_URL/user/${user.id}";
    return _netUtil.get(
      url
    ).then((dynamic res){
      List<int> list = List();
      for (var row in res){
        list.add(row['event']);
      }
      return list;
    });
  }

  Future<Member> getMemberById(int id) async {
    var url = "$_GET_USER_URL/$id";
    return _netUtil.get(
        url
    ).then((dynamic res) async {
      return Member.fromMap(res);
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

  Future<Location> getLocationByZip(int zip) async {
    var url = "$_GET_LOCATIONS_URL/$zip";
    return _netUtil.get(
      url
    ).then((dynamic res){
      return Location.fromMap(res);
    });
  }

  Future<Teacher> getTeacherById(int id) async {
    var url = "$_GET_TEACHER_URL/$id";
    return _netUtil.get(
      url
    ).then((dynamic res){
      return Teacher.fromMap(res);
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