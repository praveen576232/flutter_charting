import 'package:charting/videoimpo.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'videoimpo.dart';
class MediaPlayer extends StatefulWidget {
  String url;
  int postion=0;
  int size=0;
  MediaPlayer(this.url);


  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  VideoPlayerController controller;
  Videoinfo videoinfo=Videoinfo();
bool  puse=false,play=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Media query url is ${widget.url}");
   controller=VideoPlayerController.network(widget.url)..initialize().then((_){
setState(() {
controller.play();
controller.position.then((onValue){
widget.postion=onValue.inSeconds;
});
widget.size=controller.value.duration.inSeconds;
});
   });
  // controller.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  bool first=false;
  @override
  Widget build(BuildContext context) {  print("Media query url123 is ${widget.url}");

    if(controller.value.initialized)
    {
      if(!first){
videoinfo.setvideosize(controller.value.duration.inSeconds);
first=true;
      }

controller.position.then((onValue){
 
  setState(() {
     videoinfo.setpostion(onValue.inSeconds);
  });
});
    }

    return Container(
      child: Stack(
        children: <Widget>[
          InkWell(child: VideoPlayer(controller),
      onTap: (){
  if(controller.value.isPlaying)
  {
    controller.pause();
    setState(() {
      puse=true;
    });
  }
  else {
    controller.play();
    setState(() {
      puse=false;
    });
  }
},
      ),
       Align(
             alignment: Alignment.center,
             child:puse? IconButton(icon: Icon(Icons.play_arrow,size:100.0,color: Colors.black87.withOpacity(0.4),), onPressed: (){
            
             }):Offstage()),
        ],
      )
    );
  }
}