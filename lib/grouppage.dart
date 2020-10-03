import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:charting/Chart_image_vedio_uploader.dart';
import 'package:charting/bootomkey.dart';
import 'package:charting/chart_vedioplayer.dart';
import 'package:charting/contact_list.dart';

import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/displaygroupinfo.dart';
import 'package:charting/imageandvediopage.dart';
import 'package:charting/imageview.dart';
import 'package:charting/loadmessage.dart';
import 'package:charting/location.dart';
import 'package:charting/music.dart';
import 'package:charting/pdf_list.dart';
import 'package:charting/status.dart';
import 'package:charting/vediofileview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:storage_path/storage_path.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thumbnails/thumbnails.dart';

class Grouppage extends StatefulWidget {
  DocumentSnapshot userdata;
  List<String> uplodefile = [];
  String type;
  String id;
  String groupkey;
  Grouppage(this.userdata, this.groupkey,
      [this.uplodefile, this.type, this.id]);

  @override
  _HomeChartState createState() => _HomeChartState();
}

class _HomeChartState extends State<Grouppage>
    with SingleTickerProviderStateMixin {
  String photo;
  String phno;
  String name;

  List<String> allgroupdata = [];
  TextEditingController controller = TextEditingController();
  Dio dio = Dio();
  FlutterSound flutterSound = new FlutterSound();
  bool scrooldownone = true;
  String myphone = "";
  String typetext = "";
  bool messagerecive = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  bool checkfile = false;
  List<DocumentSnapshot> inputmsg = [];
  StreamSubscription streamSubscription;
  List<DocumentSnapshot> messagesusers = [];
  bool found = false;
  Loadmessage loadmessage;
  var alldata;
  Animation<double> _animation;
  AnimationController _animationController;
  bool attachment = false;
  var imagees;
  bool emoje = false;
  ScrollController scrollController;
  bool textfiledview = false;
  bool uploded = false;
  List<String> imgfile = [];
  AudioPlayer audioPlayer;
  var myapplicationpath;
  bool checkfiledata = false;
  bool videodownloder = false;
  bool pdfdownloder = false;
  bool audiodownloder = false;
  AudioPlayerState audioPlayerState;

  File fin;
  bool micaviable = false;
  double progresbar = 0.0;
  String videoimage = "";
  List<String> admin = [];
  // String online;
  bool once = false;
  bool cleartiy1 = false;
  List<String> avoid_message = [];
  Future<String> getphno() async {
    await FirebaseAuth.instance.currentUser().then((onValue) {
      setState(() {
        myphone = onValue.phoneNumber;
        print(myphone);
        return myphone;
      });
    });
  }

  stt.SpeechToText speechToText = stt.SpeechToText();
  Databasehelper helper;
  String myname;
  @override
  void initState() {
    super.initState();
    print("object data ${widget.groupkey}");

    phno = widget.groupkey;
    name = widget.userdata.data['name'];
    photo = widget.userdata.data['img'];
    if( widget.userdata.data['avoid_msg']!=null)
    avoid_message = widget.userdata.data['avoid_msg'].cast<String>().toList();
   if( widget.userdata.data['normal_user']!=null){
    allgroupdata = widget.userdata.data['normal_user'].cast<String>().toList();
    }
    if( widget.userdata.data['admin']!=null)
    admin = widget.userdata.data['admin'].cast<String>().toList();
    createdir();
    helper = Databasehelper("$phno");

    getdata();
    audioPlayer = AudioPlayer();

    audioPlayerState = AudioPlayerState.STOPPED;
    loadmessage = Loadmessage("$phno");
    getphno().then((phno) async {
      getinputmsg();
      if (widget.uplodefile != null) {
        if (widget.uplodefile?.length != 0) {
          for (int i = 0; i < widget.uplodefile?.length; i++) {
            final chartuploder = ChartUploder(
                true, phno, myphone, widget.uplodefile[i], widget.type);
            uploded = await chartuploder.upload();
            print("upload status is $uploded");
          }
        }
      }
    });

    scrollController = ScrollController();
    // scrollController.j
    //print(scrollController.position.maxScrollExtent);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    getdirectry().then((file) {
      print(file);
      myapplicationpath = file;
    });
    speech();
    CollectionReference collectionReference1 = Firestore.instance
        .collection("Allusers")
        .document(phno)
        .collection(phno);
    streamSubscription = collectionReference1.snapshots().listen((onData) {
      setState(() {
        var users = onData.documents;
        // online=users[0].data['curent_status'];
        myname=onData.documents[0].data['name'];

    //     if(myname!=null){
    //              if( widget.userdata.data['normal_user']!=null){
    // allgroupdata = widget.userdata.data['normal_user'].cast<String>().toList();
    // allgroupdata.remove("$myphone,$myname");
    // }
    //     }
      });
    });
  }

  speech() async {
    micaviable = await speechToText.initialize();
  }

  Future<int> insertdata(Message message, String phno) async {
    alldata = await helper.insertion(message, phno);

    setState(() {});
    return alldata;
  }

  addonline(Map map) {
    once = true;
    Firestore.instance
        .collection("Allusers")
        .document(myphone)
        .collection(myphone)
        .document(widget.id)
        .updateData(map);
  }

  getinputmsg() {
    StreamSubscription subscription;
    getuser().then((pphno) {
      CollectionReference collectionReference = Firestore.instance
          .collection("Allusers")
          .document(pphno)
          .collection("messages");
      subscription = collectionReference.snapshots().listen((data) {
        setState(() {
          print("mydata is ${data.documents}");
          inputmsg = data.documents;
        });
      });
    });
  }

  Future getuser() async {
    user = await firebaseAuth.currentUser();

    var phno = user.phoneNumber;

    return phno;
  }

  getdata() async {
    alldata = await helper.getallresult("$phno");
  }

  checkmessages(String userphone) async {
    print("enter message");
    bool hold = false;
    if (!hold) {
      if (inputmsg?.length != 0) {
        if (inputmsg[0] != null) {
          for (int i = 0; i < inputmsg.length; i++) {
            String msgtype = inputmsg[0].data['msgtype'];
            String message1 = inputmsg[0].data['message'].toString();
            String date = inputmsg[0].data['date'];
            String time = inputmsg[0].data['time'];
            String imgpath =
                "${inputmsg[0].data['imgpath'].toString()},${inputmsg[0].data['filename'].toString()}";
            String vediopath =
                "${inputmsg[0].data['vediopath'].toString()},${inputmsg[0].data['filename'].toString()}";
            String pdfpath =
                "${inputmsg[0].data['pdfpath'].toString()},${inputmsg[0].data['filename'].toString()}";
            String audiopath =
                "${inputmsg[0].data['audiopath'].toString()},${inputmsg[0].data['filename'].toString()}";
            String location = inputmsg[0].data['location'].toString();
            String contact = inputmsg[0].data['contact'].toString();
            try {
              if (!hold) {
                Message message = Message(
                    toorfrom: "from",
                    msgtype: msgtype,
                    msg: message1,
                    date: date,
                    time: time,
                    imgpath: imgpath,
                    vediopath: vediopath,
                    pdfpath: pdfpath,
                    audiopath: audiopath,
                    location: location,
                    contact: contact);
                //    await helper.insertion(message, "p${userphone.substring(1)}");
                await helper.insertion(message, "$phno").then((data) {
                  if (data != 0) {
                    print("added data $data");
                    String id = inputmsg[0].documentID;

                    Firestore.instance
                        .collection("Allusers")
                        .document(myphone)
                        .collection("messages")
                        .document(id)
                        .delete()
                        .whenComplete(() {
                      //  countmsg.containsKey(tempusers);
                      setState(() {});
                      hold = true;
                      cleartiy1 = true;
                    });
                  }
                });
              }
            } catch (e) {
              print(e);
            }
            print("message is $message1,  $msgtype $time $date ");
          }
        }
      }
    }
  }

  var checkingfile = true;
  bool downloded = false;
  Future<String> getdirectry() async {
    var s = await getExternalStorageDirectory();

    return Future.value(s.path);
  }

  Future<bool> checkdata(File file) async {
    bool check = await file.exists();
    return Future.value(check);
  }

  Future downlode(String url, String path, int index,
      AsyncSnapshot<List<Map<String, dynamic>>> extra) async {
    try {
      var dir = await getExternalStorageDirectory();
      print(dir.path);
      print("satatus1 is ${dio.options.validateStatus}");
      await dio.download(url, "${dir.path}/$path",
          onReceiveProgress: ((int rec, int totle) {
        print("satatus2 is ${dio.options.validateStatus}");
        setState(() {
          progresbar = rec / totle;
        });
      }));

      Message message = Message(
          toorfrom: "from",
          msgtype: extra.data[index]['msgtype'],
          msg: extra.data[index]['msg'],
          date: extra.data[index]['date'],
          time: extra.data[index]['time'],
          imgpath: extra.data[index]['msgtype'] == "image"
              ? "${dir.path}/$path"
              : extra.data[index]['imgpath'],
          vediopath: extra.data[index]['msgtype'] == "video"
              ? "${dir.path}/$path"
              : extra.data[index]['vediopath'],
          pdfpath: extra.data[index]['msgtype'] == "pdf"
              ? "${dir.path}/$path"
              : extra.data[index]['pdfpath'],
          audiopath: extra.data[index]['msgtype'] == "audio"
              ? "${dir.path}/$path"
              : extra.data[index]['audiopath'],
          location: "null",
          contact: "null");
      await helper.updatedata("$phno", message, index + 1);
      print("satatus is ${dio.options.validateStatus}");
      setState(() {
        checkingfile = true;
        downloded = true;
      });
    } catch (e) {
      print("error got is $e");
    }
  }

  loadimage(
      String path, int index, AsyncSnapshot<List<Map<String, dynamic>>> extra) {
    List<String> url = path.split(",");
    File file = File("$myapplicationpath/${url[1]}");
    checkdata(file).then((onValue) {
      checkingfile = onValue;
      if (!onValue) {
        if (url[0] != null) {
          //  downlode(url[0], "${url[1]}", index, extra);
        }
      } else {
        print("alerady data is found");
        checkingfile = true;
      }
    });
    return checkingfile
        ? extra.data[index]['msgtype'] == "image"
            ? Image.file(
                file,
                fit: BoxFit.fill,
              )
            : checkingfile
                ? Align(
                    alignment: extra.data[index]['msgtype'] == "video"
                        ? Alignment.bottomLeft
                        : Alignment.centerRight,
                    child: !downloded
                        ? InkWell(
                            child: CircularPercentIndicator(
                              radius: 42.0,
                              progressColor: Colors.green,
                              percent: progresbar,
                            ),
                            onTap: () {
                              // dio.lock();
                            },
                          )
                        : Offstage())
                : Text("progresbar.toString()")
        : Text("progresbar.toString()");
  }

  bool temp = true;
  createdir() async {
    File file = File("/storage/emulated/0/Charting");

    var create = await file.create();
    print("file created $create");
  }

  Future<String> tumbnaile() async {
    print("enter tumb");
    String tumb = await Thumbnails.getThumbnail(
        videoFile:
            "/storage/emulated/0/WhatsApp/Media/WhatsApp Video/VID-20200220-WA0000.mp4",
        imageType: ThumbFormat.PNG,
        quality: 30);

    if (tumb != null) return Future.value(tumb);
  }

  getvideoimage() {
    tumbnaile().then((onValue) {
      videoimage = onValue;
    });
    return videoimage != null
        ? Image.file(
            File(videoimage),
            fit: BoxFit.fill,
          )
        : Container(color: Colors.red);
  }

  getOnlinedata(String lastonline) {
    bool today1 = false;
    bool yesterday = false;
    if (lastonline != null) {
      var today_date = DateFormat.yMd().format(DateTime.now());

      List<String> mydate = today_date.toString().split("/");

      List<String> text_date = lastonline.split(',')[1].split("/");
      final date2 = DateTime(
          int.parse(mydate[2]), int.parse(mydate[0]), int.parse(mydate[1]));
      final date1 = DateTime(int.parse(text_date[2]), int.parse(text_date[0]),
          int.parse(text_date[1]));
//int.parse(mydate[2]),int.parse(mydate[1]),int.parse(mydate[0])   int.parse(text_date[2]),int.parse(text_date[1]),int.parse(text_date[0])

      if (date1.difference(date2).inDays == 0) {
        today1 = true;
      } else if (date1.difference(date2).inDays == -1) {
        yesterday = true;
      }
    }
    return today1
        ? "active on today at ${lastonline.split(',')[0]}"
        : yesterday
            ? "active on yesterday at ${lastonline.split(',')[0]}"
            : "active on  ${lastonline.split(',')[1]} at ${lastonline.split(',')[0]}";
  }

  messagetypecheck(String message) {
    if (message.length >= 10) {
      if (message.startsWith("https://")) {
        if (message.contains(".", 9)) {
          if (!message.endsWith(".")) {
            return true;
          }
        }
      } else if (message.startsWith("http://")) {
        if (message.contains(".", 8)) {
          if (!message.endsWith(".")) {
            return true;
          }
        }
      } else if (message.endsWith("@gmail.com")) {
        return true;
      }
    }
    return false;
  }

  checkdigitmessage(String msg) {
    if (msg.length <= 13) {}

    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dio.close();
  }

  @override
  Widget build(BuildContext context) {
    print("cleartity is $allgroupdata");
    // if(!cleartiy1)
    // {
print("my name is $myname");
    if (inputmsg.length != 0) {
      print("calledd message");
      checkmessages(phno);
      print("inside loop 1234567890");
    }

    // }

    print("input length is ${inputmsg.length}");
    String number = "1234532542";
    if (number.length == 10) {
      try {} catch (e) {}
    } else if (number.length == 13) {}

    if (controller.text.length != 0) {
      Map<String, String> map = Map();
      map["curent_status"] = "typing...";
      // addonline(map);
      once = false;
    } else if (!once) {
      Map<String, String> map = Map();
      map["curent_status"] = "online";
      // addonline(map); //update  online
    }
    scrooldownone
        ? Timer(
            Duration(milliseconds: 2000),
            () => scrollController
                .jumpTo(scrollController.position.maxScrollExtent))
        : Offstage();
    scrooldownone = false;

    if (alldata != null) {
    } else {
      getdata();
    }
    scrollController.addListener(() {
      print(scrollController.offset);
      setState(() {
        scrollController.offset < scrollController.position.maxScrollExtent
            ? textfiledview = true
            : textfiledview = false;
      });
    });

    today1(String lastdate, int index) {
      bool today1 = false;
      bool yesterday = false;

      var today_date = DateFormat.yMd().format(DateTime.now());

      List<String> mydate = today_date.toString().split("/");
      List<String> text_date = lastdate.split("/");
      final date2 = DateTime(
          int.parse(mydate[2]), int.parse(mydate[0]), int.parse(mydate[1]));
      final date1 = DateTime(int.parse(text_date[2]), int.parse(text_date[0]),
          int.parse(text_date[1]));
//int.parse(mydate[2]),int.parse(mydate[1]),int.parse(mydate[0])   int.parse(text_date[2]),int.parse(text_date[1]),int.parse(text_date[0])

      if (date1.difference(date2).inDays == 0) {
        today1 = true;
      } else if (date1.difference(date2).inDays == -1) {
        yesterday = true;
      }
      return Container(
        //  color: Colors.red,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                  height: 30,
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.lightGreen.withOpacity(0.5)),
                  child: yesterday
                      ? Align(
                          alignment: Alignment.center, child: Text("yesterday"))
                      : today1
                          ? Align(
                              alignment: Alignment.center,
                              child: Text("TODAY", textAlign: TextAlign.center))
                          : Align(
                              alignment: Alignment.center,
                              child:
                                  Text(lastdate, textAlign: TextAlign.center))),
            )
          ],
        ),
      );
    }

    return Container(
        // debugShowCheckedModeBanner: false,
        //  home: Scaffold(

        //  ),
        // child:   // debugShowCheckedModeBanner: false,
        child: Scaffold(
            appBar: AppBar(
                leading: Container(
                  height: 5.0,
                  width: 5.0,
                  child: photo != null
                      ? CircleAvatar(
                          //   backgroundImage: NetworkImage(photo),
                          )
                      : Offstage(),
                ),
                title: InkWell(
                  child: Column(
                      children: <Widget>[
                        name != null ? Text(name) : Offstage(),
                        //   online!=null?online=="online" || online=="typing..." ?Text(online):Text(  getOnlinedata(online),style: TextStyle(fontSize: 15.0,fontStyle: FontStyle.normal),):Offstage()
                      ],
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DisplayGroup(allgroupdata,admin,name,widget.userdata.data['creater'])
                      ));
                      
                    },
                  )),
            body: Stack(
              children: <Widget>[
                GestureDetector(
                  child: alldata?.length != 0 && alldata != null
                      ? StreamBuilder<List<Map<String, dynamic>>>(
                          stream: loadmessage.allmessage,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ?
                                //   height: MediaQuery.of(context).size.height,
                                ///  width: MediaQuery.of(context).size.width-100,

                                Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.separated(
                                        // reverse: true,
                                        controller: scrollController,
                                        separatorBuilder: (context, index) {
                                          print(index);
                                          return index == 0
                                              ? today1(
                                                  snapshot.data[index + 1]
                                                          ['date']
                                                      .toString(),
                                                  index)
                                              : snapshot.data[index + 1]['date']
                                                          .toString()
                                                          .compareTo(snapshot
                                                              .data[index]
                                                                  ['date']
                                                              .toString()) !=
                                                      0
                                                  ? today1(
                                                      snapshot.data[index + 1]
                                                              ['date']
                                                          .toString(),
                                                      index)
                                                  : SizedBox(
                                                      height: 10.0,
                                                    );
                                        },
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          return snapshot.data[index]
                                                      ['msgtype'] ==
                                                  "msg"
                                              ? Align(
                                                  alignment: snapshot.data[index]
                                                              ['toorfrom'] ==
                                                          "to"
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        color: getcolor(
                                                            snapshot.data[index]
                                                                ['toorfrom']),
                                                      ),
                                                      child: ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      50.0,
                                                                  minWidth:
                                                                      50.0,
                                                                  //   maxHeight: 500.0,
                                                                  maxWidth:
                                                                      300.0),
                                                          child: InkWell(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    "from moblie number"),
                                                                RichText(
                                                                  //   textAlign: TextAlign.end,
                                                                  text: TextSpan(
                                                                      text:
                                                                          " ${snapshot.data[index]['msg']}",
                                                                      style: TextStyle(
                                                                          color: messagetypecheck(snapshot.data[index]['msg'])
                                                                              ? Colors.blue
                                                                              : Colors.black),
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              "  ${snapshot.data[index]['time']}",
                                                                          style: TextStyle(
                                                                              color: Colors.blue,
                                                                              fontSize: 13.0),
                                                                        )
                                                                      ]),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              print(
                                                                  "click  ${messagetypecheck(snapshot.data[index]['msg'])}");
                                                              messagetypecheck(
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'msg'])
                                                                  ? OpenFile.open(snapshot
                                                                      .data[
                                                                          index]
                                                                          [
                                                                          'msg']
                                                                      .toString())
                                                                  : Offstage();
                                                            },
                                                            onLongPress: () {
                                                              messagetypecheck(
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'msg'])
                                                                  ? Clipboard.setData(ClipboardData(
                                                                          text: snapshot.data[index]
                                                                              [
                                                                              'msg']))
                                                                      .whenComplete(
                                                                          () {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Link copied",
                                                                          gravity: ToastGravity
                                                                              .CENTER,
                                                                          toastLength:
                                                                              Toast.LENGTH_LONG);
                                                                    })
                                                                  : Offstage();
                                                            },
                                                          ))))
                                              : snapshot.data[index]['msgtype'] ==
                                                      "image"
                                                  ? Align(
                                                      alignment: snapshot.data[
                                                                      index][
                                                                  'toorfrom'] ==
                                                              "to"
                                                          ? Alignment
                                                              .centerRight
                                                          : Alignment
                                                              .centerLeft,
                                                      child: Container(
                                                        height: 300,
                                                        width: 200,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Container(
                                                                height: 300,
                                                                width: 200,
                                                                child: snapshot.data[index]
                                                                            [
                                                                            'toorfrom'] ==
                                                                        "to"
                                                                    ? Image.file(
                                                                        File(snapshot.data[index]
                                                                            [
                                                                            'imgpath']),
                                                                        fit: BoxFit
                                                                            .fill)
                                                                    : loadimage(
                                                                        "https://media.gettyimages.com/photos/pink-morning-at-lodhi-gardens-picture-id695641506?s=612x612,mynature9.jpg",
                                                                        index,
                                                                        snapshot)),
                                                            !checkingfile
                                                                ? Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child:
                                                                        CircularPercentIndicator(
                                                                      radius:
                                                                          42.0,
                                                                      progressColor:
                                                                          Colors
                                                                              .green,
                                                                      percent:
                                                                          progresbar,
                                                                    ))
                                                                : Offstage(),
                                                            Align(
                                                                child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      ['time'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                alignment: Alignment
                                                                    .bottomRight),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : snapshot.data[index]
                                                              ['msgtype'] ==
                                                          "video"
                                                      ? Align(
                                                          alignment: snapshot.data[
                                                                          index]
                                                                      [
                                                                      'toorfrom'] ==
                                                                  "to"
                                                              ? Alignment
                                                                  .centerRight
                                                              : Alignment
                                                                  .centerLeft,
                                                          child: InkWell(
                                                            child: Container(
                                                              height: 300,
                                                              width: 200,
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      height:
                                                                          300,
                                                                      width:
                                                                          200,
                                                                      child: snapshot.data[index]['toorfrom'] ==
                                                                              "from"
                                                                          ? getvideoimage()
                                                                          : Offstage()),
                                                                  !videodownloder &&
                                                                          snapshot.data[index]['videopath'].toString().contains(
                                                                              "https",
                                                                              0)
                                                                      ? Align(
                                                                          child:
                                                                              IconButton(
                                                                                  icon:
                                                                                      Icon(
                                                                                    Icons.file_download,
                                                                                    size: 30.0,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  onPressed:
                                                                                      () {
                                                                                    setState(() {
                                                                                      videodownloder = true;
                                                                                    });
                                                                                  }),
                                                                          alignment: Alignment
                                                                              .bottomLeft)
                                                                      : snapshot.data[index]['videopath'].toString().contains(
                                                                              "https",
                                                                              0)
                                                                          ? loadimage(
                                                                              "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4,myvideo5.mp4",
                                                                              index,
                                                                              snapshot)
                                                                          : Offstage(),
                                                                  Align(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .play_circle_filled,
                                                                        size:
                                                                            40.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center),
                                                                  Align(
                                                                      child:
                                                                          Text(
                                                                        snapshot.data[index]
                                                                            [
                                                                            'time'],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) => Chart_VedioPlayer(
                                                                          " /storage/emulated/0/Android/data/com.example.charting/files/myvideo.mp4",
                                                                          false,
                                                                          true,
                                                                          "",
                                                                          "",
                                                                          phno,
                                                                          index,
                                                                          snapshot)));
                                                            },
                                                          ),
                                                        )
                                                      : snapshot.data[index]
                                                                  ['msgtype'] ==
                                                              "pdf"
                                                          ? Align(
                                                              alignment: snapshot
                                                                              .data[index]
                                                                          [
                                                                          'toorfrom'] ==
                                                                      "to"
                                                                  ? Alignment
                                                                      .centerRight
                                                                  : Alignment
                                                                      .centerLeft,
                                                              child: InkWell(
                                                                child:
                                                                    Container(
                                                                  height: 100,
                                                                  width: 200,
                                                                  child: Stack(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            200,
                                                                        color: Colors
                                                                            .black45,
                                                                      ),
                                                                      Align(
                                                                          child: Container(
                                                                              height: 60.0,
                                                                              width: 60.0,
                                                                              child: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  snapshot.data[index]['pdfpath'].toString().split(".")[1],
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 25.0),
                                                                                ),
                                                                              ),
                                                                              color: Colors.black12),
                                                                          alignment: Alignment.centerLeft),
                                                                      !pdfdownloder &&
                                                                              snapshot.data[index]['pdfpath'].toString().contains("https", 0)
                                                                          ? Align(
                                                                              child: IconButton(
                                                                                  icon: Icon(
                                                                                    Icons.file_download,
                                                                                    size: 30.0,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      pdfdownloder = true;
                                                                                    });
                                                                                  }),
                                                                              alignment: Alignment.centerRight)
                                                                          : snapshot.data[index]['pdfpath'].toString().contains("https", 0) ? loadimage("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4,myvideo5.mp4", index, snapshot) : Offstage(),
                                                                      Align(
                                                                          child:
                                                                              Text(
                                                                            snapshot.data[index]['time'],
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.bottomRight),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  snapshot.data[
                                                                              index]
                                                                              [
                                                                              'pdfpath']
                                                                          .toString()
                                                                          .contains(
                                                                              "https",
                                                                              0)
                                                                      ? loadimage(
                                                                          "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4,myvideo5.mp4",
                                                                          index,
                                                                          snapshot)
                                                                      : OpenFile
                                                                          .open(snapshot.data[index]
                                                                              [
                                                                              'pdfpath']);
                                                                },
                                                              ),
                                                            )
                                                          : snapshot.data[index][
                                                                      'msgtype'] ==
                                                                  "audio"
                                                              ? Align(
                                                                  alignment: snapshot.data[index]
                                                                              [
                                                                              'toorfrom'] ==
                                                                          "to"
                                                                      ? Alignment
                                                                          .centerRight
                                                                      : Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      InkWell(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50.0,
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          Stack(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                200,
                                                                            color:
                                                                                Colors.black45,
                                                                          ),
                                                                          Align(
                                                                              child: Container(
                                                                                  height: 60.0,
                                                                                  width: 60.0,
                                                                                  child: Align(
                                                                                      alignment: Alignment.center,
                                                                                      child: IconButton(
                                                                                          icon: Icon(audioPlayerState == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
                                                                                          onPressed: () {
                                                                                            if (!snapshot.data[index]['audiopath'].toString().contains("https", 0)) {
                                                                                              if (audioPlayerState == AudioPlayerState.STOPPED) {
                                                                                                audioPlayer.play(snapshot.data[index]['audiopath'], isLocal: true); //audiopath not defined
                                                                                                setState(() {
                                                                                                  audioPlayerState = AudioPlayerState.PLAYING;
                                                                                                });
                                                                                              } else if (audioPlayerState == AudioPlayerState.PLAYING) {
                                                                                                audioPlayer.stop();
                                                                                                setState(() {
                                                                                                  audioPlayerState = AudioPlayerState.STOPPED;
                                                                                                });
                                                                                              }
                                                                                            } else {
                                                                                              loadimage("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4,myvideo5.mp4", index, snapshot);
                                                                                            }
                                                                                          })),
                                                                                  color: Colors.black12),
                                                                              alignment: Alignment.centerLeft),
                                                                          !audiodownloder && snapshot.data[index]['audiopath'].toString().contains("https", 0)
                                                                              ? Align(
                                                                                  child: IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.file_download,
                                                                                        size: 30.0,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          audiodownloder = true;
                                                                                        });
                                                                                      }),
                                                                                  alignment: Alignment.centerRight)
                                                                              : snapshot.data[index]['audiopath'].toString().contains("https", 0) ? loadimage("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4,myvideo5.mp4", index, snapshot) : Offstage(),
                                                                          Align(
                                                                              child: Text(
                                                                                snapshot.data[index]['time'],
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              alignment: Alignment.bottomRight),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : snapshot.data[index]
                                                                          ['msgtype'] ==
                                                                      "contact"
                                                                  ? Align(
                                                                      alignment: snapshot.data[index]['toorfrom'] ==
                                                                              "to"
                                                                          ? Alignment
                                                                              .centerRight
                                                                          : Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          InkWell(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              70.0,
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              Stack(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                height: 70,
                                                                                width: 200,
                                                                                color: Colors.lightGreenAccent,
                                                                                child: Text(
                                                                                  snapshot.data[index]['contact'].toString().split(",")[0],
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 20.0),
                                                                                ),
                                                                              ),
                                                                              Align(
                                                                                  child: Text(
                                                                                    snapshot.data[index]['time'],
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                  alignment: Alignment.bottomRight),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  content: Row(
                                                                                    children: <Widget>[
                                                                                      Text(snapshot.data[index]['contact'].toString().split(",")[0]),
                                                                                      SizedBox(
                                                                                        width: 10.0,
                                                                                      ),
                                                                                      IconButton(
                                                                                          icon: Icon(
                                                                                            Icons.call,
                                                                                            color: Colors.blue,
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            await launch("tel:${snapshot.data[index]['contact'].toString().split(",")[1]}");
                                                                                          })
                                                                                    ],
                                                                                  ),
                                                                                  actions: <Widget>[
                                                                                    FlatButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: Text("Cancle")),
                                                                                    FlatButton(
                                                                                        color: Colors.green,
                                                                                        onPressed: () {
                                                                                          List<Item> p = [];
                                                                                          Item s = Item(label: "phones", value: snapshot.data[index]['contact'].toString().split(",")[1]);
                                                                                          p.add(s);
                                                                                          Iterable<Item> phnoes = p;
                                                                                          print(phnoes.first);
                                                                                          Contact contact = Contact(givenName: snapshot.data[index]['contact'].toString().split(",")[0], displayName: snapshot.data[index]['contact'].toString().split(",")[0], phones: phnoes);
                                                                                          ContactsService.addContact(contact).whenComplete(() {
                                                                                            Fluttertoast.showToast(toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, msg: "Contact added");
                                                                                            Navigator.of(context).pop();
                                                                                          });
                                                                                        },
                                                                                        child: Text("Add")),
                                                                                  ],
                                                                                );
                                                                              });
                                                                        },
                                                                      ),
                                                                    )
                                                                  : Offstage();
                                        }),
                                  )
                                : Offstage();
                          },
                        )
                      : Container(height: 10.0, color: Colors.limeAccent),
                  onTap: () {
                    setState(() {
                      emoje = false;

                      if (_animation.status == AnimationStatus.completed) {
                        setState(() {
                          //
                          _animationController.reverse().then((_) {
                            print("complredf anim ");
                            setState(() {
                              attachment = false;
                              // attachment2 = true;
                            });
                          });
                        });
                      }
                      if (_animation.status == AnimationStatus.dismissed) {
                        print("yes dismiseed ");
                        _animationController.forward();
                      }
                    });
                  },
                ),
                textfiledview
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            child: IconButton(
                                icon: Icon(Icons.keyboard_arrow_down),
                                onPressed: () {
                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                })),
                      )
                    : Offstage()
              ],
            ),
            bottomNavigationBar: widget.userdata.data['admin_only']
                ? admin.contains(myphone)
                    ? bottomshete()
                    : Container(
                        height: 32.0,
                        color: Colors.teal,
                        child: Text("Admin Only Chart",
                            textAlign: TextAlign.center))
                : bottomshete()));
  }

  Color getcolor(String data) {
    switch (data) {
      case "to":
        return Colors.lightGreen.withOpacity(0.8);
        break;
      case "from":
        return Colors.limeAccent;
      default:
        return Colors.white60;
    }
  }

  Widget getcontainer(String name, IconData icon, Color color, String tag) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              heroTag: tag,
              child: Icon(icon),
              backgroundColor: color,
              onPressed: () {
                if (name == "Gallery") {
                  stopanimation();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Imageview(
                          "group", phno, true, null, widget.userdata)));
                } else if (name == "Video") {
                  stopanimation();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Vediofile(
                          "${widget.groupkey},$myphone",
                          "group",
                          null,
                          widget.userdata)));
                } else if (name == "Document") {
                  stopanimation();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Fdf_list(
                          "${widget.groupkey},$myphone",
                          true,
                          null,
                          widget.userdata,
                          widget.groupkey)));
                } else if (name == "Audio") {
                  stopanimation();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Music(true, phno, null, widget.userdata)));
                } else if (name == "Contact") {
                  stopanimation();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          List_Contact(true, phno, null, widget.userdata)));
                } else if (name == "Location") {
                  stopanimation();
                  // Navigator.of(context).push(MaterialPageRoute(
                  // builder: (context) => MyLocation(
                  //     phno.substring(0), widget.userdata)));
                }
              }),
          Text(name)
        ],
      ),
    );
  }

  Widget bottomshete() {
    return SingleChildScrollView(
      child: Container(
          //  color:Colors.black26,72
          height: attachment ? 256 : emoje ? 290.0 : 72.0,
          child: Column(
            children: <Widget>[
              attachment
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 200,
                        width: 300.0,
                        child: Transform.scale(
                          alignment: Alignment.center,
                          scale: _animation.value,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    getcontainer("Document", Icons.book,
                                        Colors.purple, "bt1"),
                                    getcontainer("Video", Icons.camera_alt,
                                        Colors.green, "bt2"),
                                    getcontainer("Gallery", Icons.photo,
                                        Colors.blue, "bt3"),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    getcontainer("Audio", Icons.audiotrack,
                                        Colors.orangeAccent, "bt4"),
                                    getcontainer("Location", Icons.my_location,
                                        Colors.teal, "bt5"),
                                    getcontainer("Contact", Icons.contacts,
                                        Colors.lightBlueAccent, "bt6"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Offstage(),
              Row(
                children: <Widget>[
                  Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueAccent,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.tag_faces),
                              onPressed: () {
                                setState(() {
                                  emoje = !emoje;
                                });
                                //    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Imageandavedio()));
                              }),
                          Container(
                            width: !controller.text.isNotEmpty
                                ? MediaQuery.of(context).size.width - 250.0
                                : MediaQuery.of(context).size.width - 115.0,
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.start,
                              showCursor: true,
                              controller: controller,
                              onChanged: (value) {
                                setState(() {
                                  typetext = value;
                                  print(value);
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "enter text hear",
                                  border: InputBorder.none),
                            ),
                          ),
                          !emoje && !controller.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.attach_file),
                                  onPressed: () {
                                    if (!attachment) {
                                      setState(() {
                                        attachment = true;

                                        _animationController.forward();
                                      });
                                    }
                                    if (_animation.status ==
                                        AnimationStatus.completed) {
                                      setState(() {
                                        //
                                        _animationController
                                            .reverse()
                                            .then((_) {
                                          print("complredf anim ");
                                          setState(() {
                                            attachment = false;
                                            // attachment2 = true;
                                          });
                                        });
                                      });
                                    }
                                    if (_animation.status ==
                                        AnimationStatus.dismissed) {
                                      print("yes dismiseed ");
                                      _animationController.forward();
                                    }
                                  })
                              : Offstage(),
                          !controller.text.isNotEmpty
                              ? GestureDetector(
                                  child: Icon(Icons.mic),
                                  onLongPressStart:
                                      (LongPressStartDetails detailes) {
                                    speechToText.listen(onResult: resulttext);
                                  },
                                  onLongPressEnd:
                                      (LongPressEndDetails detailes) {
                                    speechToText.stop();
                                  },
                                )
                              : Offstage(),
                          !controller.text.isNotEmpty
                              ? IconButton(
                                  icon: !emoje
                                      ? Icon(Icons.camera_alt)
                                      : Icon(Icons.backspace),
                                  onPressed: () {
                                    if (emoje) {
                                      if (controller.text?.length != 0) {
                                        controller.text = controller.text
                                            .substring(0,
                                                (controller.text.length - 1));
                                      }
                                    }
                                  })
                              : Offstage()
                        ],
                      )),
                  Container(
                    child: GestureDetector(
                      child: FloatingActionButton(
                        heroTag: "mic",
                        child: controller.text.length == 0
                            ? Icon(Icons.mic)
                            : Icon(Icons.send),
                        onPressed: () async {
                          if (typetext.length != 0) {
                            String temp = controller.text;
                            controller.clear();
                            if (avoid_message.contains(temp)) {
                              showDialog(
                                  context: (context),
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          "you cant send this message, Admin block this message"),
                                      actions: <Widget>[
                                         FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("ok"))
                                      ],
                                    );
                                  });
                            } else {
                              savedata(temp, "msg");
                            }
                          }
                        },
                      ),
                      onLongPressStart: (LongPressStartDetails detailes) async {
                        print("start     $detailes");
                        Directory tempDir = await getTemporaryDirectory();
                        fin =
                            await File('${tempDir.path}/flutter_sound-tmp.aac');
                        Future<String> result =
                            flutterSound.startPlayer(fin.path);
                        result.then((datsa) {
                          print('startPlayer: $datsa');

                          print("path is ${fin.path}");
                          print("result record is $result");
                        });
                      },
                      onLongPressEnd: (LongPressEndDetails detail) async {
                        print("end $detail");
                        Future<String> result = flutterSound.stopPlayer();
                        result.then((onValue) async {
                          print('stopPlayer: $result');
                          await flutterSound.startPlayer(
                              "/data/user/0/com.example.charting/cache/flutter_sound-tmp.aac");
                        });
                      },
                    ),
                  )
                ],
              ),
              emoje
                  ? Container(
                      height: 225.0,
                      child: emojes(),
                    )
                  : Offstage()
            ],
          )),
    );
  }

  Widget emojes() {
    return EmojiPicker(onEmojiSelected: (emoje, cat) {
      print(emoje);
      print(cat);
      controller.text = controller.text + emoje.emoji;
    });
  }

  savedata(String data, String type) async {
    print("controller.text ${controller.text}");
    var date = DateFormat.yMd().format(DateTime.now());
    controller.clear();
    var time = DateFormat.jm().format(DateTime.now());
    print("users found or not $date");
    Message message = Message(
        toorfrom: "to",
        msgtype: type,
        msg: type == "msg" ? data : null,
        date: date,
        time: time,
        imgpath: "null",
        vediopath: "null",
        pdfpath: "null",
        audiopath: type == "audio" ? data : null,
        location: "null",
        contact: "null");

    var result = await helper.insertion(message, "$phno");
    print(result);
    setState(() {
      getdata();
    });
    Firestore.instance.runTransaction((Transaction transactionHandler) async {
      if (allgroupdata.length != 0) {

        for (int i = 0; i < allgroupdata?.length; i++) {
          if(!allgroupdata[i].contains("$myphone")){
          CollectionReference collectionReference = await Firestore.instance
              .collection("Allusers")
              .document(allgroupdata[i].split(",")[0])
              .collection("messages");
          collectionReference.add({
            "msgtype": type,
            "message": type == "msg" ? data : null,
            "recived": messagerecive,
            "time": time,
            "date": date,
            "toorfrom": "to",
            "imgpath": null,
            "vediopath": null,
            "pdfpath": null,
            "audiopath": type == "audio" ? data : null,
            "location": null,
            "contact": null,
            "from": myphone
          });
        }
        }
      }
    }).whenComplete(() {
      controller.clear();
      setState(() {
        typetext = "";
      });
    });
  }

  resulttext(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    setState(() {
      controller.text = result.recognizedWords;
    });
  }

  stopanimation() {
    if (_animation.status == AnimationStatus.completed) {
      setState(() {
        //
        _animationController.reverse().then((_) {
          print("complredf anim ");
          setState(() {
            attachment = false;
            // attachment2 = true;
          });
        });
      });
    }
  }
}
