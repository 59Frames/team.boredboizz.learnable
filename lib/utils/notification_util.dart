import 'package:local_notifications/local_notifications.dart';

class Notifier {
  static final Notifier _instance = Notifier._internal();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      id: 'mobile.learnable.ch',
      name: 'Learnable',
      description: 'Grant this app the ability to show notifications',
      importance: AndroidNotificationChannelImportance.HIGH
  );

  factory Notifier() => _instance;

  Notifier._internal(){
    _configure();
  }

  void _configure() async {
    await LocalNotifications.createAndroidNotificationChannel(channel: channel);
  }

  void notify(String title, String content, int id) async {
    await LocalNotifications.createNotification(
      title: title,
      content: content,
      id: id,
      androidSettings: AndroidSettings(
        channel: channel,
        priority: AndroidNotificationPriority.DEFAULT,
        vibratePattern: AndroidVibratePatterns.DEFAULT
      ),
      iOSSettings: IOSSettings(
        presentWhileAppOpen: true,
      )
    );
  }

  void notifyOnGoing(String title, String content, int id) async {
    await LocalNotifications.createNotification(
      title: title,
      content: content,
      id: id,
      androidSettings: AndroidSettings(
        channel: channel,
        priority: AndroidNotificationPriority.MAX,
        vibratePattern: AndroidVibratePatterns.DEFAULT,
        isOngoing: true
      ),
      iOSSettings: IOSSettings(
        presentWhileAppOpen: true,
      )
    );
  }
}