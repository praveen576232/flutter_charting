import 'dart:async';

import 'package:charting/myfriend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cretegroup extends StatefulWidget {
  @override
  _CretegroupState createState() => _CretegroupState();
}

class _CretegroupState extends State<Cretegroup>
    with SingleTickerProviderStateMixin {
  List<String> mycontact = [];
  List<String> listgroup = [];

  List<dynamic> temp = List<dynamic>();
  bool showsetting = false;
  getmyfriend my = getmyfriend();
  Animation _animation;
  AnimationController animationController;
  TextEditingController _textEditingController;
  TextEditingController _textEditingController1;
  String myphno = "";
  bool admin_only = false;
  bool avoid_msg = false;
  bool security = false;
  bool add_admin = false;
  bool cvisibal = true;
  bool pvisibal = true;
  bool passwordset = false;
  List<String> avoid_message = [];
  List<String> admin = [];
  List<String> selected = [];
  List<String> groups = [];
  String myname;
  TextEditingController _password;
  TextEditingController _conformpassword;
  CollectionReference _collectionReference;
  StreamSubscription subscription;
  String groupname = "";
  final _passkey = GlobalKey<FormState>();
  final _conformkey = GlobalKey<FormState>();
  Future<String> getmyphone() async {
    var user = await FirebaseAuth.instance.currentUser();

    myphno = user.phoneNumber;
    return Future.value(myphno);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmyphone().then((onValue) {
      print("phone number is $onValue");
      if (onValue != null) {
        _collectionReference = Firestore.instance
            .collection("Allusers")
            .document(onValue)
            .collection(onValue);
        subscription = _collectionReference.snapshots().listen((onData) {
          if (onData != null) {
            if (onData.documents != null && onData.documents[0] != null) {
              setState(() {
                myname = onData.documents[0].data['name'];
              });
              if (onData.documents[0].data['contact'] != null) {
                List<String> tempdata =
                    onData.documents[0].data['contact'].cast<String>().toList();
                if (tempdata != null && tempdata?.length != 0) {
                  for (int i = 0; i < tempdata?.length; i++) {
                    if (tempdata[i].split(",")[0].compareTo("group") == 0) {
                      groups.add(tempdata[i]);
                    }
                  }
                }
              }
            }
          }
        });
      }
    });
    _textEditingController = TextEditingController();
    _textEditingController1 = TextEditingController();
    _password = TextEditingController();
    _conformpassword = TextEditingController();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    _animation.addListener(() {
      setState(() {});
    });
    getlist();
  }

  getlist() async {
    temp = await my.getcontact();
    setState(() {
      mycontact = temp.cast<String>().toList();
    });
  }

  Widget list(String text) {
    return Column(
      children: <Widget>[
        text == "admin"
            ? Text(
                "admin's are",
                style: TextStyle(color: Colors.white),
              )
            : Text("partcipation"),
        Container(
          height: 70.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  text == "particpation" ? selected?.length : admin?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(3.0),
                  child: InkWell(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                        ),
                        text == "particpation"
                            ? Text(selected[index].split(",")[1])
                            : Text(
                                admin[index].split(",")[1],
                                style: TextStyle(color: Colors.white),
                              )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        text == "particpation"
                            ? selected.removeAt(index)
                            : admin.remove(admin[index]);
                      });
                    },
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget displaylist(Color color, String text) {
    return ConstrainedBox(
      constraints: BoxConstraints(),
      child: ListView.builder(
          itemCount: mycontact?.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                child: CircleAvatar(),
              ),
              title: Text(
                mycontact[index].split(",")[1],
                style: TextStyle(color: color),
              ),
              trailing: FlatButton(
                onPressed: () {
                  if (text == "admin") {
                    setState(() {
                      if (admin.contains(mycontact[index])) {
                        admin.remove(mycontact[index]);
                        mycontact.add(mycontact[index]);
                      } else {
                        admin.add(mycontact[index]);
                        //mycontact.remove(mycontact[index]);
                      }
                    });
                  } else {
                    setState(() {
                      if (selected.contains(mycontact[index])) {
                        selected.remove(mycontact[index]);
                      } else {
                        selected.add(mycontact[index]);
                      }
                    });
                  }
                },
                child: text == "admin"
                    ? admin.contains(mycontact[index])
                        ? Text("ADMIN")
                        : Text("ADD")
                    : text == "add"
                        ? Text("ADD")
                        : selected.contains(mycontact[index])
                            ? Text("REMOVE")
                            : Text("ADD"),
                color: Colors.green,
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    _animation.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50, left: 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            height: 150,
                            width: 150.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                          Positioned(
                            top: 100,
                            left: 108,
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
                    Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width - 180,
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.start,
                          showCursor: true,
                          maxLength: 25,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0),
                          onChanged: (value) {
                            setState(() {
                              groupname = value.replaceAll(" ", "");
                            });
                          },
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              hintText: "enter group name",
                              border: InputBorder.none),
                        ))
                  ],
                ),
                Container(
                  height: 20.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.all(Radius.circular(8.00))),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        if (!showsetting) {
                          animationController.forward();
                          showsetting = true;
                        } else {
                          animationController.reverse();
                          showsetting = false;
                        }
                      });
                    },
                    child: Center(
                      child: Text(
                        "Admin settings",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        selected?.length != 0
                            ? Container(
                                height: 100,
                                child: list("particpation"),
                              )
                            : Offstage(),
                        Container(
                          height: MediaQuery.of(context).size.height - 270,
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.greenAccent,
                          child: mycontact?.length != 0
                              ? displaylist(Colors.black, "ADD")
                              : Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                    Container(
                      height: avoid_msg
                          ? MediaQuery.of(context).size.height *
                              _animation.value
                          : security
                              ? 400 * _animation.value
                              : add_admin
                                  ? MediaQuery.of(context).size.height *
                                      _animation.value
                                  : 250 * _animation.value,
                      color: Colors.black,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: avoid_msg
                                    ? MediaQuery.of(context).size.height
                                    : security
                                        ? 400
                                        : add_admin
                                            ? MediaQuery.of(context).size.height
                                            : 250,
                                child: ListView(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Switch(
                                          value: admin_only,
                                          onChanged: (v) {
                                            setState(() {
                                              admin_only = v;
                                            });
                                          }),
                                      title: Text(
                                        "Admin Only",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: InkWell(
                                          child: Text(
                                        "more info",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                    ),
                                    ListTile(
                                      leading: Switch(
                                          value: avoid_msg,
                                          onChanged: (v) {
                                            setState(() {
                                              avoid_msg = v;
                                            });
                                          }),
                                      title: Text(
                                        "Avoid messages",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: InkWell(
                                          child: Text(
                                        "more info",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                    ),
                                    avoid_msg
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(),
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  avoid_message?.length != 0
                                                      ? ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      1.0,
                                                                  maxHeight:
                                                                      250.0),
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      avoid_message
                                                                          ?.length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ListTile(
                                                                      title:
                                                                          Text(
                                                                        avoid_message[
                                                                            index],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      trailing: IconButton(
                                                                          icon: Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              avoid_message.remove(avoid_message[index]);
                                                                            });
                                                                          }),
                                                                    );
                                                                  }),
                                                        )
                                                      : Container(
                                                          child: Text(
                                                            "enter word is avoid in your group",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                  Container(
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      textAlign:
                                                          TextAlign.start,
                                                      showCursor: true,
                                                      maxLength: 25,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 20.0),
                                                      controller:
                                                          _textEditingController1,
                                                      onSubmitted: (text) {
                                                        //
                                                        print("submited");
                                                        setState(() {
                                                          avoid_message
                                                              .add(text);
                                                          _textEditingController1
                                                              .clear();
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "enter avoid word",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          border:
                                                              InputBorder.none),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        : Offstage(),
                                    ListTile(
                                      leading: Switch(
                                          value: security,
                                          onChanged: (v) {
                                            setState(() {
                                              security = v;
                                            });
                                          }),
                                      title: Text(
                                        "Security",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: InkWell(
                                          child: Text(
                                        "more info",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                    ),
                                    security
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(),
                                            child: Column(
                                              children: <Widget>[
                                                !passwordset
                                                    ? Container(
                                                        child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                90,
                                                            child: Form(
                                                              key: _passkey,
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    pvisibal,
                                                                controller:
                                                                    _password,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                showCursor:
                                                                    true,
                                                                maxLength: 25,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        20.0),
                                                                // controller: _textEditingController1,
                                                                validator:
                                                                    (text) {
                                                                  if (text
                                                                          .trim()
                                                                          .length ==
                                                                      0)
                                                                    return "password is requied";
                                                                  else if (text
                                                                          .length <=
                                                                      6)
                                                                    return "length should be greter then 6";
                                                                  return null;
                                                                },
                                                                onFieldSubmitted:
                                                                    (text) {
                                                                  if (_passkey
                                                                      .currentState
                                                                      .validate()) {
                                                                    print(
                                                                        "submited");
                                                                    setState(
                                                                        () {
                                                                      //  _textEditingController1.clear();
                                                                    });
                                                                  }
                                                                },

                                                                decoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            "enter password",
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .white),
                                                                        enabled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors.blue,
                                                                              style: BorderStyle.solid),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(5.0)),
                                                                        )),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                              child: IconButton(
                                                                  icon: pvisibal
                                                                      ? Icon(
                                                                          Icons
                                                                              .visibility,
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .visibility_off,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      pvisibal =
                                                                          !pvisibal;
                                                                    });
                                                                  }))
                                                        ],
                                                      ))
                                                    : Offstage(),
                                                !passwordset
                                                    ? Container(
                                                        child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            //  height: 50,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                90,
                                                            child: Form(
                                                              key: _conformkey,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _conformpassword,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                showCursor:
                                                                    true,
                                                                maxLength: 25,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        20.0),
                                                                validator:
                                                                    (text) {
                                                                  if (text
                                                                          .trim()
                                                                          .length ==
                                                                      0)
                                                                    return "enter password";
                                                                  else if (text.compareTo(_password
                                                                          .value
                                                                          .text) !=
                                                                      0) {
                                                                    return "password not match";
                                                                  }
                                                                  return null;
                                                                },
                                                                onFieldSubmitted:
                                                                    (text) {
                                                                  if (_conformkey
                                                                      .currentState
                                                                      .validate()) {
                                                                    print(
                                                                        "submited");
                                                                    setState(
                                                                        () {
                                                                      // _password
                                                                      //     .clear();
                                                                      // _conformpassword
                                                                      //     .clear();
                                                                      passwordset =
                                                                          true;
                                                                    });
                                                                  }
                                                                },
                                                                obscureText:
                                                                    cvisibal,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Conform password",
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5.0)),
                                                                  ),
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                              child: IconButton(
                                                                  icon: cvisibal
                                                                      ? Icon(
                                                                          Icons
                                                                              .visibility,
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .visibility_off,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      cvisibal =
                                                                          !cvisibal;
                                                                    });
                                                                  }))
                                                        ],
                                                      ))
                                                    : Offstage(),
                                                FlatButton(
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      if (!passwordset) {
                                                        print("enter");
                                                        if (_passkey
                                                            .currentState
                                                            .validate()) {
                                                          if (_conformkey
                                                              .currentState
                                                              .validate()) {
                                                            setState(() {
                                                              passwordset =
                                                                  true;
                                                            });
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: !passwordset
                                                        ? Text(
                                                            "SUBMIT",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : Text(
                                                            "Security Added",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))
                                              ],
                                            ),
                                          )
                                        : Offstage(),
                                    ListTile(
                                      leading: Switch(
                                          value: add_admin,
                                          onChanged: (v) {
                                            setState(() {
                                              add_admin = v;
                                            });
                                          }),
                                      title: Text(
                                        "Add Admin",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: InkWell(
                                          child: Text(
                                        "more info",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                    ),
                                    add_admin
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(),
                                            child: Column(
                                              children: <Widget>[
                                                admin?.length != 0
                                                    ? ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(),
                                                        child: list("admin"),
                                                      )
                                                    : Offstage(),
                                                mycontact?.length != 0
                                                    ? ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxHeight:
                                                                    300.0),
                                                        child: displaylist(
                                                            Colors.white,
                                                            "admin"))
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                              ],
                                            ))
                                        : Offstage()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            height: 50,
            color: Colors.purpleAccent,
            child: FlatButton(
                onPressed: _textEditingController.text.length != 0
                    ? () {
                        if (myphno != null) {
                          if (groups.contains(
                              "group,${groupname}__${myphno.substring(1)}")) {
                            showDialog(
                                context: (context),
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        "group is Alerdy exist please change your group name"),
                                  );
                                });
                          } else {
                            admin.add("$myphno,$myname");
                            List<String> allgroupusers = admin + selected;
                            Set<String> data = allgroupusers.toSet();
                            selected.clear();
                            selected = data.toList();
                            print("selected item $selected");
                            print(groups);
                            print("group,${groupname}__${myphno.substring(1)}");
                            if (selected?.length != 0) {
                             for(int i=0;i<selected?.length;i++) {
                                bool lock = false;
                                if (!lock) {
                                  String id;
                                  Firestore.instance.runTransaction(
                                      (Transaction transactionHandler) async {
                                    CollectionReference collectionReference =
                                        await Firestore.instance
                                            .collection("Allusers")
                                            .document(selected[i].split(",")[0])
                                            .collection(selected[i].split(",")[0]);
                                    collectionReference
                                        .snapshots()
                                        .listen((onData) {
                                      if (onData != null &&
                                          onData.documents[0] != null) {
                                        id = onData.documents[0].documentID;
                                        if (id != null) {
                                          collectionReference
                                              .document(id)
                                              .updateData({
                                            "contact": FieldValue.arrayUnion([
                                              "group,${groupname}__${myphno.substring(1)}"
                                            ])
                                          });

                                          collectionReference
                                              .document(id)
                                              .collection(
                                                  "${groupname}__${myphno.substring(1)}")
                                              .add({
                                            "admin": admin,
                                            "creater": myphno,
                                            "normal_user": selected,
                                            "admin_only": admin_only,
                                            "avoid_msg":
                                                avoid_message?.length != 0
                                                    ? avoid_message
                                                    : null,
                                            "security":
                                                _password.value.text != null
                                                    ? _password.value.text
                                                    : null,
                                            "name": _textEditingController
                                                .value.text
                                          });
                                        }
                                      }
                                    });
                                  });
                                  lock = true;
                                }
                              }
                            }
                          }
                         
                        }
                      }
                    : null,
                child: Text("CREATE"))),
      ),
    );
  }
}
