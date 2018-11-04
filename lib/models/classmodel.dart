import 'dart:async';


abstract class LearnableObject<T extends LearnableObject<T>> {
  int id;
  Future _doneFuture;
  bool isComplete;
  dynamic jsonObj;

  LearnableObject(dynamic obj) {
    this.id = obj["id"];
    this.jsonObj = obj;
    _doneFuture = init(this.jsonObj);
    _doneFuture.then((n) {
      this.isComplete = true;
    });
  }

  T fromMap();

  Map<String, dynamic> toMap();

  Future init(dynamic jsonObj);

  Future get initializationDone => _doneFuture;

  Future persist();
}