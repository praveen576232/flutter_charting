import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocation extends StatefulWidget {
    String phno;
  String userdata;
  MyLocation([this.phno,this.userdata]);
  @override
  _MyLactionState createState() => _MyLactionState();
}

class _MyLactionState extends State<MyLocation> {
 GoogleMapController _controller;
  Location _location=Location();
  LocationData loc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getlocation();
  }
  getlocation()async
  {
    var data=await _location.getLocation();
    print("data $data");
    setState(() {
       loc=data;
  
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//  _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
     if(loc!=null)
     {
       print(loc.longitude);
     print(loc.longitude);
     }
    return Scaffold(
    body: GoogleMap(
        myLocationButtonEnabled: true,
   minMaxZoomPreference: MinMaxZoomPreference(5.0, 20.0),
                          compassEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(loc.latitude,loc.longitude),
   zoom: 13.0
       ),    
       onMapCreated: (GoogleMapController _goolemapcontroller){
         _controller=_goolemapcontroller;
         getmarker();
       },
    ),//:Container(child: Center(child: CircularProgressIndicator()))
    );
  }
  getmarker()
  {
  
  }
}