import 'dart:convert';
import 'dart:io';

import 'package:charting/Chart_image_vedio_uploader.dart';
import 'package:charting/chart_vedioplayer.dart';
import 'package:charting/statusuploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:storage_path/storage_path.dart';
import 'package:chewie/chewie.dart';
class Vediofile extends StatefulWidget {
  String phno;
  String which;
  String userdata;
  String fromdata;
  DocumentSnapshot groupdata;
  Vediofile(this.phno,this.which,[this.userdata,this.groupdata,this.fromdata]);
  @override
  _VediofileState createState() => _VediofileState();
}

class _VediofileState extends State<Vediofile> {
Future<String> vediofilepath;
List<dynamic> filepath=[];
List<dynamic> vediofile=[];
List<String> vedio=[];
String users="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var vediofile=StoragePath.videoPath;
  setState(() {
    vediofilepath=vediofile;
  });
  vediofile.then((data){
   setState(() {
    // print(data);
     filepath=json.decode(data);
    // print("filepath $filepath");
   });
  });
  if(widget.which.compareTo("group")!=0)
   getusers();
  }
 getusers()async
 {
   FirebaseUser user=await FirebaseAuth.instance.currentUser();
   setState(() {
     users=user.phoneNumber;
   });
 }

 List<String> selected=[];

  @override
  Widget build(BuildContext context) {
    
   print(filepath[0]["files"].length);
    print(vedio.toString());
     for(int i=0;i<filepath?.length;i++)
  {
    for(int j=0;j<filepath[i]["files"].length;j++)
    {
      vedio.add(filepath[i]["files"][j]["path"]);
    }
 //  print(filepath[i]);
  }
    print(vediofilepath);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
           home: Scaffold(
             body: Container(
               child:  StaggeredGridView.countBuilder(
       crossAxisCount: 4, 
       crossAxisSpacing: 4.0,
       mainAxisSpacing: 4.0,
       staggeredTileBuilder: (index){
         return StaggeredTile.count(2, 2);
       },
        itemBuilder: (BuildContext context,int index){
          return InkWell(
                      child: Container(
              color: Colors.green,
              child: Text(vedio[index]),
            // child: ,
            ),
            onTap: (){
              if(widget.which.compareTo("group")==0){
 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chart_VedioPlayer(vedio[index],true,true,null,null,null,null,null,widget.groupdata,widget.phno,)));
              }else{
 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chart_VedioPlayer(vedio[index],true,false, widget.userdata,widget.phno,)));
              }
  
            },
            onLongPress: (){
              if(selected.contains(vedio[index]))
              {
                setState(() {
                  selected.remove(vedio[index]);
                });
              }
              else{
                 setState(() {
               selected.add(vedio[index]);
              });
              }
             
            },
          );
        }, 
        itemCount: vedio?.length),
             ),
    floatingActionButton:selected?.length!=0? FloatingActionButton(
      child: Text(selected?.length.toString()),
      onPressed: (){
     if(widget.which=="Status")
     {
    StatusUploder statusuploder=   StatusUploder(widget.phno, selected, "vedio");
    statusuploder.upload();
     }
     else if(widget.which=="Chart")
     {
  //  ChartUploder chartuploder= ChartUploder(false,widget.phno,users, selected, "vedio");
  //  chartuploder.upload();
     }else if(widget.which=="group"){
  //       ChartUploder chartuploder= ChartUploder(true,widget.phno,widget.fromdata, selected, "vedio");
  //  chartuploder.upload();
     }
      }
    ):Offstage()
           ),
    );
  }
}