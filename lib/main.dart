import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_noti/firebase_options.dart';
import 'package:test_noti/notification_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String? title = message.notification!.title;
  String? body = message.notification!.body;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 123,
        channelKey: 'call_channel',
        color: Colors.white,
        title: title,
        body: body,
        category: NotificationCategory.Call,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        backgroundColor: Colors.orange),
    actionButtons: [
      NotificationActionButton(key: 'ACCEPT', label: 'Accept call', color: Colors.green, autoDismissible: true),
      NotificationActionButton(key: 'REJECT', label: 'Reject call', color: Colors.red, autoDismissible: true)
    ],
  );
}

Future<void> main() async {
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'call_channel_group',
          channelKey: 'call_channel',
          channelName: 'channel of calling',
          channelDescription: 'Notification channel for calling',
          defaultColor: Color(0xFF9D50DD),
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          ledColor: Colors.white)
    ],
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  @override
  void initState() {
    getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 123,
            channelKey: 'call_channel',
            color: Colors.white,
            title: title,
            body: body,
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            backgroundColor: Colors.orange),
        actionButtons: [
          NotificationActionButton(key: 'ACCEPT', label: 'Accept call', color: Colors.green, autoDismissible: true),
          NotificationActionButton(key: 'REJECT', label: 'Reject call', color: Colors.red, autoDismissible: true)
        ],
      );
    });

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(),
    );
  }
}
