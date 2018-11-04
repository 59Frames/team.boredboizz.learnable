class User {
  static final User _instance = new User._internal();

  factory User() => _instance;

  User._internal();

  int id;
  String email = "";
  String username = "";
  String firstname = "";
  String lastname = "";
  bool isAdmin = false;
  bool isTeacher = false;

  String fullName() => "$firstname $lastname";

  User.fromMap(dynamic obj){
    _instance.id = obj['id'];
    _instance.email = obj['email'];
    _instance.username = obj['username'];
    _instance.firstname = obj['first_name'];
    _instance.lastname = obj['last_name'];
    _instance.isAdmin = obj['is_admin'] == 1 ? true : false;
    _instance.isTeacher = obj['is_teacher'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['id'] = _instance.id;
    map['email'] = _instance.email;
    map['username'] = _instance.username;
    map['first_name'] = _instance.firstname;
    map['last_name'] = _instance.lastname;
    map['is_admin'] = _instance.isAdmin;
    map['is_teacher'] = _instance.isTeacher;
    return map;
  }

  void reset(){
    _instance.id = null;
    _instance.email = "";
    _instance.username = "";
    _instance.firstname = "";
    _instance.lastname = "";
    _instance.isAdmin = false;
    _instance.isTeacher = false;
  }

  @override
  String toString() {
    return "{ id: $id, email: $email, username: $username, full_name: $firstname $lastname }";
  }
}