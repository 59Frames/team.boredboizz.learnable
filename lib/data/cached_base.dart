import 'dart:async';

import 'package:learnable/data/database_helper.dart';
import 'package:learnable/utils/network_util.dart';
import 'package:learnable/data/rest_api.dart';
import 'package:learnable/models/events.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:learnable/utils/parse_util.dart' as parser;

final NetworkUtil networkUtil = NetworkUtil();

/// This class is responsible to cache all the data
/// while the application is running for a fast access.
class CachedBase {
  static final CachedBase _instance = new CachedBase._internal();

  factory CachedBase() => _instance;

  /// Data objects
  /// the [_status] contains the base state.
  /// for example on every initialisation it is set to [_BaseStatus.LOADING];
  BaseStatus _status = BaseStatus.OFFLINE;

  /// the [_notifySubscribers] stores a list of [BaseNotifier]
  List<BaseNotifier> _notifySubscribers = List();

  /// booleans to check whether the data structure is done loading
  bool _locationsLoaded = false;
  bool _schoolsLoaded = false;
  bool _teachersLoaded = false;
  bool _classesLoaded = false;
  bool _coursesLoaded = false;
  bool _lessonsLoaded = false;
  bool _eventTypesLoaded = false;
  bool _eventsLoaded = false;
  bool _membersLoaded = false;

  /// User Data Objects
  /// [_locations] stores a map of every location known in switzerland
  Map<int, Location> _locations = Map();

  /// [_schools] stores a map of every dependent school
  Map<int, School> _schools = Map();

  /// [_teachers] stores a map of every dependent teacher
  Map<int, Teacher> _teachers = Map();

  /// [_classes] stores a map of every dependent class
  Map<int, Class> _classes = Map();

  /// [_classMemberIds] stores a map with the classId as a key and a list with the class member ids
  Map<int, List<int>> _classMemberIds = Map();

  /// [_courses] stores a map of every dependent course
  Map<int, Course> _courses = Map();

  /// [_lessons] stores a map of every dependent lesson
  Map<int, Lesson> _lessons = Map();

  /// [_eventTypes] stores a map of every dependent eventType
  Map<int, EventType> _eventTypes = Map();

  /// [_events] stores a map of every dependent event
  Map<int, Event> _events = Map();

  /// [_members] stores a map of every dependent Member the user has to deal with
  Map<int, Member> _members = Map();


  /// Creates an EssenceBase instance
  CachedBase._internal();

  /// Builds the database and calls [_notifyReadyToUse] if has been loaded
  void build() async {
    print("loading Database");
    _status = BaseStatus.LOADING;
    await _loadData().then((n){
      _status = BaseStatus.ONLINE;
      _notifyReadyToUse();
      return;
    });
  }

  /// Loads the data from the local database and or server
  Future<Null> _loadData() async {
    await DatabaseHelper().getAllCourses().then((map) async {
      _courses = map;
      _coursesLoaded = true;
    });
    await DatabaseHelper().getAllEventTypes().then((map) async{
      _eventTypes = map;
      _eventTypesLoaded = true;
    });
    await DatabaseHelper().getAllLocations().then((map) async {
      _locations = map;
      _locationsLoaded = true;
    });
    await DatabaseHelper().getAllSchools().then((map) async {
      _schools = map;
      _schoolsLoaded = true;
    });
    await DatabaseHelper().getAllTeachers().then((map) async {
      _teachers = map;
      _teachersLoaded = true;
    });
    await DatabaseHelper().getAllMembers().then((map) async {
      _members = map;
      _membersLoaded = true;
    });
    await DatabaseHelper().getAllClasses().then((map) async {
      _classes = map;
      _classesLoaded = true;
    });
    await DatabaseHelper().getAllLessons().then((map) async {
      _lessons = map;
      _lessonsLoaded = true;
    });
    await DatabaseHelper().getAllEvents().then((map) async {
      _events = map;
      _eventsLoaded = true;
    });

    print("Data structure loaded");
    return null;
  }

  /// Gets called when a new User has logged in to load every user dependent Data
  Future<Null> setUp() async {
//    await RestAPI().getUserClasses(User()).then((List<int> list) async {
//       for (int clazz in list){
//         await RestAPI().getClassById(clazz).then((_clazz){
//           _classes[_clazz.id] = _clazz;
//           return _clazz;
//         });
//
//         await getClassLessons(clazz);
//       }
//    });
//
//    await RestAPI().getUserEvents(User()).then((List<int> list) async {
//      for (int event in list){
//        await RestAPI().getEventById(event).then((event){
//          _events[event.id] = event;
//          return event;
//        });
//      }
//    });
//
    return null;
  }

