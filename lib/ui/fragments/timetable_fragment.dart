import 'package:flutter/material.dart';
import 'package:learnable/color_config.dart' as colorConfig;
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/models/schools.dart';
import 'package:learnable/utils/date_util.dart' as dateUtil;

var localizations = AppLocalizations();

class TimetableFragment extends StatefulWidget {
  @override
  _TimetableFragmentState createState() => _TimetableFragmentState();
}

class _TimetableFragmentState extends State<TimetableFragment> implements LanguageChangeDetector {

  int weekday = DateTime.now().weekday <= 5 ? DateTime.now().weekday : 1;

  @override
  void initState() {
    localizations.subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    localizations.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("timetable fragment has been build");

    var _navigation = Row(
      children: <Widget>[
        _WeekDayButton(
          weekDay: localizations.monday,
          onTap: _onWeekDayTap,
          dayNumber: 1,
          isActive: weekday == 1,
        ),
        _WeekDayButton(
          weekDay: localizations.tuesday,
          onTap: _onWeekDayTap,
          dayNumber: 2,
          isActive: weekday == 2,
        ),
        _WeekDayButton(
          weekDay: localizations.wednesday,
          onTap: _onWeekDayTap,
          dayNumber: 3,
          isActive: weekday == 3,
        ),
        _WeekDayButton(
          weekDay: localizations.thursday,
          onTap: _onWeekDayTap,
          dayNumber: 4,
          isActive: weekday == 4,
        ),
        _WeekDayButton(
          weekDay: localizations.friday,
          onTap: _onWeekDayTap,
          dayNumber: 5,
          isActive: weekday == 5,
        ),
      ],
    );

    return Container(
      child: Column(
        children: <Widget>[
          _navigation,
          _getDailySchedule(weekday),
        ],
      ),
    );
  }

  @override
  void onLanguageCodeChange(String languageCode) {
    setState(() {
      localizations = AppLocalizations();
    });
  }

  _onWeekDayTap(value){
    setState(() {
      weekday = value;
    });
  }

  _getDailySchedule(weekday) {

    List<Lesson> lessons = CachedBase().getLessonMap.values
        .where((lesson) => lesson.start.weekday == weekday)
        .toList();

    lessons.sort((a, b) {
      return a.start.compareTo(b.start);
    });

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lessons.map((lesson) => CourseGridTile(
                lesson: lesson
              )).toList()
          ),
        ),
      ),
    );
  }
}

class _WeekDayButton extends StatelessWidget {
  final String weekDay;
  final int dayNumber;
  final bool isActive;
  final ValueChanged<int> onTap;

  _WeekDayButton({Key key, @required this.weekDay, @required this.onTap, @required this.dayNumber, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: InkWell(
          onTap: _onTap,
          child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  weekDay.substring(0,1),
                  style: TextStyle(
                    fontSize: 24.0,
                    color: isActive ? colorConfig.PRIMARY_COLOR : colorConfig.DARK_FONT_COLOR
                  ),
                ),
              )
          ),
        ),
      )
    );
  }

  void _onTap() {
    onTap(dayNumber);
  }
}

class CourseGridTile extends StatelessWidget {

  final Lesson lesson;

  const CourseGridTile({Key key, this.lesson}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      height: (124.0 * lesson.duration),
      child: Card(
        color: lesson.clazz.school.id == 2 ? colorConfig.PRIMARY_COLOR_LIGHT : colorConfig.PRIMARY_COLOR,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                lesson.course.title,
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR
                ),
              ),
              Text(
                "${dateUtil.getTimeString(lesson.start)} - ${dateUtil.getTimeString(lesson.end)}",
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR
                ),
              ),
              Text(
                "${lesson.teacher.firstname} ${lesson.teacher.lastname}",
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR
                ),
              ),
              Text(
                lesson.room,
                style: TextStyle(
                    color: colorConfig.BRIGHT_FONT_COLOR
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}


