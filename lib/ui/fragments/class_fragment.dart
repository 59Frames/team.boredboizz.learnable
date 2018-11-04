import 'package:flutter/material.dart';
import 'package:learnable/color_config.dart' as colorConfig;
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

var localizations = AppLocalizations();

class ClassFragment extends StatefulWidget {
  @override
  _ClassFragmentState createState() => _ClassFragmentState();
}

class _ClassFragmentState extends State<ClassFragment> implements LanguageChangeDetector {

  Class clazz;

  @override
  void initState() {
    localizations.subscribe(this);
    clazz = CachedBase().getClassMap.values.first;
    super.initState();
  }

  @override
  void dispose() {
    localizations.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("class fragment has been build");
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: colorConfig.PRIMARY_COLOR_DARK,
            width: double.infinity,
            child: ListTile(
              title: Text(
                clazz.title,
                style: TextStyle(
                  color: colorConfig.BRIGHT_FONT_COLOR,
                  fontSize: 24.0
                ),
              ),
              trailing: DropdownButton(
                hint: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      localizations.classes,
                      style: TextStyle(
                          color: colorConfig.PRIMARY_ICON_COLOR
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: colorConfig.PRIMARY_ICON_COLOR,
                    )
                  ],
                ),
                items: _getClassDropDownMenuItems(),
                onChanged: _onClassDropDownChange,
                iconSize: 0.0,
              )
            ),
          ),
          Expanded(
            child: DetailedClass(clazz),
          )
        ],
      )
    );
  }

  void _onClassDropDownChange(value) {
    setState(() {
      CachedBase().getClassById(value).then((clazz) => this.clazz = clazz);
    });
  }

  _getClassDropDownMenuItems() {
    var items = <DropdownMenuItem>[];

    CachedBase().getClassMap.forEach((id, clazz){
      items.add(
          DropdownMenuItem(child: Text(clazz.title), value: id,)
      );
    });

    return items;
  }

  @override
  void onLanguageCodeChange(String languageCode) {
    setState(() {
      localizations = AppLocalizations();
    });
  }
}

class DetailedClass extends StatelessWidget {
  final Class clazz;

  DetailedClass(this.clazz);

  @override
  Widget build(BuildContext context) {

    var teacherListView = Container(
      padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4.0
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getTeachers(),
      ),
    );

    var memberListView = Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getMembers(),
      ),
    );


    return SingleChildScrollView(
      child: Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DetailedClassInfoTile(
                title: localizations.teachers,
                child: teacherListView,
              ),
              DetailedClassInfoTile(
                title: localizations.classmates,
                child: memberListView,
              ),
            ]
        ),
      ),
    );
  }

  _getMembers() {
    var members = <ListTile>[];

    clazz.members.forEach((id, member){
      members.add(
          ListTile(
            leading: CircleAvatar(
              child: Text(
                "${member.firstname.substring(0, 1)}${member.lastname.substring(0, 1)}",
                style: TextStyle(
                    fontSize: 16.0
                ),
              ),
              backgroundColor: member.id == User().id ? colorConfig.PRIMARY_COLOR_DARK : colorConfig.PRIMARY_COLOR,
              foregroundColor: colorConfig.BRIGHT_FONT_COLOR,
            ),
            title: Text("${member.firstname} ${member.lastname}"),
          )
      );
    });

    return members;
  }

  _getTeachers() {
    var teachers = <Widget>[];

    clazz.teachers.forEach((id, teacher){
      teachers.add(TeacherInfoTile(teacher));
    });

    return teachers;
  }
}

class DetailedClassInfoTile extends StatelessWidget {

  final String title;
  final Widget child;

  DetailedClassInfoTile({@required this.title, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: colorConfig.DARK_FONT_COLOR,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            child,
          ]
      ),
    );
  }
}

class TeacherInfoTile extends StatelessWidget {

  final Teacher teacher;

  TeacherInfoTile(this.teacher);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _onTap,
      leading: CircleAvatar(
        child: Icon(Icons.school),
        backgroundColor: teacher.id == User().id ? colorConfig.PRIMARY_COLOR_DARK : colorConfig.PRIMARY_COLOR,
        foregroundColor: colorConfig.BRIGHT_FONT_COLOR,
      ),
      title: Text(
        "${teacher.firstname} ${teacher.lastname}",
        style: TextStyle(
            fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Text(
          "${teacher.email}",
      ),
    );
  }

  void _onTap() async {
    String url = 'mailto:${teacher.email}?subject=Information&body=Guten%20Tag';
    if (await canLaunch(url)){
      await launch(url);
    } else print("Url not launchable");
  }
}
