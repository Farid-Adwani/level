import 'dart:async';
import 'dart:io';
import 'package:Aerobotix/HomeScreen/Aerobotix_app_home_screen.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/ui/text_style.dart' as textStyle;
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:Aerobotix/widgets/pin_input_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

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
    print("waaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
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
  String first_name = "";
  String last_name = "";
  String birthDate = "";
  bool loading = false;
  Gender gender = Gender.Others;
  int step = 1;
  int level = 0;
  String filiere = "";
  String phoneNumber = "";
  String photo = "";
  DateTime dateBirth = DateTime.now();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;
  Future uploadFile() async {
    if (_photo == null) return;
    setState(() {
      uploading = true;
    });
    final fileName = basename(_photo!.path);
    final destination = 'profiles/${Member.phone}/profile/';

    try {
      String name = DateTime.now().toString() + fileName;
      Member.photo = name;
      final ref = FirebaseStorage.instance.ref(destination).child(name);

      await ref.putFile(_photo!).timeout(Duration(seconds: 7));
      await FirestoreService.addProfilePhoto(name, Member.phone)
          .timeout(Duration(seconds: 7));
    } on TimeoutException {
      showSnackBar("Please check your internet connection and retry !",
          col: Colors.red);
      setState(() {
        uploading = false;
        _photo = null;
      });
    } catch (e) {
      showSnackBar("Please check your internet connection and retry !",
          col: Colors.red);
      print(e);
      setState(() {
        uploading = false;
        _photo = null;
      });
    }
    setState(() {
      uploading = false;
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<bool> _isSelected = [false, false, false, false, false, false];
  List<bool> _isSelected2 = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  bool submittedPwd = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: Row(
          children: [
            if (step > 1 && step < 4)
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (step > 1 && step < 4) {
                        step--;
                        loading = false;
                      }
                    });
                  },
                  icon: Icon(Icons.arrow_circle_left_outlined)),
            step == 4
                ? const Text('Upload Your Photo 📸')
                : const Text('Create Account'),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        // padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          controller: scrollController,
          children: [
            Image.asset(
              "assets/images/icon.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
            ),
            if (step == 4)
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
                      image: (_photo != null)
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(
                                _photo!,
                              ))
                          : (gender == Gender.Female)
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    "assets/images/gadget2.jpg",
                                  ))
                              : DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    "assets/images/gadget4.jpg",
                                  )))),

            

            if (step == 4)
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                child: IconButton(
                  icon: Icon(Icons.file_upload_outlined),
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
              ),
            if (step == 1)
              const Text(
                'First Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 1) const SizedBox(height: 15),
            if (step == 1)
              TextFormField(
                initialValue: first_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your first name',
                  prefixIcon: Icon(Icons.account_circle_outlined),
                ),
                onFieldSubmitted: (value) {
                  first_name = value.trim();
                },
                onChanged: (value) {
                  first_name = value.trim();
                },
                maxLength: 20,
              ),
            if (step == 1) const SizedBox(height: 15),
            if (step == 1)
              const Text(
                'Last Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 1) const SizedBox(height: 15),
            if (step == 1)
              TextFormField(
                initialValue: last_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your last name',
                  prefixIcon: Icon(Icons.account_circle_outlined),
                ),
                onFieldSubmitted: (value) {
                  last_name = value.trim();
                },
                onChanged: (value) {
                  last_name = value.trim();
                },
                maxLength: 20,
              ),
            if (step == 1)
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 1)
              GenderPickerWithImage(
                showOtherGender: false,
                verticalAlignedText: false,
                selectedGenderTextStyle: TextStyle(
                    color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
                unSelectedGenderTextStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
                onChanged: (g) {
                  gender = g!;

                  // setState(() {
                  //   gender=g!;
                  // });
                },
                selectedGender: gender,
                equallyAligned: true,
                animationDuration: Duration(milliseconds: 300),
                isCircular: true,
                // default : true,
                opacityOfGradient: 0.4,
                padding: const EdgeInsets.all(3),
                size: 50, //default : 40
              ),
            if (step == 2)
              const Text(
                'Education Level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 2) const SizedBox(height: 15),
            if (step == 2)
              Center(
                child: ToggleButtons(
                  children: <Widget>[
                    Text("1"),
                    Text("2"),
                    Text("3"),
                    Text("4"),
                    Text("5"),
                    Text("5+"),
                  ],

                  isSelected: _isSelected,

                  onPressed: (int index) {
                    setState(() {
                      _isSelected = [
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                      ];
                      _isSelected[index] = !_isSelected[index];
                      switch (index) {
                        case 0:
                          level = 1;
                          break;
                        case 1:
                          level = 2;
                          break;
                        case 2:
                          level = 3;
                          break;
                        case 3:
                          level = 4;
                          break;
                        case 4:
                          level = 5;
                          break;
                        case 5:
                          level = 6;
                          break;
                        default:
                      }
                    });
                  },

                  // region example 1

                  color: Colors.grey,

                  selectedColor: Colors.red,

                  fillColor: Colors.lightBlueAccent,

                  // endregion

                  // region example 2

                  borderColor: Colors.lightBlueAccent,

                  selectedBorderColor: Colors.red,

                  borderRadius: BorderRadius.all(Radius.circular(10)),

                  // endregion
                ),
              ),
            if (step == 2) const SizedBox(height: 15),
            if (step == 2)
              const Text(
                'Branch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 2) const SizedBox(height: 15),
            if (step == 2)
              Center(
                child: ToggleButtons(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 10,
                      minWidth: MediaQuery.of(context).size.width / 10,
                      maxHeight: MediaQuery.of(context).size.width / 10,
                      minHeight: MediaQuery.of(context).size.width / 10),

                  children: <Widget>[
                    Text("MPI"),
                    Text("CBA"),
                    Text("IIA"),
                    Text("IMI"),
                    Text("GL"),
                    Text("RT"),
                    Text("BIO"),
                    Text("CH"),
                  ],

                  isSelected: _isSelected2,

                  onPressed: (int index) {
                    setState(() {
                      _isSelected2 = [
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                        false
                      ];
                      _isSelected2[index] = !_isSelected2[index];
                      switch (index) {
                        case 0:
                          filiere = "MPI";
                          break;
                        case 1:
                          filiere = "CBA";
                          break;
                        case 2:
                          filiere = "IIA";
                          break;
                        case 3:
                          filiere = "IMI";
                          break;
                        case 4:
                          filiere = "GL";
                          break;
                        case 5:
                          filiere = "RT";
                          break;
                        case 6:
                          filiere = "BIO";
                          break;
                        case 7:
                          filiere = "CH";
                          break;

                        default:
                      }
                    });
                  },

                  // region example 1

                  color: Colors.grey,

                  selectedColor: Colors.red,

                  fillColor: Colors.lightBlueAccent,

                  // endregion

                  // region example 2

                  borderColor: Colors.lightBlueAccent,

                  selectedBorderColor: Colors.red,

                  borderRadius: BorderRadius.all(Radius.circular(10)),

                  // endregion
                ),
              ),
            if (step == 2) const SizedBox(height: 15),
            if (step == 2)
              const Text(
                'Birth Date',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 2) const SizedBox(height: 15),
            if (step == 2)
              Card(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.date_range_outlined),
                        Text(birthDate.isEmpty ? "00-00-0000" : birthDate,
                            style: textStyle.Style.titleTextStyle),
                        GestureDetector(
                          child: Text("Change",
                              style: textStyle.Style.titleTextStyle),
                          onTap: () async {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true, onConfirm: (d) {
                              setState(() {
                                dateBirth = d;
                                birthDate = d.day.toString() +
                                    "-" +
                                    d.month.toString() +
                                    "-" +
                                    d.year.toString();
                              });
                            },
                                currentTime: DateTime.now(),
                                minTime: DateTime(1920),
                                maxTime: DateTime(DateTime.now().year),
                                theme: DatePickerTheme(
                                  backgroundColor: Colors.white,
                                  doneStyle: TextStyle(color: Colors.green),
                                ));
                          },
                        ),
                      ]),
                ),
              ),
            if (step == 3) const SizedBox(height: 15),
            if (step == 3)
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 3) const SizedBox(height: 15),
            if (step == 3)
              EasyContainer(
                elevation: 0,
                borderRadius: 10,
                color: Colors.transparent,
                child: Form(
                  child: IntlPhoneField(
                    autofocus: true,
                    invalidNumberMessage: 'Invalid Phone Number!',
                    textAlignVertical: TextAlignVertical.center,
                    style: textStyle.Style.headerTextStyle,
                    onChanged: (phone) {
                      if (phone.number.length == 8 &&
                          int.tryParse(phone.number) != null) {
                        phoneNumber = phone.completeNumber;
                      } else {
                        phoneNumber = "";
                      }
                    },
                    initialCountryCode: 'TN',
                    flagsButtonPadding: const EdgeInsets.only(right: 10),
                    showDropdownIcon: false,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
            if (step == 3)
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (step == 3) const SizedBox(height: 15),
            if (step == 3)
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
                        Text("🟢 Password entred ",
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
                if (step == 1) {
                  if (first_name.trim().isEmpty) {
                    showSnackBar("You should enter your first name ✋ !",
                        col: Colors.red);
                  } else if (last_name.trim().isEmpty) {
                    showSnackBar("You should enter your last name ✋ !",
                        col: Colors.red);
                  } else if (gender == Gender.Others) {
                    showSnackBar("You should choose your gender ✋ !",
                        col: Colors.red);
                  } else {
                    String char = first_name[0].toUpperCase();
                    first_name = first_name.replaceFirst(first_name[0], char);
                    char = last_name[0].toUpperCase();
                    last_name = last_name.replaceFirst(last_name[0], char);

                    setState(() {
                      step = 2;
                    });
                  }
                } else if (step == 4) {
                  if (!uploading) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AerobotixAppHomeScreen.id,
                      (route) => false,
                    );
                  }
                } else if (step == 2) {
                  bool one = false;
                  bool two = false;

                  for (bool i in _isSelected) {
                    if (i == true) {
                      one = true;
                      break;
                    }
                  }
                  for (bool i in _isSelected2) {
                    if (i == true) {
                      two = true;
                      break;
                    }
                  }

                  if (one == false) {
                    showSnackBar("You should choose your level ✋ !",
                        col: Colors.red);
                  } else if (two == false) {
                    showSnackBar("You should choose your branch ✋ !",
                        col: Colors.red);
                  } else if (birthDate.isEmpty) {
                    showSnackBar("You should enter birth date ✋ !",
                        col: Colors.red);
                  } else {
                    setState(() {
                      step = 3;
                    });
                  }
                } else if (step == 3) {
                  if (phoneNumber == "") {
                    showSnackBar("You should enter a valid phone number ✋ !",
                        col: Colors.red);
                  } else if (submittedPwd == false) {
                    showSnackBar("You should enter your password ✋ !",
                        col: Colors.red);
                  } else {
                    setState(() {
                      loading = true;
                    });
                    try {
                      bool exist = await FirestoreService.addUser(
                              first_name,
                              last_name,
                              phoneNumber,
                              password,
                              gender,
                              level,
                              filiere,
                              photo,
                              dateBirth)
                          .timeout(Duration(seconds: 5));
                      if (exist == true) {
                        showSnackBar(
                            "There is an existing user with this phone number",
                            col: Colors.red);
                      } else {
                        step = 4;
                        showSnackBar("Your account is created successfully!");
                      }
                    } on TimeoutException catch (e) {
                      showSnackBar("Please check your internet connection",
                          col: Colors.red);
                    } on Error catch (e) {
                      showSnackBar("There is an error", col: Colors.red);
                    }
                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
              child: (step == 3)
                  ? loading == false
                      ? const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        )
                      : CircularProgressIndicator()
                  : (step == 4)
                      ? uploading == false
                          ? const Text(
                              'Continue',
                              style: TextStyle(fontSize: 18),
                            )
                          : CircularProgressIndicator()
                      : const Text('Continue', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    
    
    );
  }
}
