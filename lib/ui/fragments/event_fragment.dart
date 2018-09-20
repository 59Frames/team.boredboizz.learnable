import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/models/events.dart';
import 'package:learnable/utils/parse_util.dart' as parser;
import 'package:learnable/color_config.dart' as colorConfig;

final localizations = AppLocalizations();

class EventFragment extends StatefulWidget {
  @override
  _EventFragmentState createState() => _EventFragmentState();
}

class _EventFragmentState extends State<EventFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(Icons.event, color: colorConfig.PRIMARY_COLOR,),
      ),
    );
  }
}
