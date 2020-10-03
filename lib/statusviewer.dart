

import 'dart:async';

import 'package:charting/status.dart';
import 'package:charting/videoimpo.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:video_player/video_player.dart';

import 'media_player.dart';
int size=0;
double postion=0.0;

class Statusviewer extends StatefulWidget {
  List<String> status=[];
  Statusviewer(this.status);

  @override
  _StatusviewerState createState() => _StatusviewerState();
}

class _StatusviewerState extends State<Statusviewer>with SingleTickerProviderStateMixin {
Animation animation;
AnimationController animationController;
double videopostion=0.0;
int i=0;
VideoPlayerController _videoPlayerController;
 bool videolock=false;
 bool nextvideo=false;
 bool firsttext=false;
 bool poplock=false;
//   String url="video,https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
// String type="video";
// List status=[
  
//  // "text,praveend hello how are you praveen this is first story",
//   //"image,https://image.shutterstock.com/image-photo/majestic-view-on-turquoise-water-260nw-266538056.jpg",
//   //"text,PRAVEEND",
// //"image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg",
// //"image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg",
// //"image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg",
// //"video,https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
// "image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg",
// //"image,https://image.shutterstock.com/image-photo/majestic-view-on-turquoise-water-260nw-266538056.jpg",
// //"image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg",
//  //"video,https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
//  //"video,https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
// //"image,https://image.shutterstock.com/image-photo/majestic-view-on-turquoise-water-260nw-266538056.jpg",
// ];
  checkloader(ImageChunkEvent imageloder)
{
  if(imageloder==null)
  {
    print("completyle downlodeed part 1 is  ");
    
  }
  if(imageloder.cumulativeBytesLoaded==imageloder.expectedTotalBytes)
  {

 animationController.forward();
  print("completted loading");
  }
  else
  {
    animationController.stop();
    
  }
 return CircularProgressIndicator(
                              value: imageloder.expectedTotalBytes!=null?imageloder.cumulativeBytesLoaded/imageloder.expectedTotalBytes:null,
                            );
}

dumy(Widget child){
print("null value man");

animationController.forward();

return Container(child: child,);
}
@override
  void dispose() {
    // TODO: implement dispose
      if(i==widget.status.length-1){
          if(widget.status[i].toString().split(",")[0]=="video"){
        if(_videoPlayerController!=null && !_videoPlayerController.value.isPlaying && videopostion>=1.0){
    super.dispose();
    animationController.dispose();
    _videoPlayerController.dispose();
  }
          }else if(widget.status[i].toString().split(",")[0]=="image"|| widget.status[i].toString().split(",")[0]=="text"){
       if(animationController.isCompleted){
         print("dispose");
             super.dispose();
    animationController.dispose();
    _videoPlayerController.dispose();
       }
          }
      }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
 print(widget.status);
 //videopostion();


animationController=AnimationController(vsync: this,duration: Duration(seconds: 3));
animation=Tween<double>(begin: 0.0,end: 1.0).animate(animationController);
animation.addListener((){
  setState(() {
     
  });
});
  }
  progress(){
     // for(int i=0;i<status?.length;i++)
   return Container(
     
     child: Row(
children: <Widget>[
for(int j=0;j<widget.status?.length;j++)
     Container(
      height: 2,
       width:(MediaQuery.of(context).size.width/widget.status?.length)-10,
       child: LinearPercentIndicator(
                        percent:widget.status[i].toString().split(",")[0]=="image"||widget.status[i].toString().split(",")[0]=="text"?  i==j ? animation.value:i>j ?1 :0:widget.status[i].toString().split(",")[0]=="video"?i==j?videopostion:i>j?1:0:0,
                        progressColor: Colors.white,
                        backgroundColor: Colors.black87,
                      ),
     )
],
     ),
   );
  }
nextstatus(){
  if(widget.status[i].toString().split(",")[0]=="video")
          {
            if(_videoPlayerController!=null && !_videoPlayerController.value.isPlaying){
               if(widget.status[i+1].toString().split(",")[0]=="image"||widget.status[i+1].toString().split(",")[0]=="text"){
              i++;
            print(" i is $i");
            animationController.reset();
            animationController.forward();
           }
           else{
                    setState(() {
                  //    animationController.stop();
      videopostion=0.0;
      print("next123 video call in main");
      i+=1;
});
           }
            }
          }
          else{
               if(widget.status[i+1].toString().split(",")[0]=="image"||widget.status[i+1].toString().split(",")[0]=="text"){
              i++;
            print(" i is $i");
            animationController.reset();
            animationController.forward();
           }
           else{
                    setState(() {
                  //    animationController.stop();
      videopostion=0.0;
      print("next123 video call in main");
      i+=1;
});
           }
          }
}
 satuscompleted(){
   if(widget.status[i].toString().split(",")[0]=="video"){
          print("video pop123");
          _videoPlayerController.addListener((){
     if(_videoPlayerController!=null && !_videoPlayerController.value.isPlaying ){
  
 //Navigator.of(context).pop();
 if(!poplock){
   Navigator.of(context).pop();
   poplock=true;
 }
     }
     });
   }else if(widget.status[i].toString().split(",")[0]=="image"||widget.status[i].toString().split(",")[0]=="text"){
     print("image pop");
     Navigator.of(context).pop();
   }
 }
  @override
  Widget build(BuildContext context) {

// if(_videoPlayerController!=null && _videoPlayerController.value.isPlaying){
//   if(i==widget.status.length-1)
//   satuscompleted();
// _videoPlayerController.addListener((){

// if(videopostion==1.0){
//     if(i<widget.status.length-1){
// nextstatus();
//     }
    
  
// }
// });
// }
//     if(animation.isCompleted)
//     {
//    if(widget.status.length-1==i)
//   satuscompleted();
   
//       else
//       {
     
//           if(i<widget.status.length-1)
//           {
//           nextstatus();
//           }
      


     
//       }
//     }
    return MaterialApp(
     theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                progress(),
                  SizedBox(height: 3,),
                  Container(
                    height: 50,
                    color: Colors.black,
                 // child: Text(animation.value.toString()),
                  )
                ],
              ),
            ),
                      body:Stack(
                        children: <Widget>[
                         widget.status[i].toString().split(",")[0]=="image"||widget.status[i].toString().split(",")[0]=="text"? GestureDetector(
                                              child: Center(
                          child:widget.status[i].toString().split(",")[0]=="image"? Container(
                            child: Image.network(widget.status[i].toString().split(",")[1],loadingBuilder: (BuildContext context,Widget child,ImageChunkEvent imageloder){
                              print("image loader is $imageloder");
                              if(imageloder==null) return dumy(child);
                          
                              return checkloader(imageloder);
                            },),
                          ):widget.status[i].toString().split(",")[0]=="text"?textdisplay():Offstage()
                        ),
                        onHorizontalDragStart: (DragStartDetails detailes){
                          print("object $detailes");
                        },
                        onTapDown: (TapDownDetails details){
                      //    print("okkk $details");
                        },
                        onTapUp: (TapUpDetails de){
                          print("down ${de.localPosition.dx},${de.localPosition.dy}");
                          if(de.localPosition.dx>200)
                          {
     
    setState(() {
      if(i<widget.status.length-1)
      i++;
    });
                           if(i==widget.status.length-1)

    {
     // animationController.dispose();
   //    Navigator.of(context).pop();
    }
    
                          }else {
setState(() {
  if(i!=0)
  {
 setState(() {
   i--;
 });
  }
});
                          }
                        },
                        onLongPressStart: (LongPressStartDetails detatis){
                          animationController.stop();
                        },
                        onLongPressEnd: (LongPressEndDetails detaies){
                          animationController.forward();
                        },
                      ):widget.status[i].toString().split(",")[0]=="video"?
                      GestureDetector(
                                              child: Container(
                          child: videoPlayer(widget.status[i].toString().split(",")[1]),
                     
                        ),
                        
                      )//:status[i].toString().split(",")[0]=="text"?textdisplay()
                      :Offstage(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("PRAVEEND"),
                    )
                        ],
                      )
          ),
    );
  }
