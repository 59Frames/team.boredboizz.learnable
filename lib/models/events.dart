import 'package:learnable/data/cached_base.dart';
import 'package:learnable/models/schools.dart';
import 'package:flutter/material.dart';

class Event{
  int id;
  EventType eventType;
  Lesson lesson;
  Member creator;
  String title;
  String description;

  Event();

  initializeAsyncFromMap(dynamic obj) async {
    id = obj['id'];
    await CachedBase().getEventTypeById(obj['type']).then((eventType) => this.eventType = eventType);
    await CachedBase().getLessonById(obj['lesson']).then((lesson) => this.lesson = lesson);
    await CachedBase().getMemberById(obj['creator']).then((member) => this.creator = member);
    title = obj['title'];
    description = obj['description'];

    print("Event ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['type'] = eventType.id;
    map['lesson'] = lesson.id;
    map['creator'] = creator.id;
    map['title'] = title;
    map['description'] = description;
    return map;
  }
}

class EventType{
  int id;
  String type;
  IconData icon;
  AssetImage image;

  EventType.fromMap(dynamic obj){
    id = obj['id'];
    type = obj['type'];
    _loadImageAndIcon();

    print("EventType ${this.id} ${this.toMap()} loaded");
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['type'] = type;
    return map;
  }

  void _loadImageAndIcon() {
    switch(this.id){
      case 1:
        this.icon = Icons.school;
        break;
      case 2:
        this.icon = Icons.book;
        break;
      case 3:
        this.icon = Icons.event;
        break;
      default:
        this.icon = Icons.error;
    }
  }
}