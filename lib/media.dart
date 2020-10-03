import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'media_player.dart';
class Media extends StatefulWidget {
  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  // VideoPlayerController _videoPlayerController;
  // int i=0;
  // bool puse=false;
  MethodChannel channel;
  List<String> url=[
   'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4' ,
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
  ];
  // bool like=false;
   @override
   void initState() {
   channel=MethodChannel("videoconvertor");
     super.initState();
         
   }
 
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _videoPlayerController.dispose();
  // }
  String mydata="";
  @override
  Widget build(BuildContext context) {
   

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(Icons.camera_alt,color: Colors.black,), onPressed: (){}),
          title:Text(mydata,style: TextStyle(color:Colors.black),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.send,color: Colors.black), onPressed: ()async{
           String data=await   channel.invokeMethod("video");
           setState(() {
             mydata=data;
           });
            })
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top:5),
                height: 60,
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-205,
                
                child: ListView.builder(
                  itemCount: url.length,
                  itemBuilder: (context,index){
                      return Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                       child: Column(
                         children: <Widget>[
                           Row(
                           //  crossAxisAlignment: CrossAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.end,
                             children: <Widget>[
                             CircleAvatar(),
                             SizedBox(width: 10,),
                             Text("page name"),
                             SizedBox(width: 50,),
                            Container(                              
                                  child: PopupMenuButton<String>(
                                    itemBuilder:(BuildContext context)=><PopupMenuEntry<String>>[
                                      PopupMenuItem(child: Text("one")),
                                      PopupMenuItem(child: Text("one")),
                                      PopupMenuItem(child: Text("one")),                                   
                                    ]
                                  ),
                                )
                           ],),
                           Container(
                             height: 350,
                            
                          //   child: MediaPlayer(url[index]),
                             color: Colors.black,
                           ),
                           Container(
                             height: 100,
                             child: Row(
                               children: <Widget>[
                            IconButton(icon: Icon(Icons.favorite_border,size: 45.0,), onPressed: (){}),
                            IconButton(icon: Icon(Icons.comment,size: 45.0,), onPressed: (){}),
                            IconButton(icon: Icon(Icons.bookmark_border,size: 45.0,), onPressed: (){}),
                             IconButton(icon: Icon(Icons.bookmark_border,size: 45.0,), onPressed: (){}),
                               ],
                             ),
                           )
                         ],
                       )
                      );
                }),
              )
            ],
          )
        ),
        ),
      );
 
  }
}



//     return  Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child:Stack(
//             children: <Widget>[
//               PageView.builder(
//                 scrollDirection: Axis.vertical,
//                 itemCount:url?.length,
//                 itemBuilder:(context,index){
//                 //  vedioplayer(index);
                              
//               return  GestureDetector(
//                 child:MediaPlayer(url[index]),
                
//                 onDoubleTap: (){
// setState(() {
//   like=!like;
// });
//               },
              
//               );
//   }
//                  ),
//            Align(
//              alignment: Alignment.center,
//              child:puse? IconButton(icon: Icon(Icons.play_arrow,size:100.0,color: Colors.black87.withOpacity(0.4),), onPressed: (){
            
//              }):Offstage()),
//              Positioned(
//                bottom: 50.0,
//                right:10,
//                             child: 
//                       Column(
//                         children: <Widget>[
//                              IconButton(icon: like?Icon(Icons.favorite,size: 50.0,color: Colors.red):Icon(Icons.favorite_border,size: 50.0,), onPressed: (){setState(() {
//                                like=!like;
//                              });}),
//                              SizedBox(height: 20,),
//                              IconButton(icon: Icon(Icons.message,size: 50.0,), onPressed: (){}),
//                              SizedBox(height: 20,),
//                              IconButton(icon: Icon(Icons.file_download,size: 50.0,), onPressed: (){}),
//                         ],
//                       )
             
                    
//              )
                  
//             ],
//           )
          
//     );
   