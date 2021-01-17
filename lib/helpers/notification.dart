import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp_fsj/main.dart';

Future<void> addOrEditNotification({
  @required int notificationId,
  @required String title,
  @required String description,
  @required DateTime deadline,
}) async {
  return await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    title,
    description,
    tz.TZDateTime.from(deadline, tz.local),
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
