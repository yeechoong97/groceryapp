import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

Widget loadingAnimation() {
  return LoadingBumpingLine.circle(
    backgroundColor: Colors.lightBlue,
    borderColor: Colors.blue,
    size: 70.0,
    duration: Duration(milliseconds: 1000),
  );
}
