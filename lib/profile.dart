import 'package:charting/activehour.dart';
import 'package:charting/create_group.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//  final GlobalKey<ScaffoldState> mykey=new GlobalKey<ScaffoldState>();

  Widget post(String name, int value) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          SizedBox(
            height: 3,
          ),
          Text(name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
        ],
      ),
    );
  }
showbottomshet(){
  showModalBottomSheet(context: context, builder: (bulid){
return Container(
   height: 100,
   width: MediaQuery.of(context).size.width,
   color: Colors.red,
         );
  });
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryIconTheme: IconThemeData(color: Colors.black)),
      home: Scaffold(
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text("create group"),
                onTap: () {
 Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Cretegroup()));

                },
              ),
              ListTile(
                leading: Icon(Icons.av_timer),
                title: Text("your activity"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Activehour()));
                },
              ),
              ListTile(
                leading: Icon(Icons.save_alt),
                title: Text("saved"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.menu),
                title: Text("friend"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text("your acount"),
                onTap: () {},
              ),
               ListTile(
                leading: Icon(Icons.settings),
                title: Text("setting"),
                onTap: () {

                  
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: InkWell(
                      child: Row(
              children: <Widget>[
                Text("praveen ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                Icon(Icons.arrow_drop_down)
              ],
            ),
            onTap: (){
showbottomshet();
            },
          )
        ),
        body: SingleChildScrollView(
                  child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 140,
                            width: 140.0,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  height: 140,
                                  width: 140.0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.orange,
                                  ),
                                ),
                                Positioned(
                                  top: 100,
                                  left: 100,
                                  child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    child: CircleAvatar(
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "praveend",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          )
                        ],
                      ),
                      post("Posts", 0),
                      post("Followers", 62),
                      post("Following", 108)
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {},
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                     
                      decoration: BoxDecoration(
 color: Colors.black38,
 borderRadius: BorderRadius.all(Radius.circular(8.00))



                      ),
                      child: Center(
                        child: Text(
                          "Edit Profile",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
     
      ),
    );
  }
}
