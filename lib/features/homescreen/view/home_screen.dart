import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/asset_path.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/service/notification_service.dart';
import 'package:healthapp/core/styles/app_color.dart';
import 'package:healthapp/features/auth/provider/auth_provider.dart';
import 'package:healthapp/features/auth/view/login_screen.dart';
import 'package:healthapp/features/data_entry/view/data_entry_screen.dart';
import 'package:healthapp/features/homescreen/provider/home_provider.dart';
import 'package:healthapp/features/profile/view/profile_screen.dart';
import 'package:healthapp/features/sleep_tracker/view/sleep_schedule_view.dart';
import 'package:healthapp/features/sleep_tracker/view/sleep_tracker_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/widgets/custom_app_bar.dart';
import '../../../utils/widgets/custom_form_field.dart';
import '../../../utils/widgets/custom_progress_indicator.dart';
import '../../../utils/widgets/goal_and_add.dart';
import '../../../utils/widgets/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function()? openDrawer;

  const HomeScreen({
    super.key,
    this.openDrawer,
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  int _selectedIndex = 0; // new

  @override
  void initState() {
    HomeController controller = Get.put(HomeController());
    controller.getWaterGoal();
    super.initState();

    init();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void init() async {
    toggleLoading();
    toggleLoading();
  }

  void _onItemTapped(int index) {
    // new
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeBody(),
    const SleepScheduleView(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? LoadingScreen()
          : Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                // new
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.water_drop_rounded),
                    label: 'Water',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bed),
                    label: 'Sleep',
                  ),
                  BottomNavigationBarItem(
                    icon: CircleAvatar(
                      radius: 19,
                      backgroundImage: NetworkImage(AssetPaths.displayPic),
                    ),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex, // new
                selectedItemColor: AppColors.primaryColor, // new
                onTap: _onItemTapped,
              ),
              body: _widgetOptions.elementAt(_selectedIndex),
            ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(AppConstants.appName),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        height: 100.sh,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 40,
              ),
              const GoalAndAdd(),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Total water drank",
              ),
              Text(
                "250",
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Record",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ).pl(20),
                  const SizedBox(
                    height: 8,
                  ),
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Emojis.wheater_droplet} 250 ml",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "08:00 AM",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).ph(20),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Emojis.wheater_droplet} 250 ml",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "08:00 AM",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).ph(20),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Emojis.wheater_droplet} 250 ml",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "08:00 AM",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).ph(20),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Emojis.wheater_droplet} 250 ml",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "08:00 AM",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).ph(20),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )
              // TextButton(
              //     onPressed: () {
              //       HomeController controller = Get.find();
              //       controller.getWaterData();
              //     },
              //     child: const Text("Get water data")),
              // TextButton(
              //     onPressed: () {
              //       HomeController controller = Get.find();
              //       controller.writeWaterData(10);
              //     },
              //     child: const Text("write water data")),
              // TextButton(
              //     onPressed: () {
              //       HomeController controller = Get.find();
              //       controller.getSleepData();
              //     },
              //     child: const Text("get sleep data")),
              // TextButton(
              //     onPressed: () {
              //       HomeController controller = Get.find();
              //       controller.writeSleepData();
              //     },
              //     child: const Text("write sleep data")),
              // TextButton(
              //     onPressed: () {
              //       HomeController controller = Get.find();
              //       controller.getTotalStepsToday();
              //     },
              //     child: const Text("get step data")),
              // TextButton(
              //     onPressed: () {
              //       AuthController controller = Get.find();
              //       controller
              //           .signOut()
              //           .then((value) => Get.offAll(const LoginScreen()));
              //     },
              //     child: const Text("Sign Out"))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 3,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            //Navigator.of(context).pushNamed(AddWaterScreen.routeName);
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return const AddWaterWidget();
                });
          }),
    );
  }
}

class AddWaterWidget extends StatefulWidget {
  const AddWaterWidget({super.key});

  @override
  _AddWaterWidgetState createState() => _AddWaterWidgetState();
}

class _AddWaterWidgetState extends State<AddWaterWidget> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController waterController;
  // data
  final DateTime _time = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    waterController = TextEditingController();
    super.initState();
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
      // await Provider.of<HomeProvider>(context, listen: false)
      //     .addWater(_water, _time);

      HomeController controller = Get.find();
      controller.writeWaterData(int.tryParse(waterController.text) ?? 0);

      Navigator.of(context).pop();
      return;
    } catch (e) {
      print(e);
    }
    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Text(
            'Add Water ${Emojis.wheater_droplet}',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: waterController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '240 mL',
                    suffixText: 'mL',
                    labelText: "Water",
                  ),
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter water amount';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Wrong value';
                    }
                    if (double.parse(value) > 400) {
                      return 'Daily limit exceed';
                    }
                    return null;
                  },
                ),
              ],
            ),
          )
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel',
              style: GoogleFonts.poppins(
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          onPressed: submit,
          child: _loading
              ? const SizedBox(
                  height: 22, width: 22, child: CustomProgressIndicatior())
              : Text('Add',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
