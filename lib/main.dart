import 'dart:async';

import 'package:charting/homepage.dart';
import 'package:charting/username.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charting/secondpage.dart';
import 'package:charting/signinpage.dart';

import 'database/local_authetication.dart';
void main()=>runApp(LandingPage());
class LandingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LandingPages();
  }

}
enum AuthStatus{
  Signinmethode,
  Botomnavigation
}
class _LandingPages extends State<LandingPage>{

  FirebaseAuth _auth=FirebaseAuth.instance;
  AuthStatus checkingsignin=AuthStatus.Signinmethode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.currentUser().then((user){

      setState(() {

        checkingsignin=user==null ? AuthStatus.Signinmethode:AuthStatus.Botomnavigation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if(checkingsignin==AuthStatus.Signinmethode)
      return Botomnavigation();
    else
      return Botomnavigation();
  }

}