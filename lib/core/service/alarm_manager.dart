import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/service/notification_service.dart';

class AlarmService {
  NotificationService notificationService = NotificationService();
  AlarmService() {
    AndroidAlarmManager.initialize();
    notificationService.init();
  }
  Future<void> setBedTimeAlarm(DateTime time, bool repeat) async {
    print("alarm time $time");
    if (repeat) {
      await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        AppConstants.bedtimeAlarmId,
        () {
          print("ring ring at $time ");

          notificationService.createBedtimeNotification(time, repeat);
        },
        exact: true,
        startAt: time,
        allowWhileIdle: true,
        wakeup: true,
      );
    } else {
      await AndroidAlarmManager.oneShotAt(
        time,
        AppConstants.bedtimeAlarmId,
        () {
          print("ring ring at $time ");
          notificationService.createBedtimeNotification(time, repeat);
        },
        exact: true,
        alarmClock: true,
        allowWhileIdle: true,
        wakeup: true,
      );
    }
  }
}
