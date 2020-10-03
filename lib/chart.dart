import 'dart:async';

import 'package:charting/chartmessage.dart';
import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:charting/grouppage.dart';
import 'package:charting/groupsecurity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with WidgetsBindingObserver {
  AppLifecycleState appLifecycleState;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String phno = "";
  List<String> names = [];
  StreamSubscription subscription;
  StreamSubscription streamSubscription;
  StreamSubscription userdetailes;
  List<DocumentSnapshot> allmesg = [];
  List<DocumentSnapshot> refernceallmesg = [];
  List<DocumentSnapshot> users = [];
  Map<String, List<DocumentSnapshot>> gropinfo = Map();
  List<String> timeandcount = [];
  List<String> profile = [];
  Map<String, String> countmsg = Map();
  Map<String, String> dataindex = Map();
  Map<String, Widget> lastmessage = Map();
  Map<String, List<DocumentSnapshot>> userdata = Map();
  Map<String, List<String>> activetime = Map();
  Databasehelper helper;
  DateTime entertime;
  String enterdate;
  var alldata;
  String lastdata;
  String id;
  bool once = false;
  int enterhour = 0;
  int enterminute = 0;
  int enteramoripm = 0;
  List<String> active = [];
  Map<String, String> addonline = Map();
  bool activelock = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    entertime = DateTime.now();
    enterdate = DateFormat.yMd().format(DateTime.now());
    enterhour = entertime.hour;
    //int.parse(entertime.split(":")[0]);
    enterminute =
        entertime.minute; //int.parse(entertime.split(":")[1].split(" ")[0]);
    //  enteramoripm=entertime.split(" ")[1]=="AM"?0:12*60;
    WidgetsBinding.instance.addObserver(this);
    getuser().then((myphno) {
      if (myphno != null) {
        CollectionReference collectionReference = Firestore.instance
            .collection("Allusers")
            .document(myphno)
            .collection(myphno);
        streamSubscription = collectionReference.snapshots().listen((onData) {
          setState(() {
            users = onData.documents;
            phno = myphno;
            if (users[0] != null) {
              id = users[0].documentID;

              if (users[0].data['active'] != null)
                active = users[0].data['active'].cast<String>().toList();

              for (int index = 0;
                  index < users[0].data['contact'].length;
                  index++) {
                String user =
                    users[0].data['contact'][index].toString().split(",")[1];
                String gropdp =
                    users[0].data['contact'][index].toString().split(",")[0];
                if (gropdp.compareTo("person") == 0) {
                  print("in person $gropdp");
                  CollectionReference mycollection = Firestore.instance
                      .collection("Allusers")
                      .document(user)
                      .collection(user);
                  userdetailes = mycollection.snapshots().listen((onData) {
                    userdata[user] = onData.documents;
                  });
                } else {
                  print("came");
                  CollectionReference mygroupdata = Firestore.instance
                      .collection("Allusers")
                      .document(myphno)
                      .collection(myphno)
                      .document(id)
                      .collection(user);
                  userdetailes = mygroupdata.snapshots().listen((onData) {
                    setState(() {
                      gropinfo[user] = onData.documents;
                    });
                  });
                }
              }
            }
          });
          //add online
          if (!once) {
            addonline["curent_status"] = "online";
            online(addonline);
            print("online adede");
          }
        });

        CollectionReference collectionReference1 = Firestore.instance
            .collection("Allusers")
            .document(myphno)
            .collection("messages");
        subscription = collectionReference1.snapshots().listen((data) {
          setState(() {
            allmesg = data.documents;
            refernceallmesg = allmesg;
          });
        });
      }
    });
  }

  Future getuser() async {
    user = await firebaseAuth.currentUser();

    setState(() {
      phno = user.phoneNumber;
    });
    return phno;
  }

  getinpumsg2() {
    List<String> a = [];
    List<String> b = [];
    countmsg.clear();
    dataindex.clear();
    if (users?.length != 0) {
      if (users[0].data['contact']?.length != 0) {
        for (int j = 0; j < users[0].data['contact']?.length; j++) {
          a.add(users[0].data['contact'][j].toString().split(",")[1]);
        }
      }
    }
    if (allmesg?.length != 0) {
      for (int i = 0; i < allmesg?.length; i++) {
        try {
          String groupdata = allmesg[i].data['from'].toString().split(",")[0];
          b.add(groupdata);
        } catch (e) {
          b.add(allmesg[i].data['from']);
        }
      }
    }
    if (allmesg?.length != 0) {
      for (int i = 0; i < allmesg?.length; i++) {
        print("12   ${b[i]}");
        print("a is %$a");

        print("finall ${a.contains(b[i])}");
        if (a.contains(b[i])) {
          String temp = b[i];
          String local = allmesg[i].data['time'];
          if (countmsg.containsKey(temp)) {
            String tempvalue = dataindex[temp];
            int tempcount = int.parse(countmsg[temp].split(",")[0]);
            print("temp $tempcount");
            setState(() {
              countmsg.update(temp, (value) => "${tempcount + 1},$local");
              dataindex.update(temp, (value) => "$tempvalue,$i");
            });
          } else {
            setState(() {
              dataindex[temp] = "$i";
              countmsg[temp] = "1,${allmesg[i].data['time']}";
            });
          }
        }
      }
    }
  }

  getlastdata(String tempusers, bool group) async {
    print(tempusers);
    var result1;
    try {
      if (!group) {
        Databasehelper helper1 = Databasehelper("p${tempusers.substring(1)}");
        int result = await helper1.getlength("p${tempusers.substring(1)}");
        print("result type is $result");

        if (result != null) {
          result1 =
              await helper1.currentdata(result, "p${tempusers.substring(1)}");
          print("result type is $result1");
        }
      } else {
        Databasehelper helper1 = Databasehelper(tempusers);
        int result = await helper1.getlength(tempusers);
        print("result type is $result");

        if (result != null) {
          result1 = await helper1.currentdata(result, tempusers);
          print("result type is $result1");
        }
      }
    } catch (e) {}
    if (result1 != null) {
      print("result is $result1");
      //   setState(() {

      switch (result1) {
        case "image":
          {
            lastmessage[tempusers] = Row(
              children: <Widget>[Icon(Icons.image), Text("image")],
            );

            break;
          }
        case "video":
          {
            lastmessage[tempusers] = Row(
              children: <Widget>[Icon(Icons.featured_video), Text("video")],
            );

            break;
          }
        case "audio":
          {
            lastmessage[tempusers] = Row(
              children: <Widget>[Icon(Icons.audiotrack), Text("audio")],
            );

            break;
          }
        case "location":
          {
            lastmessage[tempusers] = Row(
              children: <Widget>[Icon(Icons.location_on), Text("location")],
            );

            break;
          }
        case "contact":
          {
            lastmessage[tempusers] = Row(
              children: <Widget>[Icon(Icons.contact_phone), Text("contact")],
            );

            break;
          }
        default:
          {
            lastmessage[tempusers] = result1.toString().length != 10
                ? Text(result1)
                : Text("${result1.toString().substring(0, 10)}...");

            break;
          }
      }
      //  });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    print("state of app is $state");
    setState(() {
      appLifecycleState = state;
    });
    addOnline();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription.cancel();
    subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<int> insertdata(Message message, String phno) async {
    print("data is");
    alldata = await helper.insertion(message, phno);
    print(alldata);
    setState(() {});
    return alldata;
  }

  online(Map map) {
    once = true;
    Firestore.instance
        .collection("Allusers")
        .document(phno)
        .collection(phno)
        .document(id)
        .updateData(map);
  }

  acticvehour(String date, int totletime) {
    if (!activelock) {
      if (active?.length != 0) {
        if (active.length <= 6) {
          print("length less then 6");
          String lastdata = active.elementAt(active.length - 1);
          print(lastdata);
          if (lastdata.split("--")[0].compareTo(date) == 0) {
            print("last date re4mpove");
            activelock = true;
            active.removeLast();
            int prevesdata = int.parse(lastdata.split("--")[1]);
            totletime = totletime + prevesdata;
            Firestore.instance
                .collection("Allusers")
                .document(phno)
                .collection(phno)
                .document(id)
                .updateData({
              "active": FieldValue.arrayRemove([lastdata])
            }).then((_) {
              active.add("$date--${totletime.toString()}");

              Firestore.instance
                  .collection("Allusers")
                  .document(phno)
                  .collection(phno)
                  .document(id)
                  .updateData({
                "active":
                    FieldValue.arrayUnion(["$date--${totletime.toString()}"])
              });
            });
          } else {
            activelock = true;
            print("add new object");
            active.add("$date--${totletime.toString()}");
            Firestore.instance
                .collection("Allusers")
                .document(phno)
                .collection(phno)
                .document(id)
                .updateData({
              "active":
                  FieldValue.arrayUnion(["$date--${totletime.toString()}"])
            });
          }
        } else {
          activelock = true;
          print("oveler lodeed");
          String firstelement = active.elementAt(0);
          active.remove(firstelement);
          Firestore.instance
              .collection("Allusers")
              .document(phno)
              .collection(phno)
              .document(id)
              .updateData({
            "active": FieldValue.arrayRemove([firstelement])
          }).then((_) {
            active.add("$date--${totletime.toString()}");
            Firestore.instance
                .collection("Allusers")
                .document(phno)
                .collection(phno)
                .document(id)
                .updateData({
              "active":
                  FieldValue.arrayUnion(["$date--${totletime.toString()}"])
            });
          });
        }
      } else {
        activelock = true;
        print("add first data");
        active.add("$date--${totletime.toString()}");
        print("data is $active");
        print("length is ${active.length}");

        Firestore.instance
            .collection("Allusers")
            .document(phno)
            .collection(phno)
            .document(id)
            .updateData({
          "active": FieldValue.arrayUnion(["$date--${totletime.toString()}"])
        });
      }
    }
    //activelock=false;
  }

  addOnline() {
    if (id != null) {
      if (appLifecycleState != null) {
        Map<String, String> map = Map();
        if (appLifecycleState == AppLifecycleState.resumed) {
          map.clear();
          map["curent_status"] = "Online";
          //online(map); //upadte online
          print("online");
          entertime = DateTime.now();
          enterdate = DateFormat.yMd().format(DateTime.now());
          enterhour = entertime.hour;
          enterminute = entertime.minute;
          activelock = false;
        } else {
          var date = DateFormat.yMd().format(DateTime.now());
          DateTime t = DateTime.now();
          var time = DateFormat.jm().format(t);
          map.clear();
          map["curent_status"] = "$time,$date";
          //online(map); //update online
          print("offline123 ${enterdate.compareTo(date)}");
          int livehour = t.hour;
          int liveminute = t.minute;
          if (enterdate.compareTo(date) == 0) {
            print("pawss1234567890");

            //int.parse(time.split(":")[0]);
            //int.parse(time.split(":")[1].split(" ")[0]);
            // int liveamorpm=time.split(" ")[1]=="AM"?0:12*60;
            int totletime =
                (livehour * 60 + liveminute) - (enterhour * 60 + enterminute);
            //acticvehour(DateFormat.yMEd().format(DateTime.now()), totletime);
            print("totle time is $totletime");
          } else {
            print("failll");
            int totletime = (24 * 60 + 00) - (enterhour * 60 + enterminute);
            acticvehour(DateFormat.yMEd().format(entertime), totletime);
            if (livehour != 24 && liveminute != 0) {
              totletime = livehour * 60 + liveminute;
              acticvehour(DateFormat.yMEd().format(DateTime.now()), totletime);
            }

            // int totletime=(int.parse(time.split(":")[0])*60+int.parse(time.split(":")[1].split(" ")[0])+liveamorpm)-(enterhour*60+enterminute+enteramoripm);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("grops information are");
    // for(String g in gropinfo.keys){
    //  print("info are ${gropinfo[g][0].data['creater']}");
    // }

    getinpumsg2();
    //  getlastdatafor();
    //  print(countmsg[names[0]]);
    //countmsg.forEach((f)=>(print(f));)
    // print(allmesg.removeAt(1).data['time']);
    for (String mykey in countmsg.keys) print("keys are ${countmsg[mykey]}");
    return users?.length != 0 && users[0].data['contact']?.length != 0
        ? Container(
            child: ListView.builder(
              itemCount: users[0].data['contact']?.length,
              itemBuilder: (context, index) {
                String groupcheck =
                    "${users[0].data['contact'][index].toString().split(",")[0]}";
                String tempusers =
                    "${users[0].data['contact'][index].toString().split(",")[1]}";
                getlastdata(tempusers, groupcheck.compareTo("group") == 0);
                print(lastmessage);
                names.clear();
                names = users[0].data['contact'][index].toString().split(",");

                return ListTile(
                  isThreeLine: true,
                  leading: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //  color: Colors.green,
                      //  image: DecorationImage(image: NetworkImage(names[2]),fit: BoxFit.fill),
                      border: names[0].compareTo("person") == 0
                          ? userdata.containsKey(names[1])
                              ? userdata[names[1]][0].data['curent_status'] !=
                                          null &&
                                      userdata[names[1]][0]
                                              .data['curent_status'] ==
                                          "online"
                                  ? Border.all(width: 3.0, color: Colors.green)
                                  : Border.all(width: 0.0, color: Colors.green)
                              : Border.all(width: 0.0, color: Colors.green)
                          : Border.all(width: 0.0, color: Colors.green),
                    ),
                    child: Hero(
                      tag: names[1],
                      child: InkWell(
                        child: CircleAvatar(
                            backgroundImage: names[0].compareTo("person") == 0
                                ? userdata.containsKey(names[1])
                                    ? userdata[names[1]][0].data['img'] != null
                                        ? NetworkImage(
                                            userdata[names[1]][0].data['img'])
                                        : NetworkImage(
                                            "https://image.shutterstock.com/image-vector/people-icon-260nw-522300817.jpg")
                                    : NetworkImage(
                                        "https://image.shutterstock.com/image-vector/people-icon-260nw-522300817.jpg")
                                : gropinfo.containsKey(names[1])
                                    ? gropinfo[names[1]][0].data["groupdp"] !=
                                            null
                                        ? NetworkImage(gropinfo[names[1]][0]
                                            .data["groupdp"])
                                        : NetworkImage(
                                            "https://image.shutterstock.com/image-vector/people-icon-260nw-522300817.jpg")
                                    : NetworkImage(
                                        "https://image.shutterstock.com/image-vector/people-icon-260nw-522300817.jpg")),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0.0),
                                  actions: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.message,
                                            color: Colors.green),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: Icon(Icons.video_call,
                                            color: Colors.green),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: Icon(Icons.info,
                                            color: Colors.green),
                                        onPressed: () {}),
                                  ],
                                  content: Hero(
                                    tag: names[1],
                                    child: Container(
                                      child: names[0].compareTo("person") == 0
                                          ? Image.network(names[3])
                                          : gropinfo.containsKey(names[1])
                                              ? gropinfo[names[1]][0]
                                                          .data["groupdp"] !=
                                                      null
                                                  ? Image.network(
                                                      gropinfo[names[1]][0]
                                                          .data["groupdp"])
                                                  : Image.network(
                                                      "https://image.shutterstock.com/image-vector/people-icon-260nw-522300817.jpg")
                                              : Image.network(
                                                  "https://image.shutterstock.com/image-vector/people-icon-260nw-522300817.jpg"),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                  title: names[0].compareTo("person") == 0
                      ? Text(
                          names[2],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          gropinfo.containsKey(names[1])
                              ? gropinfo[names[1]][0].data['name']
                              : "No Group Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  subtitle: lastmessage.containsKey(tempusers)
                      ? lastmessage[tempusers]
                      : Offstage(),
                  trailing: countmsg.containsKey(names[1]) &&
                          int.parse(countmsg[names[1]]
                                  .toString()
                                  .split(",")[0]) !=
                              0
                      ? Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: countmsg[names[1]]
                                            .toString()
                                            .split(",")[1] !=
                                        null
                                    ? Text(
                                        countmsg[names[1]]
                                            .toString()
                                            .split(",")[1],
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : Offstage(),
                              ),
                              Container(
                                height: 20.0,
                                width: 20.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(countmsg[names[1]]
                                      .toString()
                                      .split(",")[0]),
                                ),
                              )
                            ],
                          ),
                        )
                      : Offstage(),
                  onTap: () {
                    List<String> i = [];
                    String groupchecking = users[0]
                        .data['contact'][index]
                        .toString()
                        .split(",")[0];
                    String group = users[0]
                        .data['contact'][index]
                        .toString()
                        .split(",")[1];
                    print("group page $group");
                    //print("data ig group is ${gropinfo[groupchecking][0]}");
                    if (groupchecking.compareTo("person") == 0) {
                      print("in person");

                      helper = Databasehelper("p${tempusers.substring(1)}");
                    } else {
                      print("in group");
                      helper = Databasehelper(tempusers);
                    }

                    print("number is $tempusers");
                    if (countmsg.containsKey(tempusers)) {
                      if (dataindex.containsKey(tempusers)) {
                        i = dataindex[tempusers].split(",");
                        if (i?.length != 0) {
                          for (int j = 0; j < i?.length; j++) {
                            String msgtype = refernceallmesg[int.parse(i[j])]
                                .data['msgtype'];
                            String message1 = refernceallmesg[int.parse(i[j])]
                                .data['message']
                                .toString();
                            String date =
                                refernceallmesg[int.parse(i[j])].data['date'];
                            String time =
                                refernceallmesg[int.parse(i[j])].data['time'];
                            String imgpath =
                                "${refernceallmesg[int.parse(i[j])].data['imgpath'].toString()},${refernceallmesg[int.parse(i[j])].data['filename'].toString()}";
                            String vediopath =
                                "${refernceallmesg[int.parse(i[j])].data['vediopath'].toString()},${refernceallmesg[int.parse(i[j])].data['filename'].toString()}";
                            String pdfpath =
                                "${refernceallmesg[int.parse(i[j])].data['pdfpath'].toString()},${refernceallmesg[int.parse(i[j])].data['filename'].toString()}";
                            String audiopath =
                                "${refernceallmesg[int.parse(i[j])].data['audiopath'].toString()},${refernceallmesg[int.parse(i[j])].data['filename'].toString()}";
                            String location = refernceallmesg[int.parse(i[j])]
                                .data['location']
                                .toString();
                            String contact = refernceallmesg[int.parse(i[j])]
                                .data['contact']
                                .toString();
                            print(
                                "data time data is ${refernceallmesg[int.parse(i[j])].data['time']}");
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

                            insertdata(
                                    message,
                                    groupchecking.compareTo("person") == 0
                                        ? "p${tempusers.substring(1)}"
                                        : tempusers)
                                .then((data) {
                              if (data != 0) {
                                String id =
                                    refernceallmesg[int.parse(i[j])].documentID;
                                Firestore.instance
                                    .collection("Allusers")
                                    .document(phno)
                                    .collection("messages")
                                    .document(id)
                                    .delete()
                                    .whenComplete(() {});
                              }
                            });
                          }
                        }
                      }
                    }
                    if (groupchecking.compareTo("person") == 0) {
                      print("in person dta a");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Chartmsg(
                              users[0].data['contact'][index],
                              null,
                              null,
                              id)));
                    } else {
                      
                      if (gropinfo[group][0].data['security'] != null) {
                        print("in group  $group");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                GroupSecurity(gropinfo[group][0],group)));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Grouppage(gropinfo[group][0],group)));
                      }
                    }
                  },
                ); //
              },
            ),
          )
        : Container(
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
