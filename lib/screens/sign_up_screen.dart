import 'package:easy_container/easy_container.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:levels/screens/gadget_screen.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:levels/ui/text_style.dart';
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
  String birthDate="";
  Gender gender=Gender.Others;
  int step=1;
  int level=0;
  String filiere="";
  List<bool> _isSelected=[false,false,false,false,false,false];
  List<bool> _isSelected2=[false,false,false,false,false,false,false,false];


  bool submittedPwd = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: Row(
          children: [
           if(step>1) IconButton(onPressed: () {
              setState(() {
                if (step>1){
                  step--;
                }
              });
            }, icon: Icon(Icons.arrow_circle_left_outlined)),
            const Text('Create Account'),
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
            Image.asset("assets/images/icon.png",
            fit: BoxFit.cover,

height: MediaQuery.of(context).size.height/8,
width: MediaQuery.of(context).size.width,


            ),
          if(step==2) Center(
            child: const Text(
                'Upload Your Photo 📸',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ),
            
            if(step==2) Container(
              child: Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width ,
                child: Container(
                  decoration:BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ) ,
                  
                  child: IconButton(icon:Icon(Icons.file_upload_outlined),onPressed: (){

                    print("waa");
                  },
                  
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                image: DecorationImage(

                    image: gender==Gender.Female?
                    AssetImage("assets/images/gadget2.jpg",):
                    AssetImage("assets/images/gadget5.jpg"),
                ),

                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            if(step==1) const Text(
              'First Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if(step==1) const SizedBox(height: 15),
            if(step==1) TextFormField(
              initialValue: first_name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your first name',
                 prefixIcon:Icon(Icons.account_circle_outlined),

              ),
              onFieldSubmitted: (value) { first_name=value.trim();
              
              },
              onChanged: (value) { first_name=value.trim();
              
              },
              maxLength: 20,
            ),
            if(step==1) const SizedBox(height: 15),
            if(step==1) const Text(
              'Last Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if(step==1) const SizedBox(height: 15),
            if(step==1) TextFormField(
              initialValue: last_name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your last name',
                prefixIcon:Icon(Icons.account_circle_outlined),
                                

              ),
              
              onFieldSubmitted: (value) {last_name=value.trim();},
              onChanged: (value) { last_name=value.trim();
              
              },
              maxLength: 20,
            ),         
            if(step==1) const Text(
              'Gender',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if(step==1) GenderPickerWithImage(
              showOtherGender: false,
              verticalAlignedText: false,
              selectedGenderTextStyle: TextStyle(
                  color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
              unSelectedGenderTextStyle: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal),
              onChanged: (g) {
                print(g);
                  gender=g!;

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
            if(step==3) const Text(
              'Education Level',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
             if(step==3) const SizedBox(height: 15),
           if(step==3) Center(
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
                  _isSelected=[false,false,false,false,false,false,];
                  _isSelected[index] = !_isSelected[index];
	
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
	
          ),),
             if(step==3) const SizedBox(height: 15),

          if(step==3) const Text(
              'Branch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
             if(step==3) const SizedBox(height: 15),

           if(step==3) Center(
             child: ToggleButtons(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/10
              ,minWidth: MediaQuery.of(context).size.width/10,
              maxHeight: MediaQuery.of(context).size.width/10
              ,minHeight: MediaQuery.of(context).size.width/10
              ),
	
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
                  _isSelected2=[false,false,false,false,false,false,false,false];
                  _isSelected2[index] = !_isSelected2[index];
	
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
	
          ),),
             if(step==3) const SizedBox(height: 15),

           
             if(step==3) const Text(
              'Birth Date',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
             if(step==3) const SizedBox(height: 15),

            if(step==3) Card(

              elevation: 20,
child: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     Icon(Icons.date_range_outlined),
      Text(birthDate.isEmpty?"00-00-0000":birthDate,style:Style.titleTextStyle),
    GestureDetector(child: Text("Change",style:Style.titleTextStyle),
    onTap: () async{
      DatePicker.showDatePicker(context, showTitleActions: true,
                    onConfirm: (d) {
                    print('confirm $d');
                    setState(() {
                      birthDate=d.day.toString()+"-"+d.month.toString()+"-"+d.year.toString();
                    });
                  }, currentTime: DateTime.now(),minTime: DateTime(1920)
                  ,maxTime: DateTime(DateTime.now().year)
                  ,theme:DatePickerTheme(backgroundColor: Colors.white,
                  doneStyle: TextStyle(color: Colors.green),

                  ) 
                  );
    
    },
    ),
  ]),
),

            ),
          
            if(step==4) const SizedBox(height: 15),
            if(step==4) const Text(
              'Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if(step==4) const SizedBox(height: 15),

           if(step==4)  submittedPwd == false
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
                if (step==1){
                  if(first_name.trim().isEmpty){
                    showSnackBar("You should enter your first name ✋ !",
                      col: Colors.red);
                }else
                if(last_name.trim().isEmpty){
                    showSnackBar("You should enter your last name ✋ !",
                      col: Colors.red);
                }
                else
                if(gender==Gender.Others){
                    showSnackBar("You should choose your gender ✋ !",
                      col: Colors.red);
                }else{
                  setState(() {
                    step=2;
                  });
                }

                  }
                  else
                  if(step==2){
                    setState(() {
                      step=3;
                    });
                  }
                  else
                  if(step==3){
                    bool one=false;
                    bool two=false;
                    
        for(bool i in _isSelected){
          if (i==true){
          one=true;
          break;
          }
        }
        for(bool i in _isSelected2){
          if (i==true){
          two=true;
          break;
          }
        }

                    if(one==false){
                    showSnackBar("You should choose your level ✋ !",
                      col: Colors.red);
                }
                    else if(two==false){
                    showSnackBar("You should choose your branch ✋ !",
                      col: Colors.red);
                }
                   else if(birthDate.isEmpty){
                    showSnackBar("You should enter birth date ✋ !",
                      col: Colors.red);
                }
                else{
                  setState(() {
                    step=4;
                  });
                }
                  }else
                

                if(step==4){
                  if (submittedPwd == false) {
                  showSnackBar("You should enter your password ✋ !",
                      col: Colors.red);
                } else {
                  showSnackBar("One moment 🤖");
                }
                }
              },
              child:(step==4) ?  const Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ): const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
