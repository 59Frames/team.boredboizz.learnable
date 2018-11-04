import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/models/events.dart';
import 'package:learnable/utils/date_util.dart' as dateUtil;
import 'package:learnable/color_config.dart' as colorConfig;
import 'package:learnable/utils/notification_util.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

final _localizations = AppLocalizations();

class EventFragment extends StatefulWidget {
  @override
  _EventFragmentState createState() => _EventFragmentState();
}

class _EventFragmentState extends State<EventFragment> {

  Map<int, Event> _eventMap = Map();

  @override
  void initState() {
    super.initState();
    _refreshList();
    _eventMap = CachedBase().getEventMap;
  }

  @override
  Widget build(BuildContext context) {

    var _refreshIndicator = RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView(
            children: _eventMap.length > 0 ? _getEvents() : <Widget>[ListTile(title: Center(child: Text(_localizations.noEventsListed)))]
        )
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorConfig.PAGE_BACKGROUND_COLOR,
      body: Container(
        child: _refreshIndicator
      ),
    );
  }

  Future<Null> _refreshList() async {
    CachedBase().refreshEventMap().then((n) {
      if(this.mounted){
        setState(() {
          _eventMap = CachedBase().getEventMap;
        });
      }
    });

    return null;
  }

  List<Widget> _getEvents() {
    var _listItems = <Widget>[];

    Set<String> _dateSet = Set();

    _eventMap.forEach((id, event){
      if (event.lesson != null)
        _dateSet.add(dateUtil.getShortDateString(event.lesson.start));
    });

    List<String> _sortedDateTimeList = _dateSet.toList();
    _sortedDateTimeList.sort();


    for(String _date in _sortedDateTimeList){
      List<Widget> _tiles = List();

      _eventMap.forEach((id, event){
        if (event.lesson != null && dateUtil.isOnSameDayShort(_date, event.lesson.start))
          _tiles.add( _EventTile(event));
      });

      setState(() {
        _listItems.add( _EventCard(_date, events: _tiles));
      });
    }

    return _listItems;
  }
}

class _EventCard extends StatelessWidget {

  @required
  final String _date;
  final List<Widget> _events = List();

  _EventCard(this._date, {@required var events}){
    final List<Widget> tmpEventList = events;
    var it = HasNextIterator(tmpEventList.iterator);
    while (it.hasNext){
      _events.add(it.next());
      if (it.hasNext)
        _events.add(Divider(color: colorConfig.DARK_FONT_COLOR,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: ListTile(
              title: Text(
                _date,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: colorConfig.DARK_FONT_COLOR,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Card(
              elevation: 2.0,
              child: Column(
                children: _events,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _EventTile extends StatelessWidget {

  @required
  final Event _event;

  _EventTile(this._event);

  @override
  Widget build(BuildContext context) {

    var _tile = InkWell(
      onTap: _onTap,
      child:
      ListTile(
        leading: Icon(
          _event.eventType.icon,
          color: colorConfig.PRIMARY_COLOR_LIGHT,
        ),
        title: Text(
          _event.title != null ? _event.title : "",
          style: TextStyle(
              fontSize: 18.0,
              color: colorConfig.DARK_FONT_COLOR
          ),
        ),
      ),
    );

    return Container(
      child: _tile,
    );
  }

  void _onTap() {
    showModalBottomSheet(context: _scaffoldKey.currentContext, builder: (BuildContext context){
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SimpleTitleDescriptionTile(
                title: _localizations.eventType,
                description: _event.eventType != null ? _event.eventType.type : "",
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.title,
                description: _event.title != null ? _event.title : "",
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.description,
                description: _event.description != null ? _event.description : "",
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.date,
                description: dateUtil.getShortDateString(_event.lesson != null ? _event.lesson.start : null),
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.startTime,
                description: dateUtil.getTimeString(_event.lesson != null ? _event.lesson.start : null),
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.endTime,
                description: dateUtil.getTimeString(_event.lesson != null ? _event.lesson.end : null),
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.room,
                description: _event.lesson != null ? _event.lesson.room : "",
              ),
              SimpleTitleDescriptionTile(
                title: _localizations.createdBy,
                description: _event.creator != null ? _event.creator.email : "",
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SimpleTitleDescriptionTile extends StatelessWidget {
  final String title;
  final String description;

  const SimpleTitleDescriptionTile({Key key, @required this.title, @required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: colorConfig.DARK_FONT_COLOR
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
            fontSize: 18.0,
            color: colorConfig.DARK_FONT_COLOR
        ),
      ),
    );
  }
}

