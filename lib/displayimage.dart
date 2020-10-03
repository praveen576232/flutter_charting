import 'dart:io';

import 'package:charting/chartmessage.dart';
import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/grouppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DisplayImage extends StatefulWidget {
  String display;
  List<String> image;
  String users;
  String userdata;

  bool group;
  DocumentSnapshot groupdata;
  DisplayImage(this.display,this.image,this.group,[this.users,this.userdata,this.groupdata]);
  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  TextEditingController _controller=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
     var result;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        home:Scaffold(
          body:Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
           widget.image?.length==1? Container(
          child: Image.file(File(widget.image[0]),fit: BoxFit.fill,),
           
          ):Offstage(),
          TextField(
           controller: _controller,
           decoration: InputDecoration(hintText: "Say Something about this...",border: InputBorder.none),
          )
            ],
          ),
          bottomNavigationBar: Container(
            height: 60.0,
            width: 60.0,
           
              child: Align(
                alignment: Alignment.bottomRight,
                              child:FloatingActionButton(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.send,size: 38.0,color: Colors.white,),
                                onPressed: ()async{
                                   for(int i=0;i<widget.image?.length;i++)
                                   {
                                     Databasehelper helper ;
                                     var date = DateFormat.yMd().format(DateTime.now());
                                     if(widget.group){
                                                 helper = Databasehelper("${widget.users}");
                                     }else{
                                       helper = Databasehelper("p${widget.users.substring(1)}");
                                     }

                              var time = DateFormat.jm().format(DateTime.now());
                                Message message = Message(
                                toorfrom: "to",
                                msgtype: "image",
                                msg:widget.image?.length==1?_controller.text:"null",
                                date: date,
                                time: time,
                                imgpath:widget.image[i],
                                vediopath: null,
                                pdfpath :null,
                                audiopath: null,
                                location: null,
                                contact: null
                              );
                                  if(widget.group){
                                         result = await helper.insertion(
                                  message, "${widget.users}");
                                  }else{
                                     result = await helper.insertion(
                                  message, "p${widget.users.substring(1)}");
                                  }
                                   }
                              print(result);
                              if(result!=0)
                              {
                                _controller.clear();
                           if(widget.group){
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Grouppage(widget.groupdata,widget.users,widget.image,"image")));
                           }else{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chartmsg(widget.userdata,widget.image,"image")));
                           }
                              }
                              else
                              {
                                print("error to load a image");
                              }
                                })
                ),
              ),
          ),
   
    );
  }
}