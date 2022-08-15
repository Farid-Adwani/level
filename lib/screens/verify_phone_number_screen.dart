import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:levels/screens/gadget_screen.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:levels/utils/helpers.dart';
import 'package:levels/widgets/custom_loader.dart';
import 'package:levels/widgets/pin_input_field.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        linkWithExistingUser: false,
        onLoginSuccess: (userCredential, autoVerified) async {
          log(
            VerifyPhoneNumberScreen.id,
            msg: autoVerified
                ? 'OTP was fetched automatically!'
                : 'OTP was verified manually!',
          );

          showSnackBar('Phone number verified successfully!');
          FirestoreService.phone = userCredential.user!.phoneNumber!;

          log(
            VerifyPhoneNumberScreen.id,
            msg: 'Login Success UID: ${userCredential.user?.uid}',
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.id,
            (route) => false,
          );
        },
        onLoginFailed: (authException, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            msg: authException.message,
            error: authException,
            stackTrace: stackTrace,
          );

          switch (authException.code) {
            case 'invalid-phone-number':
              // invalid phone number
              return showSnackBar('Invalid phone number!',
                  col: Colors.redAccent[700]);
            case 'invalid-verification-code':
              // invalid otp entered
              return showSnackBar('The code is invalid!',
                  col: Colors.redAccent[700]);
            // handle other error codes
            default:
              showSnackBar('You are blocked for spamming!',
                  col: Colors.redAccent[700]);
            // handle error further if needed
          }
        },
        onError: (error, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            error: error,
            stackTrace: stackTrace,
          );

          showSnackBar('An error occurred!', col: Colors.redAccent[700]);
        },
        builder: (context, controller) {
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: (FirestoreService.userAvatar.isEmpty ||
                                  int.tryParse(FirestoreService.userAvatar) ==
                                      null ||
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
                  Center(
                    child: Text("${FirestoreService.userName}",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Center(
                    child: Text(
                      "☎️ : ${widget.phoneNumber}",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const Text(
                    'Enter Your Code',
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
                    onSubmit: (enteredOtp) async {
                      final verified = await controller.verifyOtp(enteredOtp);
                      if (verified) {
                        // number verify success
                        // will call onLoginSuccess handler
                      } else {
                        // phone verification failed
                        // will call onLoginFailed or onError callbacks with the error
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
