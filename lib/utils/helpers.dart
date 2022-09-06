import 'dart:developer' as devtools show log;
import 'dart:ui';

import 'package:Aerobotix/screens/utils/globals.dart';
import 'package:flutter/material.dart';

void showSnackBar(
  String text, {
  Duration duration = const Duration(seconds: 2),
  Color? col = Colors.green,
}) {
  Globals.scaffoldMessengerKey.currentState
    ?..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ), textAlign: TextAlign.center),
        duration: duration,
        backgroundColor: col,
      ),
    );
}

bool isNullOrBlank(String? data) => data?.trim().isEmpty ?? true;

void log(
  String screenId, {
  dynamic msg,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    devtools.log(
      msg.toString(),
      error: error,
      name: screenId,
      stackTrace: stackTrace,
    );
