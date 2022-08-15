import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:levels/screens/sign_up_screen.dart';
import 'package:levels/screens/verify_phone_number_screen.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:levels/ui/text_style.dart';
import 'package:levels/utils/helpers.dart';

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

  final _formKey = GlobalKey<FormState>();
    bool verif=false;
  
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
                    Text("You don't have an account ?   ",style: Style.commonTextStyle,),
                     GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                       child: Text("Create account",style:TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                       )),
                     ),
                  ],
                ),
                const SizedBox(height: 15),
                verif==true?  
               CircularProgressIndicator()
               
               :EasyContainer(
                  width: double.infinity,
                  onTap: () async {
                    setState(() {
                      verif=true;
                    });
                    if (isNullOrBlank(phoneNumber) ||
                        !_formKey.currentState!.validate()) {
                      showSnackBar('Please enter a valid phone number!',col: Colors.redAccent[700]);
                    } else {
                 String userN= await FirestoreService.getUserFromPhoneNumber(phoneNumber.toString()).timeout(Duration(seconds: 5), onTimeout: () { 
  return "timeout"; });
  
                 if(userN.isEmpty){
                   showSnackBar('No user with this phone number!',col: Colors.redAccent[700]);
                 }else if(userN=="timeout"){
  showSnackBar('Please check your internet connection!',col: Colors.redAccent[700]);
                 }else{
                  print(userN.toString());
                  showSnackBar('Phone Number Identified Successfully!');
                  FirestoreService.userId=userN;
                   Navigator.pushNamed(
                        context,
                        VerifyPhoneNumberScreen.id,
                        arguments: phoneNumber,
                      );      
                 }
                     
                    }
                    setState(() {
                      verif=false;
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
