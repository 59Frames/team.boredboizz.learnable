import 'dart:async';
import 'package:learnable/data/cached_base.dart';

class StructureLoader {
  Future _doneFuture;

  StructureLoader(){
    _doneFuture = init();
  }

  Future init() async {
    List<Future> futures = [];
    futures.add(CachedBase().loadAllCourses());
    futures.add(CachedBase().loadAllEventTypes());
    futures.add(CachedBase().loadAllSchools());
    futures.add(CachedBase().loadAllTeachers());
    futures.add(CachedBase().loadAllMembers());
    futures.add(CachedBase().loadAllClasses());
    futures.add(CachedBase().loadAllLessons());
    futures.add(CachedBase().loadAllEvents());
    return await Future.wait(futures);
  }

  Future get initializationDone => _doneFuture;
}