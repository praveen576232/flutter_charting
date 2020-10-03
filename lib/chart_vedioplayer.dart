import 'dart:io';

import 'package:charting/chartmessage.dart';
import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/grouppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Chart_VedioPlayer extends StatefulWidget {
  String userdata;
  String user;
  String url;
  bool group;
  String groupkey;
  bool onlydisplay;
  String phno;
  int index;
  DocumentSnapshot groupdata;
  AsyncSnapshot<List<Map<String, dynamic>>> extra;
  Chart_VedioPlayer(this.url,this.onlydisplay,this.group,[this.userdata, this.user,this.phno,this.index,this.extra,this.groupdata,this.groupkey] );
  @override
  _Chart_VedioPlayerState createState() => _Chart_VedioPlayerState();
}

class _Chart_VedioPlayerState extends State<Chart_VedioPlayer> {
  VideoPlayerController _videoPlayerController;
  List<String> vediolist;
  bool network=false;
  Databasehelper   helper ;
     Dio dio=Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.group){
 helper = Databasehelper("${widget.groupkey}");
    }else{
 helper = Databasehelper("p${widget.phno.substring(1)}");
    }
    
    print("url ins ${widget.url}");
    vediolist = ['${widget.url}'];
  
    if(widget.url.contains("http",0))
    {
      network=true;
      print("its network url");
    }
    else if(widget.url.contains("https",0))
    {
      network=true;
        print("its network url");

    }
    if(network)
    {
      videodownloder();
    }
    _videoPlayerController =network?VideoPlayerController.network(widget.url.split(",")[0]) :VideoPlayerController.file(File(widget.url))
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
          print("display ${widget.onlydisplay}");
        });
      });
  }
videodownloder()async
{
    try
  {
    var dir=await getExternalStorageDirectory();
    print(dir.path);
    String url=widget.url.split(",")[0];
    String path=widget.url.split(",")[1];
await dio.download(url, "${dir.path}/$path",onReceiveProgress: ((int rec,int totle){


 print(rec/totle);

  }));

Message message=Message(toorfrom: "from", msgtype: widget.extra.data[widget.index]['msgtype'], msg: widget.extra.data[widget.index]['msg'], date: widget.extra.data[widget.index]['date'], time:widget. extra.data[widget.index]['time'], imgpath:widget. extra.data[widget.index]['msgtype']=="image"? "${dir.path}/$path": widget.extra.data[widget.index]['imgpath'], vediopath:widget. extra.data[widget.index]['msgtype']=="video"? "${dir.path}/$path": widget.extra.data[widget.index]['vediopath'], pdfpath: widget.extra.data[widget.index]['msgtype']=="pdf"? "${dir.path}/$path":widget. extra.data[widget.index]['pdfpath'], audiopath: widget. extra.data[widget.index]['msgtype']=="audio"? "${dir.path}/$path":widget. extra.data[widget.index]['audiopath'], location: "null", contact: "null");
if(widget.group){
await   helper.updatedata("${widget.groupkey}",message, widget.index+1);
}else {
await   helper.updatedata("p${widget.phno.substring(1)}",message, widget.index+1);
}

print("downlode completed ");
  }
  catch(e)
  {
  print("error got is $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.initialized
        ? InkWell(
            child: MaterialApp(
              home: Scaffold(
                body: Container(
                  child: VideoPlayer(_videoPlayerController),
                ),
                floatingActionButton:widget.onlydisplay? FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.send,
                      size: 38.0,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      var date = DateFormat.yMd().format(DateTime.now());
                       Databasehelper helper;
                      if(widget.group){
                              helper =
                          Databasehelper("p${widget.groupkey}");
                      }else{
                        helper =
                          Databasehelper("p${widget.user.substring(1)}");
                      }
                      var time = DateFormat.jm().format(DateTime.now());
                      Message message = Message(
                        toorfrom: "to",
                        msgtype: "video",
                        msg: "null",
                        date: date,
                        time: time,
                        imgpath: null,
                        vediopath: widget.url,
                        pdfpath: null,
                        audiopath: null,
                        location: null,
                        contact: null,
                     
                        
                      );
                   if(widget.group){
   var result = await helper.insertion(
                          message, "${widget.groupkey}");
                      if (result != 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Grouppage(widget.groupdata,widget.groupkey, vediolist, "video")));
                      }
                   }else{
                        var result = await helper.insertion(
                          message, "p${widget.user.substring(1)}");
                      if (result != 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Chartmsg(widget.userdata, vediolist, "video")));
                      }
                   }
                    }):Offstage()
              ),
            ),
            onTap: () {
              if (_videoPlayerController.value.isPlaying)
                _videoPlayerController.pause();
              else
                _videoPlayerController.play();
            },
          )
        : Container(
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
