import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/asset_path.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/styles/app_color.dart';
import 'package:healthapp/features/auth/provider/auth_provider.dart';
import 'package:healthapp/utils/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/helpers/time_converter.dart';
import '../../../utils/widgets/custom_form_field.dart';
import '../../../utils/widgets/custom_progress_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final Function()? openDrawer;
  const ProfileScreen({super.key, this.openDrawer});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserTable? user;
  bool isLoading = false;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });

    final AuthController authController = Get.find<AuthController>();
    final gUser = await authController.getCurrentUser();
    log("guser: $gUser");
    final luser = await UserTable().select().toList();
    for (var user in luser) {
      print(user.toJson());
    }
    user = await UserTable().select().uid.equals(gUser?.uid).toSingle();
    print(user?.toJson());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(AppConstants.appName),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name ?? "Aayush Dahal",
                                    style: GoogleFonts.poppins(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    user?.email ?? "aayushdahal121@gmail.com",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    user?.photoUrl ?? AssetPaths.displayPic),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          DataEntryForm(
                            appUser: user!,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class DataEntryForm extends StatefulWidget {
  final UserTable appUser;
  const DataEntryForm({
    super.key,
    required this.appUser,
  });
  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  late TextEditingController _waterController;
  late TextEditingController _weightController;
  UserTable? _appUser;
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _appUser = widget.appUser;
    _waterController =
        TextEditingController(text: _appUser?.waterGoal.toString());
    _weightController =
        TextEditingController(text: _appUser?.weight.toString());
  }

  void toggleLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    toggleLoading();
    try {
      //TODO: update user
    } catch (e) {
      print(e);
    }
    toggleLoading();
  }

  void setWater({int? weight}) {
    if (_appUser?.weight != null || weight != null) {
      double calWater =
          weight != null ? weight * 2.205 : _appUser!.weight! * 2.205;
      calWater = calWater / 2.2;
      int age = DateTime.now().year - ((_appUser!.dob!).toDateTime())!.year;
      if (age < 30) {
        calWater = calWater * 40;
      } else if (age >= 30 && age <= 55) {
        calWater = calWater * 35;
      } else {
        calWater = calWater * 30;
      }
      calWater = calWater / 28.3;
      calWater = calWater * 29.574;
      setState(() {
        _appUser?.waterGoal = calWater.toInt();
        _appUser?.weight = weight ?? _appUser!.weight!;
        _waterController.text = _appUser!.waterGoal.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 47,
                  child: DropdownButtonFormField<String>(
                    value: _appUser?.gender,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'male',
                        child: Text(
                          'Male',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text(
                          'Female',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                    decoration: const InputDecoration(
                        border: InputBorder.none, label: Text("Gender")),
                    onChanged: (String? gender) {
                      setState(() {
                        _appUser?.gender = gender;
                      });
                    },
                  )),
              const Expanded(
                  flex: 6,
                  child: SizedBox(
                    width: 20,
                  )),
              Expanded(
                  flex: 47,
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate:
                            _appUser?.dob?.toDateTime() ?? DateTime.now(),
                        firstDate: DateTime(1960),
                        lastDate: DateTime(DateTime.now().year - 12, 12, 31),
                      );
                      if (date != null) {
                        setState(() {
                          _appUser?.dob = date.toString();
                        });
                      }
                      setWater();
                    },
                    controller: TextEditingController(
                        text: DateFormat.yMMMd('en_US')
                            .format(_appUser!.dob!.toDateTime()!)),
                    decoration:
                        const InputDecoration(label: Text("Date of Birth")),
                  )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  flex: 47,
                  child: TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '60 kg',
                      suffixText: 'kg',
                      label: const Text("Weight"),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                    ),
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter weight';
                      }
                      if (double.parse(value) < 40) {
                        return 'You are underweight';
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter valid weight";
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      setWater(weight: int.tryParse(value));
                    },
                  )),
              const Expanded(
                flex: 6,
                child: SizedBox(
                  width: 20,
                ),
              ),
              Expanded(
                  flex: 47,
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 8, minute: 0),
                      );
                      if (time != null) {
                        setState(() {
                          _appUser?.wakeUpTime = "${time.hour}:${time.minute}";
                        });
                      }
                    },
                    child: TextFormField(
                      controller: TextEditingController(
                        text: timeConverter(TimeOfDay(
                            hour:
                                int.parse(_appUser!.wakeUpTime!.split(":")[0]),
                            minute: int.parse(
                                _appUser!.wakeUpTime!.split(":")[1]))),
                      ),
                      decoration: const InputDecoration(
                        label: Text("Wakes Up "),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _waterController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '3200 mL',
                        suffixText: 'mL',
                        labelText: "Water,"),
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter water amount';
                      }
                      if (double.parse(value) < 1600) {
                        return 'Less than min water';
                      }
                      return null;
                    },
                    onChanged: (String? value) {
                      setState(() {
                        _appUser?.waterGoal = int.tryParse(value ?? "0");
                      });
                    },
                  )),
              const Expanded(
                child: SizedBox(
                  width: 0,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CustomProgressIndicatior())
                    : Text(
                        'Update',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                onPressed: () {
                  //toggleLoading();
                  submit();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
