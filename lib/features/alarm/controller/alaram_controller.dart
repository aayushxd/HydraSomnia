import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/features/auth/provider/auth_provider.dart';
import 'package:healthapp/features/auth/view/login_screen.dart';

class AlarmController extends ChangeNotifier {
  List<AlarmModel> alarmList = [];

  List<String> listOfString = [];

  late BuildContext context;
  String? uid;
  getUserId() async {
    AuthController authController = Get.find();
    User? user = await authController.getCurrentUser();
    if (user == null) Get.offAll(() => const LoginScreen());
    uid = user?.uid;
    notifyListeners();
  }

  setAlarm(
    String label,
    String dateTime,
    bool isActive,
    bool repeat,
  ) {
    alarmList.add(AlarmModel(
      uid: uid!,
      label: label,
      alarmTime: dateTime,
      isActive: isActive,
      doRepeat: repeat,
    ));
    for (var e in alarmList) {
      print("e; ${e.toJson()}");
    }
    notifyListeners();
  }

  editSwitch(int index, bool check) {
    alarmList[index].isActive = check;
    notifyListeners();
  }

  getData() async {
    alarmList = await AlarmModel().select().uid.equals(uid).toList();
    for (var a in alarmList) {
      print(a.toJson());
    }
    notifyListeners();
  }

  setData() async {
    for (var alarm in alarmList) {
      print("Set: ${alarm.toJson()}");
      await alarm.save();
    }
    notifyListeners();
  }
}
