import 'dart:convert';
import 'dart:io';

import 'package:charting/chart.dart';
import 'package:charting/imageview.dart';
import 'package:charting/sampleimg.dart';
import 'package:charting/status.dart';
import 'package:charting/vediofileview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storage_path/storage_path.dart';
import 'package:torch/torch.dart';
class Imageandavedio extends StatelessWidget {
  String which;
     String phno;
  Imageandavedio(this.which,this.phno);
  @override
  Widget build(BuildContext context) {
    
    return Myvedio(which,phno);
  }
}
class Myvedio extends StatefulWidget {
   String which;
   String phno;
   Myvedio(this.which,this.phno);
  @override
  _MyvedioState createState() => _MyvedioState();
}

class _MyvedioState extends State<Myvedio>with SingleTickerProviderStateMixin {
  final _scaffold=GlobalKey<ScaffoldState>();
  VoidCallback _showpersebottomsheet;
  TabController _tabController;
  CameraController cameraController;
  List<CameraDescription>camers=[];
  String path="";
  Directory dir;
  int i=0;
  bool vedio=false;
  var imagees;
  
  var vediofiles;
  List<String>imgfile=[];
  bool torchstate=false;
Future<File>  savefilepathforimageandvedio(bool image)async
{
   await getApplicationDocumentsDirectory().then((dircotry){
        setState(() {
          dir=dircotry;
        });
    });
    if(image)
    {
     File file=File(dir.path+"/"+"files"+"/"+"Pictures"+"/${Timestamp.now().seconds}.jpg");
     //await Directory(file).create(recursive: true)
     return file;
    }
    
    else
    {
     File file=File(dir.path+"/"+"story"+"/"+"vedio"+"/${Timestamp.now().seconds}.mp3");
    return file;
    }
}
Future<List<CameraDescription>>  getcam() async
  {
    print("camer data");
   
   
  // print("data is ${data[0]['files'][0]}");
  // print(imagees['files']);
      var c=await availableCameras();
      
      setState(() {
        camers=c;
      });
      return camers;
   
    //return c;
  }
 
  @override
  void initState() {
    print("init $i");
     _tabController=TabController(length: 2,vsync: this);
    // TODO: implement initState
_showpersebottomsheet=_showbottomsheet;
     inilizer();
      // getimgfiled().then((data){
    //     if(data!=null)
    // {
    //   List data=json.decode(imagees);
    // for(int i=0;i<data?.length;i++)
    // {
    //     for(int j=0;j<data[i]['files']?.length;j++)
    //     {
    //       if(data[i]['files'][j]!=null)
    //       {
    //        setState(() {
    //           imgfile.add(data[i]['files'][j]);
    //           print(data[i]['files'][j]);
    //        });
    //       }
    //     }
    // }
    // }
    //  });
    super.initState();
   
  }
  void _showbottomsheet()
  {
  setState(() {
    _showpersebottomsheet=null;
  });
 _scaffold.currentState.showBottomSheet((context){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        
        home: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
               text: "images",

              ),
              Tab(
               text: "vedio",
                
              ),
             
            ],
          ), 
          ),
           body: TabBarView(
          controller: _tabController,
          children: <Widget>[
           Imageview(widget.which,widget.phno,true),

           Vediofile(widget.phno,widget.which),
          ],
        ),
        ),
      );
 }).closed.whenComplete((){
   if(mounted)
   {
     setState(() {
       _showpersebottomsheet=_showbottomsheet;
     });
   }
 });

  }
//  Future<dynamic> getimgfiled()async{
// var temp=await StoragePath.imagesPath;
// setState(() {
//   imagees=temp;
// });
// return imagees;
//   }
  inilizer()
  {
    getcam().then((onValue){
      if(onValue?.length!=0)
      {
        print("onvalue$onValue");
          if(camers?.length!=0)
          {
            print("camer lenth${camers?.length}");
               cameraController=CameraController(camers[i], ResolutionPreset.ultraHigh);
    cameraController.initialize().then((onValue){
       if(!mounted)
       {
         return;
       }
       setState(() {
         
       });
    });
          }
      }
    });
  
  }
  getvedio() 
  {
    savefilepathforimageandvedio(false).then((file)async{
       await  cameraController.startVideoRecording(file.path).timeout(Duration(seconds: 30) );
         setState(() {
           vedio=true;
         });
    });
  }
 
  getpick(bool images) async
  {
    
   try
   {
        savefilepathforimageandvedio(images).then((path)async{
      print(path.path);
     await  cameraController.takePicture(path.path).whenComplete((){
       print("compledted");
      
     });
     if(cameraController.value.isTakingPicture)
     {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Sampleview(path)));
     }
     print(path.readAsStringSync());
    });
  
   }catch(e)
   {
     print("execption $e");
   }
  }
Future<bool>  gettorchstate() async
  {
     bool temp =await Torch.hasTorch;
     setState(() {
       torchstate=temp;
     });
     return torchstate;
  }
   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    

    if(!cameraController.value.isInitialized)
    {
      return Container(color: Colors.black,);
    }
    return  Scaffold(
    key: _scaffold,
       body:Container(
      //   height: MediaQuery.of(context).size.height-60,
         child: Stack(
             alignment: Alignment.bottomCenter,
            // mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
           Container(
           height: MediaQuery.of(context).size.height,
             color: Colors.lightGreen,
             child:CameraPreview(
              cameraController
             ),
           ),
       
       imgfile.length!=0? Column(
           mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      InkWell(
              child: Container(
          child: Center(
              child: Icon(Icons.arrow_upward),
          ),
        ),
        onTap: _showpersebottomsheet,
      ),
       Container(
             height: 100.0,
             color: Colors.blue,
           
       )
    ],
       ):Offstage()
    ],
           ),
           
       ),
         bottomNavigationBar: Container(
           height: 60.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              child: IconButton(
              icon: Icon(Icons.power),
              onPressed: (){
                gettorchstate().then((value){
                  if(value)
                  {
                    Torch.turnOn();
                  }
                  else{
                    Torch.turnOff();
                  }
                });
              },
              ),
            ),
            SizedBox(width: 20,),
            Container(
           child: GestureDetector(
                        child: FloatingActionButton(
               backgroundColor: Colors.black,
               onPressed: (){
                 print("taped");
                getpick(true);
               },
               
             ),
           onLongPress: (){
             print("long predssed");
             getvedio();
           },
           onLongPressEnd: (LongPressEndDetails details){
             print("enf$details");
           },
           ),
        ),
        SizedBox(width: 20,),
        IconButton(
          icon: Icon(Icons.switch_camera),
          onPressed: (){
if(i==0)
{

  setState(() {
    i=1;
    inilizer();
  });
  print(i);
}
else if(i==1)
{
  setState(() {
    i=0;
    inilizer();
   //cameraController =CameraController(camers[i], ResolutionPreset.ultraHigh);
  });
  print(i);
}

          },
        )
          ],
        )
      ),
      );
    
  }
}