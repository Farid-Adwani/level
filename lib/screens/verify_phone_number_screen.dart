import 'package:Aerobotix/HomeScreen/Aerobotix_app_home_screen.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/screens/profile_screen.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:Aerobotix/widgets/custom_loader.dart';
import 'package:Aerobotix/widgets/pin_input_field.dart';
import 'package:gender_picker/source/enums.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  const VerifyPhoneNumberScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;
  String netIm = "wait";
  void getIm() async {
    try {
      netIm = await FirestoreService.getImage(
          "profiles/" + Member.phone + "/profile/", Member.photo);
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    getIm();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text('Verify Phone Number'),
        actions: [],
      ),
      body: Center(
        // padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          controller: scrollController,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Member.gender == Gender.Female
                            ? Colors.pinkAccent
                            : Colors.blue,
                        width: 5),
                    shape: BoxShape.circle,
                    image: (netIm.isNotEmpty && netIm != "wait")
                        ? DecorationImage(
                            image: NetworkImage(
                              netIm,
                            ),
                            fit: BoxFit.fill)
                        : Member.gender == Gender.Female
                            ? DecorationImage(
                                image: AssetImage(
                                  "assets/images/gadget2.jpg",
                                ),
                                fit: BoxFit.fill)
                            : DecorationImage(
                                image: AssetImage(
                                  "assets/images/gadget4.jpg",
                                ),
                                fit: BoxFit.fill)),
                child: netIm == "wait"
                    ? Center(child: CircularProgressIndicator())
                    : Container()),
            // CircleAvatar(
            //     radius: MediaQuery.of(context).size.width / 2.5,
            //     backgroundColor: Colors.white,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(200),
            //       child: netIm != "wait"
            //           ? netIm.isNotEmpty
            //               ? Image.network(netIm,
            //                   width: MediaQuery.of(context).size.width,
            //                   height: MediaQuery.of(context).size.width,
            //                   fit: BoxFit.fill)
            //               : Member.gender == Gender.Female
            //                   ? Image.asset(
            //                       "assets/images/gadget2.jpg",
            //                     )
            //                   : Image.asset(
            //                       "assets/images/gadget4.jpg",
            //                     )
            //           : CircularProgressIndicator(),
            //     ))
            // ,
            const SizedBox(height: 10),
            Center(
              child: Text(Member.first_name + " " + Member.last_name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Center(
              child: Text(
                "☎️ : " + Member.phone.replaceFirst("+216", ""),
                style: const TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Text(
              'Enter Your Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            PinInputField(
              length: 6,
              onFocusChange: (hasFocus) async {
                if (hasFocus) await _scrollToBottomOnKeyboardOpen();
              },
              onSubmit: (code) async {
                setState(() {
                  loading = true;
                });
                bool result = false;
                result = await FirestoreService.auth(code, Member.phone);
                if (result == true) {
                  await FirestoreService.updateDevice(Member.phone);
                  showSnackBar("Mar7ba biiiiik fi lFamilia 💖 👪 💖!");
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AerobotixAppHomeScreen.id,
                    //ProfileScreen.id,
                    (route) => false,
                  );
                } else {
                  setState(() {
                    loading = false;
                  });
                }
              },
            ),
            if (loading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
