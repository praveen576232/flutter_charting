import 'dart:convert';
import 'dart:io';
import 'package:charting/Chart_image_vedio_uploader.dart';
import 'package:charting/displayimage.dart';
import 'package:charting/statusuploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:storage_path/storage_path.dart';

class Imageview extends StatefulWidget {
 
  String which;
  String phno;

  String userdata;
  DocumentSnapshot groupdata;
  
  bool mulipleimag;
 Imageview(this.which, this.phno,this.mulipleimag,[this.userdata,this.groupdata]);
  @override
  _ListImageHomeState createState() => _ListImageHomeState();
}

class _ListImageHomeState extends State<Imageview> {
  int i = 0;
  List<String> selected = [];
List<String> img=[];
    Future<dynamic> getimgfiled() async {
    var data = await StoragePath.imagesPath;
      if (data != null) {
                       List data1 = json.decode(data);
                      //  print(temp);
                     //  List<String> data1=temp.cast<String>().toList();
                      for (int k = 0; k < data1?.length; k++) {
                        for (int j = 0; j < data1[k]['files']?.length; j++) {
                          if (data1[k]['files'][j] != null) {
                            setState(() {
                             img.add(data1[k]['files'][j].toString());
                              print(data1[k]['files'][j]);
                         });
                          }
                        }
                      }
                    }
 
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
            getimgfiled();
  }
  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
       debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: img?.length != 0
                  ? StaggeredGridView.countBuilder(
                      itemCount:img.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (context, index) {
                        String temp = img[index];
                        String local = null;
                        return img[index] != null
                            ? Stack(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height / 3 -
                                              20,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      color: Colors.red,
                                      child: Image.file(
                                        File(img[index]),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    onLongPress: (){
                                      if(widget.mulipleimag){
                                      if (selected.contains(img[index])) {
                                        setState(() {
                                          selected.remove(img[index]);
                                        });
                                      } else {
                                        setState(() {
                                          i++;
                                          selected.add(img[index]);
                                          local = img[index];
                                        });
                                      }
                                      }
                                    },
                                    onTap: (){
                                      setState(() {
                                        selected.add(img[index]);
                                      });
                                      if(widget.which.compareTo("group")==0){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DisplayImage("uplode",selected,true,widget.phno,null,widget.groupdata)));
                                      }else{
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DisplayImage("uplode",selected,false,widget.phno,widget.userdata)));
                                      }
                                  
                                    },
                                  ),
                                  local == temp
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Text(i.toString()),
                                          ),
                                        )
                                      : Offstage()
                                ],
                              )
                            : Container(
                                child: CircularProgressIndicator(),
                              );
                      },
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.count(2, 2);
                      },
                    )
                  : Container(
                      child: Center(
                        child: Text("No images found in your galary"),
                      ),
                    ),
              floatingActionButton: selected.length != 0
                  ? FloatingActionButton(
                      child: Text(selected.length.toString()),
                      onPressed: () {
                        print("called");
                        if (widget.which == "Chart") {
                       //      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DisplayImage("uplode",selected)));
                          // uploadchartimage();
                 //  final chartuploder=       ChartUploder(widget.users, widget.phno, selected, "image");
                 //  chartuploder.upload();
                        } else if (widget.which == "Status") {
                     final statusuploder=     StatusUploder(widget.phno, selected, "image");
                     statusuploder.upload();
                        }
                      },
                    )
                  : Offstage()),
    );
  }
}