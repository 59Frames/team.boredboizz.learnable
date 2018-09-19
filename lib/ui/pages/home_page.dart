import 'package:flutter/material.dart';
import 'package:learnable/color_config.dart' as colorConfig;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorConfig.PRIMARY_COLOR
      ),
    );
  }
}
