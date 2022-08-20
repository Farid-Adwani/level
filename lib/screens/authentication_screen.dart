import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:Aerobotix/screens/sign_up_screen.dart';
import 'package:Aerobotix/screens/verify_phone_number_screen.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/text_style.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationScreen extends StatefulWidget {
  static const id = 'AuthenticationScreen';

  const AuthenticationScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String? phoneNumber;
  String? phoneReset;
  final _formKey = GlobalKey<FormState>();
  final _popKey= GlobalKey<FormState>();
  bool verif = false;
  void popUp(context) {
    AwesomeDialog ad= AwesomeDialog(

      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(
                'You should contact the admin to get your password choose a method :',
                style: Style.commonTextStyle),
            ),
            EasyContainer(
              key:_popKey,
                  elevation: 0,
                  borderRadius: 10,
                  color: Colors.transparent,
                  child: Form(
                    child: IntlPhoneField(
                      autofocus: true,
                      invalidNumberMessage: 'Invalid Phone Number!',
                      textAlignVertical: TextAlignVertical.center,
                      style: Style.headerTextStyle,
                      onChanged: (phone) => phoneReset = phone.completeNumber,
                      initialCountryCode: 'TN',
                      flagsButtonPadding: const EdgeInsets.only(right: 10),
                      showDropdownIcon: false,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     IconButton(
            //       onPressed: () {
            //         FirestoreService.call();
            //         //launch("tel://21620671572");
            //       },
            //       icon:  Icon(Icons.call),
            //       iconSize: 50,
            //     ),
            //     IconButton(
            //       iconSize: 50,
            //       onPressed: () {
            //         FirestoreService.sms("+21620671572");
            //       },
            //       icon: Icon(Icons.sms),
            //     )
            //   ],
            // )
          ],
        ),

      ),
    btnCancel:  IconButton(
                  onPressed: () {
                    FirestoreService.call();
                    //launch("tel://21620671572");
                  },
                  icon:  Icon(Icons.call),
                  iconSize: 50,
                ),
               btnOk:
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    //print(phoneReset);
                    FirestoreService.sms(phoneReset);
                  },
                  icon: Icon(Icons.sms),
                )
             
    );
    phoneReset="";
    ad..show();
    
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(15),
            // padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: FirestoreService.isConnected,
                  child: Image.asset(
                    "assets/images/icon.png",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const Text(
                  "Please Enter Your Phone Number ",
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 15),
                EasyContainer(
                  elevation: 0,
                  borderRadius: 10,
                  color: Colors.transparent,
                  child: Form(
                    key: _formKey,
                    child: IntlPhoneField(
                      autofocus: true,
                      invalidNumberMessage: 'Invalid Phone Number!',
                      textAlignVertical: TextAlignVertical.center,
                      style: Style.headerTextStyle,
                      onChanged: (phone) => phoneNumber = phone.completeNumber,
                      initialCountryCode: 'TN',
                      flagsButtonPadding: const EdgeInsets.only(right: 10),
                      showDropdownIcon: false,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You don't have an account ?   ",
                      style: Style.commonTextStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: Text("Create account",
                          style: TextStyle(
                            color: Color.fromARGB(255, 249, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    popUp(context);
                  },
                  child: Text(
                    "Forget Password ? 😕",
                    style: Style.commonTextStyle,
                  ),
                ),
                const SizedBox(height: 15),
                verif == true
                    ? CircularProgressIndicator()
                    : EasyContainer(
                        width: double.infinity,
                        onTap: () async {
                          setState(() {
                            verif = true;
                          });
                          if (isNullOrBlank(phoneNumber) ||
                              !_formKey.currentState!.validate()) {
                            showSnackBar('Please enter a valid phone number!',
                                col: Colors.redAccent[700]);
                          } else {
                            bool exist = false;

                            try {
                              exist = await FirestoreService.fetchUser(
                                  phoneNumber!);
                            } catch (e) {}
                            if (exist == true) {
                              showSnackBar(
                                  'Phone Number Identified Successfully!');
                              Navigator.pushNamed(
                                  context, VerifyPhoneNumberScreen.id);
                            }
                          }
                          setState(() {
                            verif = false;
                          });
                        },
                        child: const Text(
                          'Verify',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
