import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifier {
  static final Notifier _instance = Notifier._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final _androidSettings = AndroidInitializationSettings('app_icon');
  final _iosSettings = IOSInitializationSettings();

  final _androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'mobile.learnable.ch', 'Learnable', 'Grant this app the ability to show notifications',
      importance: Importance.Max, priority: Priority.High);
  final _iOSPlatformChannelSpecifics = IOSNotificationDetails();

  factory Notifier() => _instance;

  Notifier._internal(){
    var initializationSettings = InitializationSettings(_androidSettings, _iosSettings);
    _plugin.initialize(initializationSettings, selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String message) async {
    print("payload : $message");
  }

  void notify(String title, String content, int id) async {
    var platformChannelSpecifics = NotificationDetails(_androidPlatformChannelSpecifics, _iOSPlatformChannelSpecifics);

    await _plugin.show(
        id,
        title,
        content,
        platformChannelSpecifics,
        payload: 'item id $id'
    );
  }

  void schedule(String title, String content, int id, DateTime date) async {
    var platformChannelSpecifics = NotificationDetails(_androidPlatformChannelSpecifics, _iOSPlatformChannelSpecifics);

    await _plugin.schedule(
        id,
        title,
        content,
        date,
        platformChannelSpecifics,
        payload: 'item id $id'
    );
  }
}