import 'dart:convert';
import 'dart:io';

import 'package:charting/chartmessage.dart';
import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/grouppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storage_path/storage_path.dart';
import 'package:audioplayers/audioplayers.dart';
class Music extends StatefulWidget {
  bool group;
  String user;
  String userdata;
  DocumentSnapshot groupdata; 
  Music(this.group,this.user,[this.userdata,this.groupdata]);
  @override

  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  var audio;
List<String> songname=[];

List<String> songpath=[];
List<double> songsize=[];
List<String> songduration=[];
AudioPlayer audioPlayer;
List<String> selected=[];
AudioPlayerState audioPlayerState;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer=AudioPlayer();
    audioPlayerState=AudioPlayerState.STOPPED;
    var file=StoragePath.audioPath;
    file.then((data){
 setState(() {
     audio=jsonDecode(data);
 });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
   Future<bool> savedata()async
  { var result ;
    for(int i=0;i<selected?.length;i++)
     {
        var date = DateFormat.yMd().format(DateTime.now());
                      Databasehelper helper ;
                      if(widget.group){
                                         helper= Databasehelper("p${widget.user}");
                      }else{
                          helper= Databasehelper("p${widget.user.substring(1)}");
                      }
                         
                      var time = DateFormat.jm().format(DateTime.now());
                      Message message = Message(
                     toorfrom: "to",
                        msgtype: "audio",
                        msg: "null",
                        date: date,
                        time: time,
                        imgpath: null,
                        vediopath: null,
                        pdfpath: null,
                        audiopath: selected[i],
                        location: null,
                        contact: null
                        //insert audio path
                      );
                      if(widget.group){
 result = await helper.insertion(
                          message, "p${widget.user}");
                      }else{
                         result = await helper.insertion(
                          message, "p${widget.user.substring(1)}");
                      }
                      
     }
     if(result!=0)
     return true;

  }
  String temp="";
  @override
  Widget build(BuildContext context) {
          for(int i=0;i<audio?.length;i++)
  {
    for(int j=0;j<audio[i]["files"].length;j++)
    {
    //  data.add(allpdf[i]["files"][j]["path"]);
    String path=audio[i]["files"][j]["path"];
    String name=audio[i]["files"][j]["displayName"];
    String size=audio[i]["files"][j]["size"];
    String dur=audio[i]["files"][j]["duration"];
      if(path!=null && name!=null && size!=null&&dur!=null)
      {
        songpath.add(path);
        songname.add(name);
        songsize.add(int.parse(size)/1014*1014);
        songduration.add(dur);

      }
    
    }
 //  print(filepath[i]);
  }
  print(songpath.first);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:songpath!=null ?ListView.builder(
          itemCount: songpath?.length,
          itemBuilder: (context,index){
           return InkWell(
                        child: Opacity(
               opacity:selected.contains(songpath[index])? 0.3:1.0,
                          child: Container(
                 child: ListTile(
                   leading: Container(
                     height: 50.0,
                     width: 50.0,
                     color: temp==songpath[index]?Colors.red:Colors.blue,
                   ),
                    title: Text(songname[index]),
                   subtitle: Text(songsize[index].toString()),
                   trailing: IconButton(icon:temp==songpath[index]? Icon(Icons.pause):Icon(Icons.play_arrow), onPressed: (){
                     if(audioPlayerState==AudioPlayerState.STOPPED)
                     {
                       print("play");
                         setState(() {
                         temp=songpath[index];
                      });
 audioPlayer.play(songpath[index],isLocal: true);
 audioPlayerState=AudioPlayerState.PLAYING;
                     }
                     else if(temp==songpath[index] &&audioPlayerState==AudioPlayerState.PLAYING )
                     {
                       audioPlayer.pause();
                    audioPlayerState=   AudioPlayerState.PAUSED;
                     }
                     else if(temp==songpath[index] &&audioPlayerState==AudioPlayerState.PAUSED)
                     {
                       audioPlayer.resume();
                       audioPlayerState=AudioPlayerState.PLAYING;
                     }
                     else if(audioPlayerState==AudioPlayerState.PLAYING)
                     {
                      setState(() {
                         temp=songpath[index];
                      });
                       audioPlayer.stop();
                        audioPlayer.play(songpath[index],isLocal: true);
 audioPlayerState=AudioPlayerState.PLAYING;
                     }
                     else if(audioPlayerState==AudioPlayerState.PAUSED)
                     {
                        setState(() {
                         temp=songpath[index];
                      });
                       audioPlayer.stop();
                        audioPlayer.play(songpath[index],isLocal: true);
                     }
                   
                   }),
                 ),
               ),
             ),
             onTap: ()
             {
              if(selected.contains(songpath[index]))
              {
                setState(() {
                  selected.remove(songpath[index]);
                });
              }
              else{
                 setState(() {
               selected.add(songpath[index]);
              });
              }
             },
           );
        }):Container(child: Center(child: Text("LODING...")),),
             floatingActionButton:selected?.length!=0? FloatingActionButton(
      child: Icon(Icons.send,size: 30.0,),
      onPressed: ()async{
    savedata().then((check){
      if(check)
      {
if(widget.group){
Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Grouppage(widget.groupdata,widget.user,selected, "audio")));
}else{
  Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Chartmsg(widget.userdata, selected, "audio")));
}
      }
    }) ;
  
      }
    ):Offstage()
      ),
    );
  }
}