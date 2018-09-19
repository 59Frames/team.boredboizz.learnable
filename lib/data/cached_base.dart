import 'dart:async';

import 'package:learnable/data/database_helper.dart';
import 'package:learnable/data/rest_api.dart';
import 'package:learnable/models/events.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:learnable/utils/parse_util.dart' as parser;

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
    return await RestAPI().getClassLessons(id).then((lessons){
      lessons.forEach((id, lesson){
        _lessons[id] = lesson;
      });
    });
  }

  Future<Map<int, Member>> getClassMembers(int id) async {
    return await RestAPI().getClassMemberIds(id).then((memberIds) async {
      Map<int, Member> members = Map();
      for (int id in memberIds){
        await getMemberById(id).then((member){
          members[member.id] = member;
        });
      }
      return members;
    });
  }

  Future<Map<int, Teacher>> getClassTeachers(int id) async {
    return await RestAPI().getClassTeachers(id).then((teacherIds) async {
      var map = Map<int, Teacher>();
      for (int id in teacherIds){
        await getTeacherById(id).then((teacher){
          map[teacher.id] = teacher;
        });
      }
      return map;
    });
  }

  Future<Member> getMemberById(int id) async {
    if (_members.containsKey(id))
      return _members[id];

    return await DatabaseHelper().getMemberById(id).then((member) async {
      if (member != null){
        _members[member.id] = member;
        return member;
      }

      return await RestAPI().getMemberById(id).then((member) {
        _members[member.id] = member;
        return member;
      });
    });
  }

  Future<Location> getLocationByZip(int zip) async {
    if (_locations.containsKey(zip))
      return _locations[zip];

    return await DatabaseHelper().getLocationByZip(zip).then((location) async {
      if (location != null){
        _locations[location.zip] = location;
        return location;
      }

      return await RestAPI().getLocationByZip(zip).then((location) {
        _locations[location.zip] = location;
        return location;
      });
    });
  }

  Future<School> getSchoolById(int id) async {
    if (_schools.containsKey(id))
      return _schools[id];

    return await DatabaseHelper().getSchoolById(id).then((school) async {
      if (school != null){
        _schools[school.id] = school;
        return school;
      }

      return await RestAPI().getSchoolById(id).then((school) {
        _schools[school.id] = school;
        return school;
      });
    });
  }

  Future<Teacher> getTeacherById(int id) async {
    if (_teachers.containsKey(id))
      return _teachers[id];

    return await DatabaseHelper().getTeacherById(id).then((teacher) async {
      if (teacher != null){
        _teachers[teacher.id] = teacher;
        return teacher;
      }

      return await RestAPI().getTeacherById(id).then((teacher) {
        _teachers[teacher.id] = teacher;
        return teacher;
      });
    });
  }

  Future<Course> getCourseById(int id) async {
    if (_courses.containsKey(id))
      return _courses[id];

    return await DatabaseHelper().getCourseById(id).then((course) async {
      if (course != null){
        _courses[course.id] = course;
        return course;
      }

      return await RestAPI().getCourseById(id).then((course) {
        _courses[course.id] = course;
        return course;
      });
    });
  }

  Future<Class> getClassById(int id) async {
    if (_classes.containsKey(id))
      return _classes[id];

    return await DatabaseHelper().getClassById(id).then((clazz) async {
      if (clazz != null){
        _classes[clazz.id] = clazz;
        return clazz;
      }

      return await RestAPI().getClassById(id).then((clazz) {
        _classes[clazz.id] = clazz;
        return clazz;
      });
    });
  }

  Future<Lesson> getLessonById(int id) async {
    if (_lessons.containsKey(id))
      return _lessons[id];

    return await DatabaseHelper().getLessonById(id).then((lesson) async {
      if (lesson != null){
        _lessons[lesson.id] = lesson;
        return lesson;
      }

      return await RestAPI().getLessonById(id).then((lesson) {
        _lessons[lesson.id] = lesson;
        return lesson;
      });
    });
  }

  Future<EventType> getEventTypeById(int id) async {
    if (_eventTypes.containsKey(id))
      return _eventTypes[id];

    return await DatabaseHelper().getEventTypeById(id).then((eventType) async {
      if (eventType != null){
        _eventTypes[eventType.id] = eventType;
        return eventType;
      }

      return await RestAPI().getEventTypeById(id).then((eventType) {
        _eventTypes[eventType.id] = eventType;
        return eventType;
      });
    });
  }

  Future<Event> getEventById(int id) async {
    if (_events.containsKey(id))
      return _events[id];

    return await DatabaseHelper().getEventById(id).then((event) async {
      if (event != null){
        _events[event.id] = event;
        return event;
      }

      return await RestAPI().getEventById(id).then((event) {
        _events[event.id] = event;
        return event;
      });
    });
  }

  List<Lesson> getLocalLessonsByDate(DateTime date) {
    final comparableDate = parser.getNumberedDateString(date);
    final list = <Lesson>[];


    _lessons.forEach((id, lesson){
      if (parser.getNumberedDateString(lesson.start) == comparableDate)
        list.add(lesson);
    });

    return list;
  }

  Future<List<Lesson>> getLessonsByDate(DateTime date) async {
    List<Lesson> returnableList = List();
    return await RestAPI().getLessonsByDate(parser.getNumberedDateString(date)).then((lessonMap) {
      lessonMap.forEach((id, lesson){
        returnableList.add(lesson);
        _lessons[id] = lesson;
      });
      return returnableList;
    });
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

  Future<Null> refreshEventMap() async {
    await RestAPI().getUserEvents(User()).then((List<int> list) async {
      _events.clear();
      for (int event in list){
        await RestAPI().getEventById(event).then((event){
          _events[event.id] = event;
          return event;
        });
      }
    });

    return null;
  }

}

enum BaseStatus {
  LOADING, ONLINE, OFFLINE
}

abstract class BaseNotifier {
  void onLocalDataHasBeenLoaded();
}