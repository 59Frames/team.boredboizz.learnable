import 'package:flutter/material.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/color_config.dart' as colorConfig;

final localizations = AppLocalizations();

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.about),
      ),
    );
  }
}
