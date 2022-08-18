import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/HomeScreen/posts1.png',
      selectedImagePath: 'assets/HomeScreen/posts2.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/HomeScreen/badge1.png',
      selectedImagePath: 'assets/HomeScreen/badge2.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/HomeScreen/sub1.png',
      selectedImagePath: 'assets/HomeScreen/sub2.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/HomeScreen/tab_4.png',
      selectedImagePath: 'assets/HomeScreen/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
