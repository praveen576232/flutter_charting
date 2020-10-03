import 'dart:convert';
import 'dart:io';

import 'package:charting/chartmessage.dart';
import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/grouppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:storage_path/storage_path.dart';
import 'package:open_file/open_file.dart';
import 'package:thumbnails/thumbnails.dart';
class Fdf_list extends StatefulWidget {
  String user;
  String userdata;
  DocumentSnapshot groupdata;
  bool group;
  String groupkey;
  Fdf_list(this.user,this.group,[this.userdata,this.groupdata,this.groupkey]);
  @override
  _Fdf_listState createState() => _Fdf_listState();
}

class _Fdf_listState extends State<Fdf_list> {
 List<String> data=[];
 var filedata;
 var allpdf;
 List<String>selected=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  getfile();

    var list= StoragePath.filePath;
    setState(() {
      filedata=list;
    });
    list.then((pdflist){
      setState(() {
        allpdf=jsonDecode(pdflist);
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
                           helper= Databasehelper("${widget.groupkey}");
                      }else{
                               helper= Databasehelper("p${widget.user.substring(1)}");
                      }
                         
                      var time = DateFormat.jm().format(DateTime.now());
                      Message message = Message(
          
                                                toorfrom: "to",
                        msgtype: "pdf",
                        msg: "null",
                        date: date,
                        time: time,
                        imgpath: null,
                        vediopath: null,
                        pdfpath: selected[i],
                        audiopath: null,
                        location: null,
                        contact: null
                      );
                       if(widget.group){
                            result = await helper.insertion(
                          message, "${widget.groupkey}");
                       }else{
                         result = await helper.insertion(
                          message, "p${widget.user.substring(1)}");
                       }
                      
     }
     if(result!=0)
     return true;

  }
  gettumbnail(String file)async

{
  print("enter tumb");
String tumb=await Thumbnails.getThumbnail(videoFile: file,imageType: ThumbFormat.PNG,quality: 30);
print("tumb image is tumb $tumb");
} 
filereader()async
{
  File file=File("/storage/emulated/0/WhatsApp/Media/WhatsApp Documents/MITT_CSI_REGION_V.pdf");
  String data=await file.readAsString();
  print("privewe is ${data.substring(0,500)}");
}
 @override
  Widget build(BuildContext context) {
      filereader();
    print("pdf   ${allpdf[0]['files'].length}");
    print(allpdf);
        for(int i=0;i<allpdf?.length;i++)
  {
    for(int j=0;j<allpdf[i]["files"].length;j++)
    {
      data.add(allpdf[i]["files"][j]["path"]);
    }

 //  print(filepath[i]);
  }
    return Container(
    //  debugShowCheckedModeBanner: false,
       child: Scaffold(
         body:Container(
          child: StaggeredGridView.countBuilder(
       crossAxisCount: 4, 
       crossAxisSpacing: 4.0,
       mainAxisSpacing: 4.0,
       staggeredTileBuilder: (index){
         return StaggeredTile.count(2, 2);
       },
        itemBuilder: (BuildContext context,int index){
//filereader(data[index]);
print(data[index]);
          return InkWell(
                      child: Container(
              color: Colors.green,
              child: Text(data[index]),
            // child: ,
            ),
            onTap: (){
        OpenFile.open(data[index]);
          
  // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chart_VedioPlayer(vedio[index],false, widget.userdata,widget.phno,)));
            },
            onLongPress: (){
              if(selected.contains(data[index]))
              {
                setState(() {
                  selected.remove(data[index]);
                });
              }
              else{
                 setState(() {
               selected.add(data[index]);
              });
              }
             
            },
          );
        }, 
        itemCount: data?.length),
         ),
            floatingActionButton:selected?.length!=0? FloatingActionButton(
      child: Text(selected?.length.toString()),
      onPressed: ()async{
    savedata().then((check){
      if(check)
      {
    if(widget.group){
Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Grouppage(widget.groupdata,widget.groupkey, selected, "pdf")));
    }else{
      Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Chartmsg(widget.userdata, selected, "pdf")));
    }
      }
    }) ;
  
      }
    ):Offstage()
       ),
    );
  }
}