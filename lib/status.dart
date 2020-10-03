import 'dart:async';

import 'package:charting/displaystatus.dart';
import 'package:charting/imageandvediopage.dart';
import 'package:charting/liststory.dart';
import 'package:charting/status3dlistview.dart';
import 'package:charting/statusviewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:date_format/date_format.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  StreamSubscription streamSubscription;
  StreamSubscription _streamSubscription;
  StreamSubscription _subscription;
  List<DocumentSnapshot> mystatus=[];
  List<DocumentSnapshot> users=[];
  List<String>myfriend=[];
  List<String> firenduploded=[];
  List<DocumentSnapshot>friendstatus=[];
   FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseUser user;
  String phno="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getuser().then((myphno){
      if(myphno!=null)
      {
          CollectionReference collectionReference=Firestore.instance.collection("Allusers").document(myphno).collection(myphno);
          CollectionReference collectionReference1=Firestore.instance.collection("Allusers").document(myphno).collection("Status");
    streamSubscription=collectionReference.snapshots().listen((onData){
      setState(() {
        users=onData.documents;
     
      });
      checkfriendstatus();
    });
    _streamSubscription=collectionReference1.snapshots().listen((data){
         setState(() {
           mystatus=data.documents;
           
         });
    });
      }
    });

  }
  Future  getuser() async
  {
  user=await firebaseAuth.currentUser();

    
   setState(() {
      phno= user.phoneNumber;
   });
    return phno;
  }
  checkfriendstatus()
  {
    if(users.length!=0){
    if(users[0].data['contact']?.length!=0)
    {
      for(int i=0;i<users[0].data['contact']?.length;i++)
      {
        if(users[0].data['contact'][i]!=null)
        {
          print("contact is ${users[0].data['contact'][i]}");
          if(users[0].data['contact'][i].toString().split(",")[0].compareTo("person")==0)
          myfriend.add(users[0].data['contact'][i]);
        }
      }
      
        
    }
    if(myfriend?.length!=0)
    {
     int po=0;
     for(int i=0;i<myfriend?.length;i++)
      {
       print("myfrend is ${myfriend[i]}");
        if(myfriend[i]!=null)
        {
          var list=myfriend[i].split(",");
          String phno=list[1];
          print("phno is $phno");
          CollectionReference collectionReference3=Firestore.instance.collection("Allusers").document(phno).collection("Status");
          _subscription=collectionReference3.snapshots().listen((data){
            print("data is ${data.documents?.length}");
            if(data.documents?.length!=0)
            {

              print("Sussues");
          for(int i=0;i<data.documents.length;i++)
            {
                var time = DateFormat.jm().format(DateTime.now());
                                print("users found or not $time");
                                  String time1=     data.documents[i].data['time'];
         print("time $time1");
          // totletime(time1);
          // print("uplode totle time ${totletime(time1)}");
          // print("current totle time is ${totletime(time)}");
            setState(() {
               friendstatus=data.documents;
               firenduploded.add(myfriend[i]);
              // myfriend.removeAt(i);
             });
            }
            }
            else
            {
              print("failure");
                print("beforre failure ${myfriend.length}");
                print("posstion $i");
              setState(() {
                if(myfriend?.length==1)
                {
                  myfriend.clear();
                }
                else
                {
                  if(po==0)
                  myfriend.removeAt(i);
                  if(po!=0)
                  myfriend.removeAt(i-1);
                 po=1;
                  
                }
              });
              print("after failure ${myfriend.length}");
              print("listr id $myfriend");
            }
          });
         
        }
       // i=0;
      } 
    }
  }
  }
  // totletime(String time)
  // {
  //    var time = DateFormat.jm().format(DateTime.now());
  //      List<String>current=time.split(":");
  //        print(current[1].split(" "));
  //        print(current[1].split(" ")[1]=="AM");
  //        int amorpm1=current[1].split(" ")[1]=="AM"?0:12*60;
  //        int curenttime=int.parse(current[0])*60+int.parse(current[1].split(" ")[1])+amorpm1;
  //        print("tottle time is $curenttime");
         


  //        List<String>uplodetime=time.split(":");
  //        print(uplodetime[1].split(" "));
  //        print(uplodetime[1].split(" ")[1]=="AM");
  //        int amorpm=uplodetime[1].split(" ")[1]=="AM"?0:12*60;
  //        int totletime=int.parse(uplodetime[0])*60+int.parse(uplodetime[1].split(" ")[1])+amorpm;
  //        print("tottle time is $totletime");
  //        if(current[1].split(" ")[1]==uplodetime[1].split(" ")[1])
  //        {
           
  //        }
  //        return totletime;
  // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
         body: Column(
           children: <Widget>[
         ListTile(
                    leading: Container(
                 height: 60,width: 60.0,
                 child: CircleAvatar(
                 
                 
                // backgroundImage: users[0].data['img']!=null?  NetworkImage(users[0].data['img'])
                 //:Offstage()             //  add asert image
                 
                 
                 )),
                 title: Text("My Status"),
                 subtitle: Text("view my status"),
           onTap: (){
             if(mystatus?.length==0)
             {
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Imageandavedio("Status",phno)));
             }
             else
             {
               print("display");
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListStory(mystatus,users,phno)));
             }
               

           },
         ),
         Container(
           height: 30.0,
           width: MediaQuery.of(context).size.width,
           color: Colors.black26,
           child: Align(child: Text("View Status"),alignment: Alignment.center,),
         ),
       firenduploded.toSet()?.length!=0?  Container(
           height: MediaQuery.of(context).size.height-300 ,
         color: Colors.black12,
         child:firenduploded?.length!=0? ListView.builder(
           itemCount: firenduploded?.length,
          
           itemBuilder: (context,index){
              List<String> temp=firenduploded[index].split(",");
             
             return ListTile(
               leading: Container(
                height: 60,
                width: 60,
              child: CircleAvatar(
              backgroundImage: NetworkImage(temp[3]),
              ),
              ),
              title: Text(temp[2]),
              subtitle: Text(friendstatus[0].data['time']),
              onTap: (){
           //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DisplayStatus(friendstatus, temp[1],temp[2])));
           List<String> statusdata=[temp[3]];

           print("status datya $statusdata");
//            ListWheelScrollView(
// itemExtent: 160,
// children: <Widget>[
//   Statusviewer(["image,${temp[3]}"])
// ],
//            );
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Sataus3dview()));
              },
             );
           }
         ):Offstage()
         ):Container(
            height: MediaQuery.of(context).size.height-300 ,
             color: Colors.black12,
         )

           ],
         ),
    );
  }
}