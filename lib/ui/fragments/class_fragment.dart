import 'package:flutter/material.dart';
import 'package:learnable/color_config.dart' as colorConfig;

class ClassFragment extends StatefulWidget {
  @override
  _ClassFragmentState createState() => _ClassFragmentState();
}

class _ClassFragmentState extends State<ClassFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(Icons.class_, color: colorConfig.PRIMARY_COLOR,),
      ),
    );
  }
}
