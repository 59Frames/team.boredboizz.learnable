import 'dart:async';

import 'package:learnable/data/cached_base.dart';
import 'package:learnable/data/database_helper.dart';
import 'package:learnable/models/classmodel.dart';
import 'package:learnable/models/schools.dart';
import 'package:flutter/material.dart';

class Event extends LearnableObject<Event>{
  EventType eventType;
  Lesson lesson;
  String title = "";
  String description = "";
  Member creator;

  Event(obj) : super(obj);

  @override
  Future init(obj) async {
    await CachedBase().getEventTypeById(obj['type']).then((eventType) => this.eventType = eventType);
    await CachedBase().getLessonById(obj['lesson']).then((lesson) => this.lesson = lesson);
    await CachedBase().getMemberById(obj['creator']).then((member) => this.creator = member);
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("events", this);
  }

  @override
  Event fromMap() {
    this.title = jsonObj['title'];
    this.description = jsonObj['description'];
    return this;
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

class EventType extends LearnableObject<EventType>{
  String type;
  IconData icon;
  AssetImage image;

  EventType(obj) : super(obj);

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

  @override
  EventType fromMap() {
    this.type = jsonObj['type'];
    this._loadImageAndIcon();

    print("EventType ${this.id} loaded");
    return this;
  }

  @override
  Future init(obj) async {
    return;
  }

  @override
  Future persist() async {
    DatabaseHelper().saveLearnableObject("event_types", this);
  }
}