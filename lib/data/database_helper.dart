import 'dart:async';
import 'dart:io' as io;

import 'package:learnable/models/events.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper._internal();

  static Database _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db == null)
      _db = await initDb();
    return _db;
  }

  initDb() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "coffeefy.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return ourDb;
  }

  void _onCreateDatabase(Database db, int version) async {

    await db.execute(
        "CREATE TABLE courses(id int PRIMARY KEY NOT NULL, title varchar(127) NOT NULL, short varchar(7) NOT NULL);"
    );

    await db.execute(
        "CREATE TABLE event_types(id int PRIMARY KEY NOT NULL, type varchar(31) NOT NULL);"
    );

    await db.execute(
        "CREATE TABLE locations(zip int PRIMARY KEY NOT NULL, place varchar(127) NOT NULL);"
    );

    await db.execute(
        "CREATE TABLE schools(id int PRIMARY KEY NOT NULL, location int NOT NULL, title varchar(127) NOT NULL);"
    );

    await db.execute(
      "CREATE TABLE application_user("
          "id int PRIMARY KEY NOT NULL, "
          "username varchar(255) NOT NULL, "
          "email varchar(255) NOT NULL, "
          "first_name text NOT NULL, "
          "last_name text NOT NULL, "
          "is_teacher tinyint default '0' NOT NULL, "
          "is_admin tinyint default '0' NOT NULL"
          ");"
    );

    await db.execute(
        "CREATE TABLE members("
            "id int PRIMARY KEY NOT NULL, "
            "username varchar(255) NOT NULL, "
            "email varchar(255) NOT NULL, "
            "first_name text NOT NULL, "
            "last_name text NOT NULL "
            ");"
    );

    await db.execute(
        "CREATE TABLE teachers("
            "id int PRIMARY KEY NOT NULL, "
            "username varchar(255) NOT NULL, "
            "email varchar(255) NOT NULL, "
            "first_name text NOT NULL, "
            "last_name text NOT NULL "
            ");"
    );

    await db.execute(
      "CREATE TABLE classes(id int PRIMARY KEY NOT NULL, school int NOT NULL, teacher int NOT NULL, title varchar(31) NOT NULL);"
    );

    await db.execute(
      "CREATE TABLE classmembers(class int NOT NULL, pupil int NOT NULL, PRIMARY KEY (class, pupil));"
    );

    await db.execute(
      "CREATE TABLE lessons("
          "id int PRIMARY KEY NOT NULL, "
          "course int NOT NULL, "
          "class int NOT NULL, "
          "teacher int NOT NULL, "
          "start_lesson int NOT NULL, "
          "duration int NOT NULL, "
          "room varchar(127) NOT NULL, "
          "start datetime NOT NULL, "
          "end datetime NOT NULL, "
          "week int NOT NULL"
          ");"
    );

    await db.execute(
      "CREATE TABLE events("
          "id int PRIMARY KEY NOT NULL, "
          "type int NOT NULL, "
          "lesson int NOT NULL, "
          "creator int NOT NULL, "
          "title varchar(127) NOT NULL, "
          "description text"
          ");"
    );
    
    await db.execute(
      "CREATE TABLE eventmembers(user int NOT NULL, event int NOT NULL, PRIMARY KEY (user, event));"
    );

    print("Tables created");
  }

  Future<int> saveUser() async {
    var dbClient = await db;
    return await dbClient.insert("application_user", User().toMap());
  }

  Future<int> deleteUser() async {
    var dbClient = await db;
    return await dbClient.delete("application_user");
  }

  Future<Null> deleteAllLocations() async {
    var dbClient = await db;
    await dbClient.delete("locations");
    return null;
  }

  Future<Map<int, Location>> getAllLocations() async {
    var dbClient = await db;
    Map<int, Location> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "locations"');
    if(res.length > 0){
      Location l;
      for (Map row in res){
        l = Location.fromMap(row);
        map[l.zip] = l;
      }
    }

    return map;
  }

  Future<Null> saveAllLocations(Map<int, Location> locations) async {
    var dbClient = await db;
    locations.forEach((zip, location) async {
      await dbClient.insert("locations", location.toMap());
    });
  }

  Future<Null> deleteAllSchools() async {
    var dbClient = await db;
    await dbClient.delete("schools");
    return null;
  }

  Future<Map<int, School>> getAllSchools() async {
    var dbClient = await db;
    Map<int, School> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "schools"');
    if(res.length > 0){
      School s;
      for (Map row in res){
        s = School();
        await s.initializeAsyncFromMap(row);
        map[s.id] = s;
      }
    }

    return map;
  }

  Future<Null> saveAllSchools(Map<int, School> schools) async {
    var dbClient = await db;
    schools.forEach((zip, school) async {
      await dbClient.insert("schools", school.toMap());
    });
  }

  Future<Null> deleteAllTeachers() async {
    var dbClient = await db;
    await dbClient.delete("teachers");
    return null;
  }

  Future<Map<int, Teacher>> getAllTeachers() async {
    var dbClient = await db;
    Map<int, Teacher> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "teachers"');
    if(res.length > 0){
      Teacher t;
      for (Map row in res){
        t = Teacher.fromMap(row);
        map[t.id] = t;
      }
    }

    return map;
  }

  Future<Null> saveAllTeachers(Map<int, Teacher> teachers) async {
    var dbClient = await db;
    teachers.forEach((id, teacher) async {
      await dbClient.insert("teachers", teacher.toMap());
    });
  }

  Future<Null> deleteAllClasses() async {
    var dbClient = await db;
    await dbClient.delete("classes");
    return null;
  }

  Future<Map<int, Class>> getAllClasses() async {
    var dbClient = await db;
    Map<int, Class> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "classes"');
    if(res.length > 0){
      Class c;
      for (Map row in res){
        c = Class();
        await c.initializeAsyncFromMap(row);
        map[c.id] = c;
      }
    }

    return map;
  }

  Future<Null> saveAllClasses(Map<int, Class> classes) async {
    var dbClient = await db;
    classes.forEach((id, clazz) async {
      await dbClient.insert("classes", clazz.toMap());
    });
  }

  Future<Null> deleteAllCourses() async {
    var dbClient = await db;
    await dbClient.delete("courses");
    return null;
  }

  Future<Map<int, Course>> getAllCourses() async {
    var dbClient = await db;
    Map<int, Course> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "courses"');
    if(res.length > 0){
      Course c;
      for (Map row in res){
        c = Course.fromMap(row);
        map[c.id] = c;
      }
    }

    return map;
  }

  Future<Null> saveAllCourses(Map<int, Course> courses) async {
    var dbClient = await db;
    courses.forEach((id, course) async {
      await dbClient.insert("courses", course.toMap());
    });
  }

  Future<Null> deleteAllLessons() async {
    var dbClient = await db;
    await dbClient.delete("lessons");
    return null;
  }

  Future<Map<int, Lesson>> getAllLessons() async {
    var dbClient = await db;
    Map<int, Lesson> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "lessons"');
    if(res.length > 0){
      Lesson l;
      for (Map row in res){
        l = Lesson();
        await l.initializeAsyncFromMap(row);
        map[l.id] = l;
      }
    }

    return map;
  }

  Future<Null> saveAllLessons(Map<int, Lesson> lessons) async {
    var dbClient = await db;
    lessons.forEach((id, lesson) async {
      await dbClient.insert("lessons", lesson.toMap());
    });
  }

  Future<Null> deleteAllEvents() async {
    var dbClient = await db;
    await dbClient.delete("events");
    return null;
  }

  Future<Map<int, Event>> getAllEvents() async {
    var dbClient = await db;
    Map<int, Event> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "events"');
    if(res.length > 0){
      Event e;
      for (Map row in res){
        e = Event();
        await e.initializeAsyncFromMap(row);
        map[e.id] = e;
      }
    }

    return map;
  }

  Future<Null> saveAllEvents(Map<int, Event> events) async {
    var dbClient = await db;
    events.forEach((id, event) async {
      await dbClient.insert("events", event.toMap());
    });
  }

  Future<Null> deleteAllEventTypes() async {
    var dbClient = await db;
    await dbClient.delete("event_types");
    return null;
  }

  Future<Map<int, EventType>> getAllEventTypes() async {
    var dbClient = await db;
    Map<int, EventType> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "event_types"');
    if(res.length > 0){
      EventType e;
      for (Map row in res){
        e = EventType.fromMap(row);
        map[e.id] = e;
      }
    }

    return map;
  }

  Future<Null> saveAllEventTypes(Map<int, EventType> eventTypes) async {
    var dbClient = await db;
    eventTypes.forEach((id, eventType) async {
      await dbClient.insert("event_types", eventType.toMap());
    });
  }

  Future<Null> deleteAllMembers() async {
    var dbClient = await db;
    await dbClient.delete("members");
    return null;
  }

  Future<Map<int, Member>> getAllMembers() async {
    var dbClient = await db;
    Map<int, Member> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "members"');
    if(res.length > 0){
      Member m;
      for (Map row in res){
        m = Member.fromMap(row);
        map[m.id] = m;
      }
    }

    return map;
  }

  Future<Null> saveAllMembers(Map<int, Member> members) async {
    var dbClient = await db;
    members.forEach((id, member) async {
      await dbClient.insert("members", member.toMap());
    });
  }

  Future<Member> getMemberById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("members", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return Member.fromMap(res.first);
    return null;
  }

  Future<Location> getLocationByZip(int zip) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("locations", where: "zip = ?", whereArgs: [zip]);
    if (res.length > 0)
      return Location.fromMap(res.first);
    return null;
  }

  Future<School> getSchoolById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("schools", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var s = School();
      await s.initializeAsyncFromMap(res.first);
      return s;
    }
    return null;
  }

  Future<Teacher> getTeacherById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("teachers", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return Teacher.fromMap(res.first);
    return null;
  }

  Future<Course> getCourseById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("courses", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return Course.fromMap(res.first);
    return null;
  }

  Future<Class> getClassById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("classes", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var c = Class();
      await c.initializeAsyncFromMap(res.first);
      return c;
    }
    return null;
  }

  Future<Lesson> getLessonById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("lessons", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var l = Lesson();
      await l.initializeAsyncFromMap(res.first);
      return l;
    }
    return null;
  }

  Future<EventType> getEventTypeById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("event_types", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return EventType.fromMap(res.first);
    return null;
  }

  Future<Event> getEventById(int id) async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("events", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var e = Event();
      await e.initializeAsyncFromMap(res.first);
      return e;
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery('SELECT * FROM "application_user"');
    if (res.length > 0){
      new User.fromMap(res.first);
      return true;
    } else {
      return false;
    }
  }
}