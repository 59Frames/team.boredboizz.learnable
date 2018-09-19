import 'package:learnable/data/cached_base.dart';

class Lesson {
  int id;
  Course course;
  Class clazz;
  Teacher teacher;
  int startLesson;
  int duration;
  String room;
  DateTime start;
  DateTime end;
  int week;

  Lesson();

  initializeAsyncFromMap(dynamic obj) async {
    id = obj['id'];
    await CachedBase().getCourseById(obj['course']).then((course) => this.course = course);
    await CachedBase().getClassById(obj['class']).then((clazz) => this.clazz = clazz);
    await CachedBase().getTeacherById(obj['teacher']).then((teacher) => this.teacher = teacher);
    startLesson = obj['start_lesson'];
    duration = obj['duration'];
    room = obj['room'];
    start = DateTime.parse(obj['start']);
    end = DateTime.parse(obj['end']);
    week = obj['week'];

    print("lesson ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['course'] = course.id;
    map['class'] = clazz.id;
    map['teacher'] = teacher.id;
    map['start_lesson'] = startLesson;
    map['duration'] = duration;
    map['room'] = room;
    map['start'] = start.toString();
    map['end'] = end.toString();
    map['week'] = week;
    return map;
  }

}

class Course {
  int id;
  String title;
  String short;

  Course.fromMap(dynamic obj) {
    id = obj['id'];
    title = obj['title'];
    short = obj['short'];


    print("Course ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['short'] = short;
    return map;
  }
}

class Class {
  int id;
  School school;
  Teacher teacher;
  String title;
  Map<int, Member> members;
  Map<int, Teacher> teachers;

  Class();

  initializeAsyncFromMap(dynamic obj) async {
    this.id = obj['id'];
    await CachedBase().getSchoolById(obj['school']).then((school) => this.school = school);
    await CachedBase().getTeacherById(obj['teacher']).then((teacher) => this.teacher = teacher);
    await CachedBase().getClassMembers(this.id).then((members) => this.members = members);
    await CachedBase().getClassTeachers(this.id).then((teachers) => this.teachers = teachers);
    this.title = obj['title'];

    print("Class ${this.id} ${this.toMap()} loaded");
    print("Classmembers: ${this.members}");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['school'] = this.school.id;
    map['teacher'] = this.teacher.id;
    map['title'] = this.title;
    return map;
  }
}

class School {
  int id;
  Location location;
  String title;

  School();

  initializeAsyncFromMap(dynamic obj) async {
    this.id = obj['id'];
    await CachedBase().getLocationByZip(obj['location']).then((location) => this.location = location);
    this.title = obj['title'];

    print("School ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['location'] = this.location.zip;
    map['title'] = this.title;
    return map;
  }
}

class Location {
  int zip;
  String place;

  Location.fromMap(dynamic obj){
    this.zip = obj['zip'];
    this.place = obj['place'];

    print("Location ${this.zip} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['zip'] = this.zip;
    map['place'] = this.place;
    return map;
  }
}

class Teacher {
  int id;
  String email = "";
  String username = "";
  String firstname = "";
  String lastname = "";

  Teacher();

  Teacher.fromMap(dynamic obj){
    this.id = obj['id'];
    this.email = obj['email'];
    this.username = obj['username'];
    this.firstname = obj['first_name'];
    this.lastname = obj['last_name'];

    print("Teacher ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['email'] = this.email;
    map['username'] = this.username;
    map['first_name'] = this.firstname;
    map['last_name'] = this.lastname;
    return map;
  }
}

class Member {
  int id;
  String email = "";
  String username = "";
  String firstname = "";
  String lastname = "";

  Member();

  Member.fromMap(dynamic obj){
    this.id = obj['id'];
    this.email = obj['email'];
    this.username = obj['username'];
    this.firstname = obj['first_name'];
    this.lastname = obj['last_name'];

    print("Member ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['email'] = this.email;
    map['username'] = this.username;
    map['first_name'] = this.firstname;
    map['last_name'] = this.lastname;
    return map;
  }
}