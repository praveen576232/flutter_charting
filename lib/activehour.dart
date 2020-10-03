import 'package:flutter/material.dart';
class Activehour extends StatefulWidget {
  @override
  _ActivehourState createState() => _ActivehourState();
}

class _ActivehourState extends State<Activehour> {
  final Shader liner=LinearGradient(colors: <Color>[Colors.orange,Colors.red,Colors.pink]).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0));
  List<double>value=[47,86,131,63,87,114,93];
  List<double>actaltime=[47,86,131,63,87,114,93];
  // double totlehour=0.0;
  double totleminute=0.0;
  List<String> usagetime=[];
  List<String> weeks=["mon","the","wed","thr","fri","sat","sun"];
 bool lock=false;
  double max=0;
  bool time=false;
     String tempdata="";
     String totletime;
     int avghour=0;
    int avgminu=0;
     timedata(int index){
        int t=(actaltime[index]/60).floor();
        print(t);
        int d=(actaltime[index]-(t*60)).floor();
        
       setState(() {
          if(d>=60){
          if(t!=0){
          totletime="$t h 60 m";
          // totlehour=totlehour+t;
          // totleminute=totleminute+60;
       //   usagetime.add(totletime);
          }
          else {totletime="60 m";
          // totleminute=60;
          //  usagetime.add(totletime);
          }
        }else{
          print("d is v $d");
          if(d!=0){
          if(t!=0){
            print("time $t $d");
            totletime="$t h $d m";
          //    totlehour=totlehour+t;
          // totleminute=totleminute+d;
          //  usagetime.add(totletime);
          }
          
          else {totletime="$d m";
          //  totleminute=totleminute+d;
          //   usagetime.add(totletime);
          }
        }
        else{
 if(t!=0){
            print("time $t $d");
            totletime="$t h";
            //  totlehour=totlehour+t;
            //   usagetime.add(totletime);
          }
          
          else {totletime="0 m";
          //  usagetime.add(totletime);
          }
        }
        }
       });
      
     }
  Widget barchart(double h,String week,int index){
   // tempdata.isNotEmpty?tempdata="":null;
    // tempdata= weeks[index];
   // print(tempdata);
    return Column(
mainAxisAlignment: MainAxisAlignment.end,
crossAxisAlignment: CrossAxisAlignment.center,
children: <Widget>[
   tempdata==week?  Visibility(
    visible: time,
    maintainState: true,
    maintainAnimation: true,
     child: 
      ClipPath(
        clipper: mycliper(),
              child: Container(
        height: 35,
        width: MediaQuery.of(context).size.width/7-1,
        child:totletime!=null? Center(child: Text(totletime,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)):Offstage(),
        decoration: BoxDecoration(
          color:totletime!=null? Colors.black54:Colors.white,
   borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        ),
      ),
  ):Offstage(),
   
   GestureDetector(
      child: Container(
       
       width:MediaQuery.of(context).size.width/7-1,
       height:h<=200 ?h:200,
       color:h>=140 ?Colors.lightBlue:Colors.lightBlue.withOpacity(0.4),
      ),
     
        onLongPressStart: (LongPressStartDetails detailes){
        setState(() {
         
      
         
        if(week=="mon"){
week==weeks[index]? time=true:time=false;
tempdata="mon";
timedata(index);
        }else if(week=="the"){
week==weeks[index]? time=true:time=false;
tempdata="the";
timedata(index);
            print("d $week  $h  ${weeks[index]} $tempdata");
        }else if(week=="wed"){
week==weeks[index]? time=true:time=false;
tempdata="wed";
timedata(index);
            print("d $week  $h  ${weeks[index]} $tempdata");
        }else if(week=="thr"){
          tempdata="thr";
week==weeks[index]? time=true:time=false;
timedata(index);
            print("d $week  $h  ${weeks[index]} $tempdata");
        }else if(week=="fri"){
week==weeks[index]? time=true:time=false;
tempdata="fri";
timedata(index);
        }else if(week=="sat"){
week==weeks[index]? time=true:time=false;
tempdata="sat";
timedata(index);
        }else if(week=="sun"){
week==weeks[index]? time=true:time=false;
tempdata="sun";
timedata(index);
        }
        });
        },
        onLongPressEnd: (LongPressEndDetails detailes){
        setState(() {
            time=false;
     });
        },
        ),
    Text(week)
],
    );
  }
  @override
  void initState() {
  
       print("actual time is $actaltime");
    // TODO: implement initState
    super.initState();

    value.forEach((f){
      setState(() {
         max<f?max=f:null; 
         
      });
    });
   
    if(max<=200){
      for(int i=0;i<value.length;i++){
      value[i]=value[i]+200-max;
    totleminute=totleminute+actaltime[i];
    }
    }else{   
      
        for(int i=0;i<value.length;i++){
      value[i]=(value[i]*200)/max;
     totleminute=totleminute+actaltime[i];
    }
    }
    avghour=(totleminute/(7*60)).floor();
    avgminu=((totleminute/(7)).floor()-(60*avghour)).floor();
  }
  @override
  Widget build(BuildContext context) {
    print(totleminute);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
                home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

        leading: IconButton(icon: Icon(Icons.close,color: Colors.black,), onPressed: (){
          Navigator.of(context).pop();
          
        }),
        title: Text("Your activity",style: TextStyle(color:Colors.black),),
        ),
                  body: SingleChildScrollView(
                                      child: Column(
                        children: <Widget>[
                          Container(
                           // height: 50,
                            decoration: BoxDecoration(

                            ),
                            child: RichText(
                text: TextSpan(
                text:avghour!=0? "$avghour":avgminu!=0?"$avgminu":"0",
                style: TextStyle(fontSize: 35.0,foreground: Paint()..shader=liner),
                
                children: [
               avghour!=0?    TextSpan(text:"h  ",style:TextStyle(fontSize: 15.0)  ):Offstage(),
                 avghour!=0?  TextSpan(text:"$avgminu",style:TextStyle(fontSize: 35.0)  ):Offstage(),
                    TextSpan(text:"m",style:TextStyle(fontSize: 15.0)  )

                ]
              ))

                          ),
                          Container(
                        height: 300.0,
                        child: Row(
                         //   mainAxisAlignment: MainAxisAlignment.start,
                        //    crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(width:1,),
                         value[0]!=null && weeks[0] !=null?  GestureDetector(child: barchart(value[0],weeks[0],0)):Offstage(),
                            SizedBox(width: 1,),
                         value[1]!=null && weeks[1] !=null?   GestureDetector(child: barchart(value[1],weeks[1],1)):Offstage(),
                              SizedBox(width: 1,),
                         value[2]!=null && weeks[2] !=null?    GestureDetector(child: barchart(value[2],weeks[2],2)):Offstage(),
                               SizedBox(width: 1,),
                         value[3]!=null && weeks[3] !=null?     GestureDetector(child: barchart(value[3],weeks[3],3)):Offstage(),
                                SizedBox(width: 1,),
                          value[4]!=null && weeks[4] !=null?     GestureDetector(child: barchart(value[4],weeks[4],4)):Offstage(),
                               SizedBox(width: 1,),
                           value[5]!=null && weeks[5] !=null?     GestureDetector(child: barchart(value[5],weeks[5],5)):Offstage(),
                                SizedBox(width: 1,),
                            value[6]!=null && weeks[6] !=null?     GestureDetector(child: barchart(value[6],weeks[6],6)):Offstage(),
       
                          
                          ],
                        ),
                    ),
                        ],
                    ),
                  ),
      ),
    );
  }
}


class mycliper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height-5);
    // path.quadraticBezierTo(size.width/2,  size.height, 0, size.height-5);
    // path.quadraticBezierTo(size.width/2,  size.height, size.width, size.height-5);
    path.lineTo(size.width/2, size.height);
    path.lineTo(size.width, size.height-5);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}