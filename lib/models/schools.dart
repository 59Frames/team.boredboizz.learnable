import 'dart:async';

import 'package:learnable/data/cached_base.dart';
import 'package:learnable/data/database_helper.dart';
import 'package:learnable/models/classmodel.dart';

class Lesson extends LearnableObject<Lesson> {
  Course course;
  Class clazz;
  Teacher teacher;
  int startLesson;
  int duration;
  String room = "";
  DateTime start;
  DateTime end;
  int week;

  Lesson(obj) : super(obj);

  @override
  Future init(dynamic obj) async {
    await CachedBase().getCourseById(obj['course']).then((course) => this.course = course);
    await CachedBase().getClassById(obj['class']).then((clazz) => this.clazz = clazz);
    await CachedBase().getTeacherById(obj['teacher']).then((teacher) => this.teacher = teacher);
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("lessons", this);
  }

  @override
  Lesson fromMap() {
    this.startLesson = jsonObj['start_lesson'];
    this.duration = jsonObj['duration'];
    this.room = jsonObj['room'];
    this.start = DateTime.parse(jsonObj['start']);
    this.end = DateTime.parse(jsonObj['end']);
    this.week = jsonObj['week'];

    return this;
  }

  @override
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

class Course extends LearnableObject<Course> {
  String title = "";
  String short = "";

  Course(obj):super(obj);


  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['short'] = this.short;
    return map;
  }

  @override
  Course fromMap() {
    this.title = jsonObj['title'];
    this.short = jsonObj['short'];
    print("Course ${this.id} loaded");
    return this;
  }

  @override
  Future init(obj) async {
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("courses", this);
  }
}

class Class extends LearnableObject<Class> {
  School school;
  Teacher teacher;
  String title = "";
  Map<int, Member> members = Map();
  Map<int, Teacher> teachers = Map();

  Class(obj):super(obj);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['school'] = this.school.id;
    map['teacher'] = this.teacher.id;
    map['title'] = this.title;
    return map;
  }

  @override
  Class fromMap() {
    this.title = jsonObj['title'];
    print("Class ${this.id} loaded");
    return this;
  }

  @override
  Future init(obj) async {
    await CachedBase().getSchoolById(obj['school']).then((school) => this.school = school);
    await CachedBase().getTeacherById(obj['teacher']).then((teacher) => this.teacher = teacher);
    await CachedBase().getClassMembers(this.id).then((members) => this.members = members);
    await CachedBase().getClassTeachers(this.id).then((teachers) => this.teachers = teachers);
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("classes", this);
  }
}

class School extends LearnableObject<School> {
  int location;
  String title = "";

  School(obj):super(obj);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['location'] = this.location;
    map['title'] = this.title;
    return map;
  }

  @override
  School fromMap() {
    this.location = jsonObj['location'];
    this.title = jsonObj['title'];
    print("School ${this.id} loaded");
    return this;
  }

  @override
  Future init(obj) async {
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("schools", this);
  }
}

class Teacher extends LearnableObject<Teacher> {
  String email = "";
  String username = "";
  String firstname = "";
  String lastname = "";

  Teacher(obj):super(obj);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['email'] = this.email;
    map['username'] = this.username;
    map['first_name'] = this.firstname;
    map['last_name'] = this.lastname;
    return map;
  }

  @override
  Teacher fromMap() {
    this.email = jsonObj['email'];
    this.username = jsonObj['username'];
    this.firstname = jsonObj['first_name'];
    this.lastname = jsonObj['last_name'];
    print("Teacher ${this.id} loaded");
    return this;
  }

  @override
  Future init(obj) async {
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("teachers", this);
  }
}

class Member extends LearnableObject<Member> {
  String email = "";
  String username = "";
  String firstname = "";
  String lastname = "";

  Member(obj) : super(obj);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['email'] = this.email;
    map['username'] = this.username;
    map['first_name'] = this.firstname;
    map['last_name'] = this.lastname;
    return map;
  }

  @override
  Member fromMap() {
    this.email = jsonObj['email'];
    this.username = jsonObj['username'];
    this.firstname = jsonObj['first_name'];
    this.lastname = jsonObj['last_name'];

    print("Member ${this.id} loaded");
    return this;
  }

  @override
  Future init(obj) async {
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("members", this);
  }
}