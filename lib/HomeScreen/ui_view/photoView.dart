import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gender_picker/source/enums.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Aerobotix/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class PhotoView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  Map<String, String> other;
  PhotoView(
      {Key? key,
      this.animationController,
      this.animation,
      this.other = const {}})
      : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  String netIm = "wait";
  void getIm() async {
    try {
      widget.other.isEmpty
          ? netIm = await FirestoreService.getImage(
              "profiles/" + Member.phone + "/profile/", Member.photo)
          : netIm = await FirestoreService.getImage(
              "profiles/" + widget.other["phone"]! + "/profile/",
              widget.other["photo"]!);
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    getIm();
    super.initState();
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;
  Future uploadFile() async {
    if (_photo == null) return;

    setState(() {
      uploading = true;
    });
    final filePath = _photo!.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
            filePath, outPath,
            minWidth: 1000, minHeight: 1000, quality: 50)
        .then((value) async {
      _photo = value;
      final fileName = basename(_photo!.path);
      final destination = 'profiles/${Member.phone}/profile/';

      try {
        String name = DateTime.now().toString() + fileName;
        Member.photo = name;
        final ref = FirebaseStorage.instance.ref(destination).child(name);

        await ref.putFile(_photo!).timeout(Duration(seconds: 7));
        await FirestoreService.addProfilePhoto(name, Member.phone)
            .timeout(Duration(seconds: 7))
            .then((value) {
          showSnackBar("Your photo is updated successfully !");
          getIm();
        });
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
    });

    //  await compressedImage!.length().then((value) {
    //   print(value);
    //   print("111");
    // });

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
            opacity: widget.animation!,
            child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.animation!.value), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: AvatarGlow(
                    glowColor: Colors.blue,
                    endRadius: MediaQuery.of(context).size.width / 6,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: (netIm.isNotEmpty && netIm != "wait")
                                ? DecorationImage(
                                    image: NetworkImage(
                                      netIm,
                                    ),
                                    fit: BoxFit.fill)
                                : netIm.isEmpty
                                    ? Member.gender == Gender.Female
                                        ? DecorationImage(
                                            image: AssetImage(
                                              "assets/images/gadget2.jpg",
                                            ),
                                            fit: BoxFit.fill)
                                        : DecorationImage(
                                            image: AssetImage(
                                              "assets/images/gadget4.jpg",
                                            ),
                                            fit: BoxFit.fill)
                                    : null,
                          ),
                        ),
                        if (widget.other.isEmpty)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.width / 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    _showPicker(context);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Member.gender == Gender.Female
                                        ? Colors.pink
                                        : Colors.blue,
                                  )),
                            ),
                          )
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
