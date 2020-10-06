import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';

class LocalPushNotifications extends StatefulWidget {
  static final LocalPushNotifications _localPushNotifications =
      LocalPushNotifications._internal();

  @override
  _LocalPushNotificationsState createState() => _LocalPushNotificationsState();

  factory LocalPushNotifications() {
    return _localPushNotifications;
  }

  LocalPushNotifications._internal();
}

class _LocalPushNotificationsState extends State<LocalPushNotifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  @override
  void initState() {
    super.initState();
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void setupLocalNotifications() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    /*var result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );*/
  }

  showNotification() async {
    await demoNotification();
  }

  Future<void> demoNotification() async {
    print('demo');
    var androidPlatformSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel_name', 'channel_description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformSpecifics, iOS: iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Hello', 'Message from flutter body', platformChannelSpecifics,
        payload: 'Test payload');
  }

  Future didReceiveLocalNotification(
      String id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
            ));
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print('Yes Yes');
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
