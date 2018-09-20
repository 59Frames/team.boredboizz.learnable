import 'package:flutter/material.dart';
import 'package:learnable/color_config.dart' as colorConfig;

class TimetableFragment extends StatefulWidget {
  @override
  _TimetableFragmentState createState() => _TimetableFragmentState();
}

class _TimetableFragmentState extends State<TimetableFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(Icons.dashboard, color: colorConfig.PRIMARY_COLOR,),
      ),
    );
  }
}