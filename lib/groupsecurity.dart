import 'package:charting/grouppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class GroupSecurity extends StatefulWidget {
 DocumentSnapshot groupinfo;
String groupkey;
  GroupSecurity(this.groupinfo,this.groupkey);

  @override
  _GroupSecurityState createState() => _GroupSecurityState();
}

class _GroupSecurityState extends State<GroupSecurity> {
  

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey=GlobalKey<FormState>();
    TextEditingController textEditingController=TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
              body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("ENTER PASSWORD"),
               Form(
              key: formkey,
              
                        child: TextFormField(
                          controller: textEditingController,
                          validator: (value){
                            if(value.compareTo(widget.groupinfo.data['security'])!=0)
                            return "password not match please try again";
                            return null;
                          },
               
                onFieldSubmitted: (value){
                      if(formkey.currentState.validate()){
 Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                           GroupSecurity(widget.groupinfo,widget.groupkey))
                           
                           );
                      }
                },
              ),
            ),
            FlatButton(
              color: Colors.green,
              onPressed:textEditingController!=null? (){
              if(formkey.currentState.validate()){
                Navigator.pop(context);
                   Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                         Grouppage(widget.groupinfo,widget.groupkey))
                         
                         );
              }
              
            }:null, child: Text("VALIDATE"))
            ],
          ),
        ),
      ),
    );
  }
}