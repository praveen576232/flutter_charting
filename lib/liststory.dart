
import 'package:charting/displaystatus.dart';
import 'package:charting/imageandvediopage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';

class ListStory extends StatefulWidget {
  List<DocumentSnapshot> story=[];
  List<DocumentSnapshot>users=[];
  String phno;

  ListStory(this.story,this.users,this.phno);
  @override
  _ListStoryState createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
    List<String> menu=['Add story','Delete story'];
    List<DocumentSnapshot> img=[];
    List<DocumentSnapshot>vedio=[];
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
      imagesapter();
  }
  imagesapter(){
     
  }
  @override
  Widget build(BuildContext context) {
    print(widget.story.length);
    return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: Scaffold(
       body: ListView.builder(
         itemCount: widget.story?.length,
         itemBuilder: (context,index){
           print(index);
              return ListTile(
              leading: Container(
                height: 60,
                width: 60,
              child: CircleAvatar(
         //     backgroundImage: NetworkImage(widget.users[0].data['img']),
              ),
              ),
              title:Text("Story$index"),
             subtitle: Text(widget.story[index].data['time']),
              onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyStory(widget.story[index].data['status url'],widget.story[index].data['type'])));
              },
              trailing: PopupMenuButton<String>
           (
             color: Colors.white,
             onSelected: (selected){
                 if(selected=="Add story")
                 {
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Imageandavedio("Status",widget.phno)));
                 }
                 else if(selected=="Delete story")
                 {

                 }
             },
             itemBuilder: (BuildContext context){
               return menu.map((String m){
                   return PopupMenuItem<String>(
                     value: m,
                     child: Text(m),
                   );
               }).toList();
             },
           ) ,
            );//
         },
       ),
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.add),
         onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Imageandavedio("Status",widget.phno)));
         },
       ),
     ),
    );
  }
}
class MyStory extends StatefulWidget {
 String url;
 String type="";
  MyStory(this.url,this.type);

  @override
  _MyStoryState createState() => _MyStoryState();
}

class _MyStoryState extends State<MyStory> {
  List<StoryItem> storyitem=[];
  StoryController storyController;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print( widget.type);
    print(widget.url);
 
storyController=StoryController();
  widget.url!=null?  storyitem=[
   widget.type=="image"?

    StoryItem.pageImage(NetworkImage(widget.url),
    caption: "hello",
    shown: true
    ):StoryItem.pageVideo(   
        "https://youtu.be/zXWJLEE7LeI",
      controller: storyController,
      imageFit: BoxFit.fill,
      caption: "praveend",
      shown: true,
    //  duration: Duration(seconds: 3) 
      )
    

  ]:null;
  }
  @override
  Widget build(BuildContext context) {
    return storyitem.length!=0? StoryView(
         [
           StoryItem.pageVideo("https://firebasestorage.googleapis.com/v0/b/charting-33839.appspot.com/o/Allusers%2F%2B919110853123%2FStatus%2Fvedio%2FStatus0?alt=media&token=e780a65c-2c73-48cb-b8fa-49556f384cfb",controller: storyController,shown: true)
         //   StoryItem.pageImage(NetworkImage("https://firebasestorage.googleapis.com/v0/b/charting-33839.appspot.com/o/Allusers%2F%2B919110853123%2FStatus%2Fvedio%2FStatus0?alt=media&token=f2afc8a3-85e9-485c-b319-15cb4986ff8c")),
         ],
      controller:storyController,
      inline: false,
      repeat: false,
   onStoryShow: (s) {print("sss${s.shown}");},
      onComplete: (){
        Navigator.of(context).pop();
      },
    ):Container(child: Center(child: Text("Something went Wrong"),),);
  }
}