//   videopostion()async{
    
//     // print("postion in status is ${ await  videoinfo.getpostion()}");
//     //  print("postion in size is ${ await  videoinfo.getvideosize()}");
//   //  if(await videoinfo.getpostion()>=await videoinfo.getvideosize()&&await videoinfo.getpostion()!=0.0)
//   //  break;
//  }
 
textdisplay(){
  if(!firsttext){
    animationController.reset();
  animationController.forward();
  firsttext=true;
  }
return Container(
                        color: Colors.blueAccent,
                        child:Center(child: Text(widget.status[i].toString().split(",")[1],style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold),))
                      );
}
  
  videoPlayer(String videourl) {

// videoinfo.listen((onData){
// print("mydata is $onData");
// });

// Timer.periodic(Duration(seconds: 1), (time){
//   p=videoinfo.getvideosize();
//   s=getpostion();
// });
// Timer.periodic(Duration(seconds: 1), (time){
//   int p=videoinfo.getpostion();
//   int s=videoinfo.getvideosize();
// print("size ${videoinfo.getpostion()},postion ${videoinfo.getvideosize()}");
// if(s<=p)
// {
//   time.cancel();
// }
// });


//  print("$i video called in videoplayer functuion $videourl");
//  Videoinfo(mypostion: (a){
//    print("value osfpostion is $a");
//  });
if(!videolock){
  
 try{
   print("try");
   widget.status[i+1].toString().split(",")[0]=="video"?nextvideo=true:nextvideo=false;
   print("next video is $nextvideo");
   }
   catch(e){nextvideo=false;}
   videolock=true;
}
 return GestureDetector(
    child: StatusVideoPlayer( url: videourl,nextstatus:nextvideo,
   mypostion: (VideoPlayerController a){
setState(() {
    _videoPlayerController=a;
    //print("my final postion of video is $a");

   a.position.then((onValue){
videopostion=onValue.inSeconds/a.value.duration.inSeconds;
   });
    if(videopostion==0.0){
     // videolock=false;
    }
});
   },),
//     onTapUp: (TapUpDetails de){
//                           print("down ${de.localPosition.dx},${de.localPosition.dy}");
//                           if(de.localPosition.dx>200)
//                           {
//       if(i==status.length-1)

//     {
//      satuscompleted();
//     }
//    if(status[i+1].toString().split(",")[0]=="image"){
//               i++;
//             print(" i is $i");
//             animationController.reset();
//             animationController.forward();
//            }
//            else{
//                     setState(() {
//                   //    animationController.stop();
//                   _videoPlayerController.pause();
//       videopostion=0.0;
//       print("next123 video call in main");
//       i+=1;
// });
//            }
    
    
//                           }else {
// setState(() {
//   if(i!=0)
//   {
//     if(status[i].toString().split(",")[0]=="video")
//           {
//             if(_videoPlayerController!=null && !_videoPlayerController.value.isPlaying){
//                if(status[i-1].toString().split(",")[0]=="image"){
//               i--;
//             print(" i is $i");
//             animationController.reset();
//             animationController.forward();
//            }
//            else{
//                     setState(() {
//                   //    animationController.stop();
//       videopostion=0.0;
  
//       i-=1;
// });
//            }
//             }
//           }
//           else{
//                if(status[i-1].toString().split(",")[0]=="image"){
//               i--;
//             print(" i is $i");
//             animationController.reset();
//             animationController.forward();
//            }
//            else{
//                     setState(() {
//                   //    animationController.stop();
//       videopostion=0.0;
   
//       i-=1;
// });
//            }
//           }
//   }
// });
//                           }
//                         },
 );
  }
}




