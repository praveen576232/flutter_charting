import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// class DisplayGroupinfo extends StatelessWidget {
  
//     List<String> allusersr=[];
//   List<String>admin=[];
//   String title;
//   String creater;
//   String myname;
//   DisplayGroupinfo(this.allusersr,this.admin,this.title,this.creater,this.myname);

 
//   @override
//   Widget build(BuildContext context) {
//      if(myname!=null)
//   admin.add(myname);


//     return MaterialApp(
      
//       debugShowCheckedModeBanner: false,
//       home:DisplayGroup(allusersr,admin,title,creater));
//   }
// }


class DisplayGroup extends StatefulWidget {
     List<String> allusersr=[];
  List<String>admin=[];
  String title;
  String creater;
 
  DisplayGroup(this.allusersr,this.admin,this.title,this.creater);

  @override
  _DisplayGroupState createState() => _DisplayGroupState();
}

class _DisplayGroupState extends State<DisplayGroup> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          home:  Scaffold(
                      body: CustomScrollView(
                  slivers: <Widget>[
            SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height*0.4,
                  backgroundColor: Colors.amber,
             pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background:Image.network("https://image.shutterstock.com/image-photo/impressive-summer-view-lovatnet-lake-260nw-692930053.jpg",fit: BoxFit.cover,),
                    title: Text(widget.title),
                    ),
            ),
                  SliverList(delegate:SliverChildBuilderDelegate(
(BuildContext context,int index){
  List<String> username=widget.allusersr[index].split(",");
  print("user data is $username");
  return ListTile(
      title:username[1]!=null?Text(username[1]):Offstage(),
      subtitle:username[0]!=null? Text(username[0].substring(3)):Offstage(),
      trailing:username[0]!=null&&username[1]!=null? widget.admin.contains("${username[0]},${username[1]}")?Text("Admin",style: TextStyle(color: Colors.green),):Offstage():Offstage(),
  );
},
childCount: widget.allusersr?.length,

                   )
                   
                   )
                  ],
                ),
          ),
          
    );
  }
}