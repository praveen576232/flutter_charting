import 'dart:typed_data';

import 'package:charting/chartmessage.dart';
import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/grouppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class List_Contact extends StatelessWidget {
  bool group;
  String phno;
  String userdata;

  DocumentSnapshot groupdata;
  List_Contact(this.group,[this.phno,this.userdata,this.groupdata]);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HomeContatct(group,phno,userdata,groupdata);
  }


  
}

class HomeContatct extends StatefulWidget {
  bool group;
  String phno;
  String userdata;

  DocumentSnapshot groupdata;
  HomeContatct(this.group,this.phno,this.userdata,this.groupdata);
  @override
  _HomeContatctState createState() => _HomeContatctState();
}

class _HomeContatctState extends State<HomeContatct> {
 List< Contact> _contact=[];
 List<Contact> selected=[];
 List<String> finalcontact=[];
  List<Contact> temp=[];
  String tempdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadcontact();
  }
  loadcontact() async
  {
    var data=await ContactsService.getContacts();
    setState(() {
      _contact=data.toList();
      temp=data.toList();
    });
  }
  bool search=false;
   Future<bool> savedata()async
  { 
    
    print("dta is $finalcontact");
    print(widget.phno);
    var result ;
    for(int i=0;i<selected?.length;i++)
     {
       var date = DateFormat.yMd().format(DateTime.now());
                      Databasehelper helper ;
                      if(widget.group){
                         helper= Databasehelper("p${widget.phno}");
                      }else{
                        helper= Databasehelper("p${widget.phno.substring(1)}");
                      }
                         
                      var time = DateFormat.jm().format(DateTime.now());
                      Message message = Message(
                     toorfrom: "to",
                        msgtype: "contact",
                        msg: "null",
                        date: date,
                        time: time,
                        imgpath: null,
                        vediopath: null,
                        pdfpath: null,
                        audiopath: null,
                        location: null,
                        contact: finalcontact[i],
                      
                      );
                     if(widget.group){
  result = await helper.insertion(
                          message, "p${widget.phno}");
                     }else{
                         result = await helper.insertion(
                          message, "p${widget.phno.substring(1)}");
                     }
                      
     }
     if(result!=0)
     return true;

  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
          home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:!search? Column(children: <Widget>[Text("Contact List to Send",style: TextStyle(color: Colors.blue),),Text("${selected?.length} selected",style: TextStyle(fontSize: 15.0,color: Colors.blue),)],):
        TextField(
          onChanged: (data){
          setState(() {
              data=data.toLowerCase();
           _contact=temp.where((test){
                 var name=test.displayName.toLowerCase()   ;
                 print(name);
               return  name.contains(data);
                 
           }).toList();
          });
          },
          decoration: InputDecoration(
            hintText: "Search Contact",
            border: InputBorder.none,
            prefixIcon: IconButton(icon: Icon(Icons.arrow_back,color: Colors.blue,), onPressed: (){
              setState(() {
                search=false;
                _contact=temp;
              });
            })
          ),
        ),
        actions: <Widget>[
         !search? IconButton(icon: Icon(Icons.search,color: Colors.blue,), onPressed: (){
            setState(() {
              search=true;
            });
          }):Offstage()
        ],
        
        ),
     body:SingleChildScrollView(
            child: Container(
         child: Column(
           children: <Widget>[
          selected?.length!=0?  Container(
               height: 70.0,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: selected?.length,
                 itemBuilder: (context,index){
                 return Padding(
                   padding: EdgeInsets.all(3.0),
                                  child: InkWell(
                                                                    child: Column(
        children: <Widget>[
          CircleAvatar(backgroundColor: Colors.blueAccent,),
          Text(selected[index].displayName)
        ],
                   ),
                   onTap: (){
                     setState(() {
                       selected.removeAt(index);
                     });
                   },
                                  ),
                 );
               }),
             ):Offstage(),
             _contact?.length!=0? SingleChildScrollView(
                          child: Container(
                 height: MediaQuery.of(context).size.height-212,

                 child: ListView.builder(
           itemCount: _contact.length,
           itemBuilder: (context,index){
      
           return  ListTile(
             leading: CircleAvatar(
             
             ),
                 title:_contact[index].givenName!=null?Text( _contact[index].givenName):Text("UNKOWN"),
            // subtitle: Text(_contact[index].phones.first.value),
            onTap: (){
              
  if(selected.contains(_contact[index]))
              {
                setState(() {
                  selected.remove(_contact[index]);
                });
              }
              else{
                 setState(() {
               selected.add(_contact[index]);
              });
              }





                
            },
           );
         }),
               ),
             ):Container(child:Text("Loding...."))
           ],
         ),
       ),
       
     ),
     floatingActionButton:selected?.length!=0? FloatingActionButton(
      child: Icon(Icons.send,size: 35.0,),
      onPressed: ()async{
      
       for(int i=0;i<selected?.length;i++)
       {
  tempdata="${selected[i].displayName},${selected[i].phones.first.value}";
            print("tempdata $tempdata");
           finalcontact.add(tempdata);
       }
  
  print("object    $finalcontact");
       savedata().then((check){
      if(check)
      {
if(widget.group){
Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Grouppage(widget.groupdata,widget.phno, finalcontact, "contact")));
}else{
  Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Chartmsg(widget.userdata, finalcontact, "contact")));
}
      }
    }) ;
      }
    ):Offstage()
      ),
    );
  }
}