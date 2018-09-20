import 'package:flutter/material.dart';
import 'package:learnable/auth.dart';
import 'package:learnable/data/cached_base.dart';
import 'package:learnable/data/database_helper.dart';
import 'package:learnable/data/rest_api.dart';
import 'package:learnable/locale/locales.dart';
import 'package:learnable/color_config.dart' as colorConfig;
import 'package:learnable/models/user.dart';
import 'package:learnable/ui/fragments/class_fragment.dart';
import 'package:learnable/ui/fragments/event_fragment.dart';
import 'package:learnable/ui/fragments/timetable_fragment.dart';
import 'package:learnable/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localizations = AppLocalizations();

class NavigationItem {
  String title;
  IconData icon;
  Widget content;
  List<Widget> actions;
  NavigationItem({@required this.title, @required this.icon, @required this.content, this.actions});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin implements NetworkStateListener{

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final navigationItems = [
    NavigationItem(
      title: localizations.events,
      icon: Icons.event,
      content: EventFragment(),
    ),
    NavigationItem(
      title: localizations.classes,
      icon: Icons.class_,
      content: ClassFragment(),
    ),
    NavigationItem(
      title: localizations.timetable,
      icon: Icons.dashboard,
      content: TimetableFragment(),
    ),
  ];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    networkUtil.subscribe(this);
    tabController = TabController(length: navigationItems.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          localizations.applicationName,
          style: TextStyle(
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert, color: colorConfig.BRIGHT_FONT_COLOR,),
            onPressed: _openSettings,
          )
        ],
        elevation: 0.0,
        centerTitle: true,
        leading: Container(),
      ),
      endDrawer: AppDrawer(),
      body: TabBarView(
        controller: tabController,
        children: navigationItems.map((item) => item.content).toList(),
      ),
      bottomNavigationBar: Material(
        color: colorConfig.PRIMARY_COLOR,
        child: TabBar(
          controller: tabController,
          tabs: navigationItems.map((item) => Tab(icon: Icon(item.icon),)).toList(),
          indicatorColor: Colors.transparent,
        ),
      )
    );
  }

  void _openSettings() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  void onNetworkStateChanged(NetworkState state) {
    if (state == NetworkState.OFFLINE){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(localizations.isOffline),
          backgroundColor: colorConfig.PRIMARY_COLOR_LIGHT,
          duration: Duration(
              seconds: 3
          ),
        )
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(localizations.isOnline),
            backgroundColor: colorConfig.PRIMARY_COLOR_LIGHT,
            duration: Duration(
              seconds: 3
            ),
          )
      );
    }
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(User().username),
            accountEmail: Text(User().email),
          ),
          ListTile(
            onTap: _navToAccountPage,
            leading: Icon(Icons.account_circle),
            title: Text(localizations.account),
          ),
          ListTile(
            onTap: _navToAboutPage,
            leading: Icon(Icons.info),
            title: Text(localizations.about),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: DropdownButton(
              value: localizations.getLanguageCode(),
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                  value: "de",
                  child: Text("Deutsch"),
                ),
                DropdownMenuItem(
                  value: "en",
                  child: Text("English"),
                ),
                DropdownMenuItem(
                  value: "fr",
                  child: Text("Français"),
                ),
                DropdownMenuItem(
                  value: "it",
                  child: Text("Italiano"),
                ),
                DropdownMenuItem(
                  value: "es",
                  child: Text("Español"),
                ),
                DropdownMenuItem(
                  value: "be_de",
                  child: Text("Bärndütsch"),
                ),
              ],
              onChanged: _onDropdownMenuChange,
            ),
          ),
          Divider(),
          ListTile(
            title: InkWell(
                onTap: _onLogout,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.red
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  child: Text(
                    localizations.signOut,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  void _navToAccountPage() {
    Navigator.of(context).pushNamed("/account");
  }

  void _navToAboutPage() {
    Navigator.of(context).pushNamed("/about");
  }

  void _onLogout() {
    User().reset();
    DatabaseHelper().deleteUser();
    CachedBase().clean();
    RestAPI().logout();
    Navigator.of(context).pushReplacementNamed("/login");
    AuthStateProvider().notify(AuthState.LOGGED_OUT);
  }

  void _onDropdownMenuChange(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("languageCode", value);
    localizations.setLanguageCode(value);
    setState(() {});
  }
}

