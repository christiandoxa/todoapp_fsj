import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp_fsj/main.dart';

Future<void> addOrEditNotification({
  @required int notificationId,
  @required String title,
  @required String description,
  @required Timestamp deadline,
}) async {
  return await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    title,
    description,
    tz.TZDateTime.from(deadline.toDate(), tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'deadline',
        'Deadline Tasks',
        'Deadline for tasks',
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
