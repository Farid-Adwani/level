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
      imagePath: 'assets/HomeScreen/leaderboard.png',
      selectedImagePath: 'assets/HomeScreen/leaderboard2.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/HomeScreen/all.png',
      selectedImagePath: 'assets/HomeScreen/all2.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/HomeScreen/material.png',
      selectedImagePath: 'assets/HomeScreen/material2.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/HomeScreen/music.png',
      selectedImagePath: 'assets/HomeScreen/music2.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
