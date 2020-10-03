import 'dart:io';

import 'package:flutter/material.dart';
class Sampleview extends StatelessWidget {
  File path;
  Sampleview(this.path);
  @override
  Widget build(BuildContext context) {
    print(path);
    return path!=null? Container(
      child: Image.file(path),
    ):CircularProgressIndicator();
  }
}