  /// returns the [_events] map
  Map<int, Event> getEventMap() => _events;

  /// returns the [_classes] map
  Map<int, Class> getClassMap() => _classes;

  /// adds an [BaseNotifier] to the [_notifySubscribers] list
  void addNotifier(BaseNotifier notifier){
    _notifySubscribers.add(notifier);
  }

  /// notifies every [BaseNotifier] in [_notifySubscribers]
  /// if [_locationsLoaded] == true &&
  /// [_coursesLoaded] == true &&
  /// [_eventsLoaded] == true &&
  /// [_classesLoaded] == true &&
  /// [_schoolsLoaded] == true &&
  /// [_lessonsLoaded] == true &&
  /// [_teachersLoaded] == true &&
  /// [_eventTypesLoaded] == true
  void _notifyReadyToUse(){
    if (_notifySubscribers.length > 0){
      if (_locationsLoaded
          && _coursesLoaded
          && _eventsLoaded
          && _classesLoaded
          && _schoolsLoaded
          && _lessonsLoaded
          && _teachersLoaded
          && _eventTypesLoaded
          && _membersLoaded){
        for (var n in _notifySubscribers)
          n.onLocalDataHasBeenLoaded();
      }
    }
  }

  Future<Map<int, Lesson>> getClassLessons(int id) async {
    return null;
  }

  Future<Map<int, Member>> getClassMembers(int id) async {
    return null;
  }

  Future<Map<int, Teacher>> getClassTeachers(int id) async {
    return null;
  }

  Future<Member> getMemberById(int id) async {
    return null;
  }

  Future<Location> getLocationByZip(int zip) async {
    return null;
  }

  Future<School> getSchoolById(int id) async {
    return null;
  }

  Future<Teacher> getTeacherById(int id) async {
    return null;
  }

  Future<Course> getCourseById(int id) async {
    return null;
  }

  Future<Class> getClassById(int id) async {
    return null;
  }

  Future<Lesson> getLessonById(int id) async {
    return null;
  }

  Future<EventType> getEventTypeById(int id) async {
    return null;
  }

  Future<Event> getEventById(int id) async {
    return null;
  }

  List<Lesson> getLocalLessonsByDate(DateTime date) {
    return null;
  }

  Future<List<Lesson>> getLessonsByDate(DateTime date) async {
    return null;
  }

  bool isOnline() => _status == BaseStatus.ONLINE;

  void persist() async {
    if (this.isOnline()){
      print("persisting data");
      await deleteDataFromLocalDatabase();
      DatabaseHelper().saveAllCourses(_courses);
      DatabaseHelper().saveAllLocations(_locations);
      DatabaseHelper().saveAllSchools(_schools);
      DatabaseHelper().saveAllTeachers(_teachers);
      DatabaseHelper().saveAllMembers(_members);
      DatabaseHelper().saveAllClasses(_classes);
      DatabaseHelper().saveAllLessons(_lessons);
      DatabaseHelper().saveAllEventTypes(_eventTypes);
      DatabaseHelper().saveAllEvents(_events);
      print("data persisted");
    }
  }

  deleteDataFromLocalDatabase() async {
    await DatabaseHelper().deleteAllEvents();
    await DatabaseHelper().deleteAllTeachers();
    await DatabaseHelper().deleteAllMembers();
    await DatabaseHelper().deleteAllLessons();
    await DatabaseHelper().deleteAllCourses();
    await DatabaseHelper().deleteAllClasses();
    await DatabaseHelper().deleteAllEventTypes();
    await DatabaseHelper().deleteAllLocations();
    await DatabaseHelper().deleteAllSchools();
  }

  void clean() {
    _events = Map();
    _teachers = Map();
    _lessons = Map();
    _members = Map();
    _courses = Map();
    _classes = Map();
    _locations = Map();
    _eventTypes = Map();
    _schools = Map();
    deleteDataFromLocalDatabase();
  }

}

enum BaseStatus {
  LOADING, ONLINE, OFFLINE
}

abstract class BaseNotifier {
  void onLocalDataHasBeenLoaded();
}