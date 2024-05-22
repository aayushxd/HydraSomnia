import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/service/notification_service.dart';
import 'package:healthapp/features/auth/provider/auth_provider.dart';

import '../../../models/blood_glucose.dart';
import '../../../repo/health_repo.dart';

class HomeController extends GetxController {
  final repository = HealthRepository();
  late NotificationService notificationService;

  final waterGoal = 0.obs;
  final remWaterGoal = 0.obs;

  initController() {
    getWaterGoal();
    hydrationWaterRepeater();
  }

  hydrationWaterRepeater() async {
    await AndroidAlarmManager.periodic(const Duration(minutes: 5),
        AppConstants.hydrationReminderId, hitHydrationReminder);
  }

  hitHydrationReminder() {
    notificationService = NotificationService();
    notificationService.createStayHydratedNotification();
  }

  getWaterGoal() async {
    AuthController authController = Get.find();
    User? gUser = await authController.getCurrentUser();
    UserTable? user =
        await UserTable().select().uid.equals(gUser?.uid).toSingle();
    waterGoal.value = user?.waterGoal ?? 0;
    update();
  }

  Future<void> getWaterData() async {
    await repository.getWaterInTakeToday();
  }

  Future<void> writeWaterData(int waterAmount) async {
    double amount = waterAmount / 1000;
    await repository.writeWaterData(amount);
  }

  Future<void> getSleepData() async {
    await repository.getSleepRecord();
  }

  Future<void> writeSleepData() async {
    await repository.writeSleepRecord();
  }

  Future<void> getTotalStepsToday() async {
    await repository.getTotalStepsToday();
  }
}
