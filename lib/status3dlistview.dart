import 'package:charting/statusviewer.dart';
import 'package:flutter/material.dart';
class Sataus3dview extends StatefulWidget {
  @override
  _Sataus3dviewState createState() => _Sataus3dviewState();
}

class _Sataus3dviewState extends State<Sataus3dview> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListWheelScrollView(
          itemExtent: 500,
           children: [
        //   Statusviewer(["image,https://image.shutterstock.com/image-photo/majestic-view-on-turquoise-water-260nw-266538056.jpg"]),
          //   Statusviewer(["image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg"]),
          Container(
         //  child: Statusviewer(["image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg"]),
            color: Colors.red,),
          Container(
           // child:Statusviewer(["image,https://image.shutterstock.com/image-photo/majestic-view-on-turquoise-water-260nw-266538056.jpg"]) ,
            color: Colors.green),
           Container(
          //   child: Statusviewer(["image,https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2019/07/23090714/nature-1024x682.jpeg"]),
             color: Colors.tealAccent)
             
        ])
      ),
    );
  }
}