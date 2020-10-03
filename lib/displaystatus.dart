import 'package:charting/imageandvediopage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
class DisplayStatus extends StatefulWidget {
List<DocumentSnapshot> mystatus=[];
String name="";
String photo="";
DisplayStatus(this.mystatus,this.name,this.photo);
  @override
  _DisplayStatusState createState() => _DisplayStatusState();
}

class _DisplayStatusState extends State<DisplayStatus> {
   List<StoryItem>storyitem=[];
   StoryController storyController;
   final my=StoryProgressIndicator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Image image=Image.network(widget.mystatus[0].data['status url']);
   storyController=StoryController();
   
   storyitem=[
    for(int i=0;i<widget.mystatus.length;i++)
  StoryItem.pageImage(NetworkImage(widget.mystatus[i].data['status url']))
  
  ];
  }
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
     home:Scaffold(
       body:   Stack(
       
         children: <Widget>[

           Align(
             alignment: Alignment.topLeft,
                        child: Container(
              // alignment: Alignment.topCenter,
             
              
               color: Colors.blue,
               
             ),
           ),
          StoryView(
storyitem,
controller: storyController,
onComplete: (){
Navigator.of(context).pop();
},
        ),
        
      Positioned(
        top: 60.0,
              child: Container(
          height: 30.0,
          child: Row(children: <Widget>[
            IconButton(icon: Icon(Icons.navigate_before,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pop();
            },
            ),
            CircleAvatar(
              backgroundColor: Colors.greenAccent,
              backgroundImage: widget.photo!=null?NetworkImage( widget.photo):Offstage()
            ),
            SizedBox(width: 10.0,),
            widget.name!=null? Container(child: Text( widget.name,style: TextStyle(color: Colors.white,fontSize: 25.0,fontStyle: FontStyle.italic),)):Offstage(),
            SizedBox(width: MediaQuery.of(context).size.width/2-60,),
          
          ],),
          
        ),
      )
         ],
       )
    ,
     )
    );
   
    
  }
}