class StatusVideoPlayer extends StatefulWidget {
  String url;
 Function(VideoPlayerController) mypostion;
 bool nextstatus;
 //Function(bool) videoisplaying;
  StatusVideoPlayer(
   {@required this.url,
 @required  this.nextstatus,
    this.mypostion,
  // @required this.videoisplaying
   });
  @override
  _StatusVideoPlayerState createState() => _StatusVideoPlayerState();
}

class _StatusVideoPlayerState extends State<StatusVideoPlayer> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  String tempurl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

tempurl=widget.url;
 videoPlayerController= VideoPlayerController.network( widget.url)..initialize().then((onValue){
setState(() {
 
 videoPlayerController.play();
 size=videoPlayerController.value.duration.inSeconds;
});
 });
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   videoPlayerController.dispose();
  // }
  @override
  Widget build(BuildContext context) {
  
    if(!videoPlayerController.value.isPlaying){
     if(widget.nextstatus!=null &&widget.nextstatus){
   
      videoPlayerController= VideoPlayerController.network( widget.url)..initialize().then((onValue){
setState(() {
 
 videoPlayerController.play();
 size=videoPlayerController.value.duration.inSeconds;
});
 });
 //nextvideo=false;
      }
    }
    if(size!=0 && (videoPlayerController.value.initialized))
    {
  //  widget.videoisplaying(videoPlayerController.value.isPlaying);
     videoPlayerController.position.then((onValue){
     setState(() {
           postion=onValue.inSeconds/size;
           widget.mypostion(videoPlayerController);
      });
     });
    }
    return Center(
      child: Container(
       child: videoPlayerController.value.initialized? Center(
         child: AspectRatio(
           aspectRatio: videoPlayerController.value.aspectRatio,
           child: Container(child: VideoPlayer(videoPlayerController),)),
       ):Center(child: CircularProgressIndicator()),
        
      ),
    );
  }
}