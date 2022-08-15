import 'package:easy_container/easy_container.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:levels/screens/gadget_screen.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:levels/utils/helpers.dart';
import 'package:levels/widgets/custom_loader.dart';
import 'package:levels/widgets/pin_input_field.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'SignUpScreen';

  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
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

  String password = "";
  String first_name="";
  String last_name="";

  bool submittedPwd = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text('Create Account'),
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 2,
              ),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: (FirestoreService.userAvatar.isEmpty ||
                            int.tryParse(FirestoreService.userAvatar) == null ||
                            int.parse(FirestoreService.userAvatar) > 15 ||
                            int.parse(FirestoreService.userAvatar) < 0)
                        ? AssetImage("assets/images/profiles/0.jpg")
                        : AssetImage("assets/images/profiles/" +
                            FirestoreService.userAvatar +
                            ".jpg")),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Text(
              'First Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your first name',

              ),
              onSubmitted: (value) => first_name=value.trim(),
              maxLength: 20,
            ),
            const SizedBox(height: 15),
            const Text(
              'Last Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your last name',

              ),
              onSubmitted: (value) {last_name=value.trim();},
              maxLength: 20,
            ),
            const SizedBox(height: 15),
            const Text(
              'Birth Date',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async{
                 await showRoundedDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(1920),
  lastDate: DateTime(DateTime.now().year +1),
  borderRadius: 16,
  imageHeader: AssetImage("assets/images/gadget3.jpg"),
);
                
              },
              child:Icon(Icons.abc),
            ),
            const SizedBox(height: 15),
            submittedPwd == false
                ? PinInputField(
                    length: 6,
                    onFocusChange: (hasFocus) async {
                      if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                    },
                    onSubmit: (input) async {
                      password = input.toString();
                      setState(() {
                        submittedPwd = true;
                      });
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("☑️ Password entred ",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              submittedPwd = false;
                            });
                          },
                          icon: Icon(Icons.replay_circle_filled_outlined,
                              color: Color.fromARGB(187, 19, 204, 19))),
                    ],
                  ),
            EasyContainer(
              width: double.infinity,
              onTap: () async {
                if (submittedPwd == false) {
                  showSnackBar("You should enter your password ✋ !",
                      col: Colors.red);
                } else {
                  showSnackBar("One moment 🤖");
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
