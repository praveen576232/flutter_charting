import 'package:charting/activehour.dart';
import 'package:charting/bootomkey.dart';
import 'package:charting/charapp.dart';
import 'package:charting/media.dart';
import 'package:charting/profile.dart';
import 'package:charting/vediofileview.dart';
import 'package:flutter/material.dart';

import 'media_list.dart';
class Botomnavigation extends StatefulWidget {
  @override
  _BotomnavigationState createState() => _BotomnavigationState();
}

class _BotomnavigationState extends State<Botomnavigation>
   {

int curentstate=0;
final tab=[
  ChartApp(),
  Media(),
  Profile(),
  
] ;
bool bootom =true;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Bootom b=new Bootom(true);
    setState(() {
      bootom=b.check();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home:Scaffold(
  
    body: tab[curentstate],
   bottomNavigationBar:bootom? 
       BottomNavigationBar(
     currentIndex: curentstate,
           
       items: [
         BottomNavigationBarItem(
           icon: Icon(Icons.home),
          title:Text("HOME")
         ),
          BottomNavigationBarItem(
           icon: Builder(builder: (context){
         return    InkWell(child: Icon(Icons.search),onLongPress: (){
 print("clicked 10 poage $curentstate");
// MediaList();
 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MediaList()));

           });
           }),
           title:Text("Media")
         ),
          BottomNavigationBarItem(
           icon: Icon(Icons.publish),
          title:Text("publish")
         ),
       ],
       onTap: (index){
         setState(() {
           curentstate=index;
         });
       },
     
   
   ):Offstage()
  
    )
    );
  }
}