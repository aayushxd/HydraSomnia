import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:healthapp/utils/values/months.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/blood_glucose.dart';

class HealthRepository {
  final health = Health();
  bool requested = false;

  getPermissions() async {
    requested = await health.requestAuthorization([
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.WATER,
    ], permissions: [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ]);
  }

  Future<void> writeWaterData(double amount) async {
    final permissionStatus = Permission.activityRecognition.request();
    getPermissions();
    if (requested) {
      bool done = await health
          .writeHealthData(
            amount,
            HealthDataType.WATER,
            DateTime.now(),
            DateTime.now(),
          )
          .then((value) {
            print("helloooo $value");
            return value;
          })
          .catchError((e) => print("e= $e"))
          .onError((error, stackTrace) {
            print("err= $error");
            return false;
          });
      print("waterrrrrr $done and ");
    }
  }

  Future<void> getWaterInTakeToday() async {
    final water = await health.getHealthDataFromTypes(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,
          0, 0, 0),
      DateTime.now(),
      [
        HealthDataType.WATER,
      ],
      includeManualEntry: true,
    );
    // print(water);
    final waterRemovedDuplicates = health.removeDuplicates(water);
    for (var w in waterRemovedDuplicates) {
      print("water details: date : ${w.dateFrom}, ${w.value}, ${w.unit}");
    }
    
  }

  Future<void> getSleepRecord() async {
    final sleep = await health.getHealthDataFromTypes(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 1,
      ),
      DateTime.now(),
      [
        HealthDataType.SLEEP_ASLEEP,
      ],
      includeManualEntry: true,
    );
    print(sleep);
    for (var s in sleep) {
      print("sleep details: date : ${s.dateFrom}, ${s.value}, ${s.unit}");
    }
  }

  Future<void> writeSleepRecord() async {
    final sleep = await health.writeHealthData(
      2,
      HealthDataType.SLEEP_ASLEEP,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,
          0, 0, 0),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8,
          0, 0, 0),
    );
    print("sleep: $sleep");
  }

  Future<void> getTotalStepsToday() async {
    final steps = await health.getTotalStepsInInterval(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,
          0, 0, 0),
      DateTime.now(),
    );
    // print(water);

    print("total steps today: $steps");
  }
}
