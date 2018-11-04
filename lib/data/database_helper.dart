import 'dart:async';
import 'dart:io' as io;

import 'package:learnable/models/classmodel.dart';
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
        "CREATE TABLE courses(id int PRIMARY KEY , title varchar(127) , short varchar(7) );"
    );

    await db.execute(
        "CREATE TABLE event_types(id int PRIMARY KEY , type varchar(31) );"
    );

    await db.execute(
        "CREATE TABLE schools(id int PRIMARY KEY , location int , title varchar(127) );"
    );

    await db.execute(
      "CREATE TABLE application_user("
          "id int PRIMARY KEY , "
          "username varchar(255) , "
          "email varchar(255) , "
          "first_name text , "
          "last_name text , "
          "is_teacher tinyint default '0' , "
          "is_admin tinyint default '0' "
          ");"
    );

    await db.execute(
        "CREATE TABLE members("
            "id int PRIMARY KEY , "
            "username varchar(255) , "
            "email varchar(255) , "
            "first_name text , "
            "last_name text  "
            ");"
    );

    await db.execute(
        "CREATE TABLE teachers("
            "id int PRIMARY KEY , "
            "username varchar(255) , "
            "email varchar(255) , "
            "first_name text , "
            "last_name text  "
            ");"
    );

    await db.execute(
      "CREATE TABLE classes(id int PRIMARY KEY , school int , teacher int , title varchar(31) );"
    );

    await db.execute(
      "CREATE TABLE classmembers(class int , pupil int , PRIMARY KEY (class, pupil));"
    );

    await db.execute(
      "CREATE TABLE lessons("
          "id int PRIMARY KEY , "
          "course int , "
          "class int , "
          "teacher int , "
          "start_lesson int , "
          "duration int , "
          "room varchar(127) , "
          "start datetime , "
          "end datetime , "
          "week int "
          ");"
    );

    await db.execute(
      "CREATE TABLE events("
          "id int PRIMARY KEY , "
          "type int , "
          "lesson int , "
          "creator int , "
          "title varchar(127) , "
          "description text"
          ");"
    );
    
    await db.execute(
      "CREATE TABLE eventmembers(user int , event int , PRIMARY KEY (user, event));"
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

  Future saveAllLearnableObjects(String table, Map<int, LearnableObject> map) async {
    map.forEach((id, object) async {
      return object.persist();
    });
  }

  Future saveToIntermediateTable(String table, String fieldOne, String fieldTwo, int a, int b) async {
    _updateOrInsertIntermediate(table, fieldOne, fieldTwo, a, b);
  }

  Future _updateOrInsert(String table, LearnableObject object) async {
    if (object.id == null)
      throw Exception("LearnableObject id is null");

    var dbClient = await db;
    return containsObject(table, object.id).then((v) {
      return v
          ? dbClient.update(table, object.toMap(), where: "id = ?", whereArgs: [object.id])
          : dbClient.insert(table, object.toMap());
    });
  }

  Future _updateOrInsertIntermediate(String table, String fieldOne, String fieldTwo, int a, int b) async {
    if (a == null || b == null)
      throw Exception("key is null");

    var dbClient = await db;
    return containsDoubleKeyObject(table, fieldOne, fieldTwo, a, b).then((v) {
      Map<String, int> map = new Map();
      map[fieldOne] = a;
      map[fieldTwo] = b;
      return v
          ? dbClient.update(table, map, where: "$fieldOne = ? and $fieldTwo", whereArgs: [a, b])
          : dbClient.insert(table, map);
    });
  }

  Future deleteAll(String table) async {
    var dbClient = await db;
    dbClient.delete(table);
    return;
  }

  Future<Map<int, School>> getAllSchools() async {
    var dbClient = await db;
    Map<int, School> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "schools"');
    if(res.length > 0){
      School s;
      for (Map row in res){
        s = School(row).fromMap();
        map[s.id] = s;
      }
    }

    return map;
  }

  Future<Map<int, Teacher>> getAllTeachers() async {
    var dbClient = await db;
    Map<int, Teacher> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "teachers"');
    if(res.length > 0){
      Teacher t;
      for (Map row in res){
        t = Teacher(row).fromMap();
        map[t.id] = t;
      }
    }

    return map;
  }

  Future<Map<int, Class>> getAllClasses() async {
    var dbClient = await db;
    Map<int, Class> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "classes"');
    if(res.length > 0){
      Class c;
      for (Map row in res){
        c = Class(row).fromMap();
        map[c.id] = c;
      }
    }

    return map;
  }

  Future<Map<int, Course>> getAllCourses() async {
    var dbClient = await db;
    Map<int, Course> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "courses"');
    if(res.length > 0){
      Course c;
      for (Map row in res){
        c = Course(row).fromMap();
        map[c.id] = c;
      }
    }

    return map;
  }

  Future<Map<int, Lesson>> getAllLessons() async {
    var dbClient = await db;
    Map<int, Lesson> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "lessons"');
    if(res.length > 0){
      Lesson l;
      for (Map row in res){
        l = Lesson(row).fromMap();
        map[l.id] = l;
      }
    }

    return map;
  }

  Future<Map<int, Event>> getAllEvents() async {
    var dbClient = await db;
    Map<int, Event> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "events"');
    if(res.length > 0){
      Event e;
      for (Map row in res){
        e = Event(row).fromMap();
        map[e.id] = e;
      }
    }

    return map;
  }

  Future<Map<int, EventType>> getAllEventTypes() async {
    var dbClient = await db;
    Map<int, EventType> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "event_types"');
    if(res.length > 0){
      EventType e;
      for (Map row in res){
        e = EventType(row).fromMap();
        map[e.id] = e;
      }
    }

    return map;
  }

  Future<Map<int, Member>> getAllMembers() async {
    var dbClient = await db;
    Map<int, Member> map = Map();

    List<Map> res = await dbClient.rawQuery('SELECT * FROM "members"');
    if(res.length > 0){
      Member m;
      for (Map row in res){
        m = Member(row).fromMap();
        map[m.id] = m;
      }
    }

    return map;
  }

  Future<Map<int, Member>> getAllClassMembers(int classId) async {
    var dbClient = await db;
    Map<int, Member> map = Map();

    List<Map> res = await dbClient.query('classmembers', where: 'class = ?', whereArgs: [classId]);
    if(res.length > 0){
      Member m;
      for (Map row in res){
        m = Member(row).fromMap();
        map[m.id] = m;
      }
    }

    return map;
  }

  Future saveLearnableObject(String table, LearnableObject learnable) async {
    return _updateOrInsert(table, learnable);
  }

  Future<bool> containsObject(String table, int id) async {
    if (id == null)
      throw Exception("id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query(table, where: "id = ?", whereArgs: [id]);

    return res.length > 0;
  }

  Future<bool> containsDoubleKeyObject(String table, String fieldOne, String fieldTwo, int a, int b) async {
    if (a == null || b == null)
      throw Exception("key is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query(table, where: "$fieldOne = ? and $fieldTwo = ?", whereArgs: [a, b]);

    return res.length > 0;
  }

  Future<Member> getMemberById(int id) async {
    if (id == null)
      throw Exception("Member id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("members", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return Member(res.first).fromMap();
    return null;
  }

  Future<School> getSchoolById(int id) async {
    if (id == null)
      throw Exception("School id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("schools", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      return School(res.first).fromMap();
    }
    return null;
  }

  Future<Teacher> getTeacherById(int id) async {
    if (id == null)
      throw Exception("Teacher id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("teachers", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return Teacher(res.first).fromMap();
    return null;
  }

  Future<Course> getCourseById(int id) async {
    if (id == null)
      throw Exception("Course id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("courses", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return Course(res.first).fromMap();
    return null;
  }

  Future<Class> getClassById(int id) async {
    if (id == null)
      throw Exception("Class is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("classes", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var c = Class(res.first).fromMap();
      return c;
    }
    return null;
  }

  Future<Lesson> getLessonById(int id) async {
    if (id == null)
      throw Exception("Lesson id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("lessons", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var l = Lesson(res.first).fromMap();
      return l;
    }
    return null;
  }

  Future<EventType> getEventTypeById(int id) async {
    if (id == null)
      throw Exception("EventType id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("event_types", where: "id = ?", whereArgs: [id]);
    if (res.length > 0)
      return EventType(res.first).fromMap();
    return null;
  }

  Future<Event> getEventById(int id) async {
    if (id == null)
      throw Exception("Event id is null");

    var dbClient = await db;
    List<Map> res = await dbClient.query("events", where: "id = ?", whereArgs: [id]);
    if (res.length > 0) {
      var e = Event(res.first).fromMap();
      return e;
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery('SELECT * FROM "application_user"');
    if (res.length > 0){
      User.fromMap(res.first);
      return true;
    } else {
      return false;
    }
  }
}