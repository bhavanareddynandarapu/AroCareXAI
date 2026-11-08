import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {

  static final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  static Future<void> initialize() async {

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );


    const InitializationSettings settings =
    InitializationSettings(
      android: androidSettings,
    );


    await flutterLocalNotificationsPlugin.initialize(settings);

  }




  static Future<void> scheduleNotification({

    required String medicine,

    required String dosage,

    required DateTime time,

  }) async {


    await flutterLocalNotificationsPlugin.zonedSchedule(

      DateTime.now()
          .millisecondsSinceEpoch ~/ 1000,


      "Medicine Reminder 💊",


      "Take $medicine ($dosage)",


      tz.TZDateTime.from(
        time,
        tz.local,
      ),



      const NotificationDetails(

        android:
        AndroidNotificationDetails(

          "medicine_channel",

          "Medicine Reminder",

          channelDescription:
          "Medicine alarm notification",

          importance:
          Importance.high,

          priority:
          Priority.high,

          playSound:
          true,

        ),

      ),



      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );


  }


}