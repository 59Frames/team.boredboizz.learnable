import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/routes.dart';
import 'package:learnable/ui/pages/config_page.dart';
import 'package:learnable/color_config.dart' as colorConfig;

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(LearnableApp());
}

class LearnableApp extends StatefulWidget {
  @override
  _LearnableAppState createState() => _LearnableAppState();
}

class _LearnableAppState extends State<LearnableApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppLocalizations().applicationName,
      theme: ThemeData(
        primaryColorDark: colorConfig.PRIMARY_COLOR_DARK,
        primaryColor: colorConfig.PRIMARY_COLOR,
        primaryColorLight: colorConfig.PRIMARY_COLOR_LIGHT,
        primaryIconTheme: IconThemeData(
          color: colorConfig.PRIMARY_ICON_COLOR
        ),
      ),
      home: ConfigPage(),
      routes: routes,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("AppLifecycleState changed to $state");
  }
}
