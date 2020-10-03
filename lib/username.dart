import 'dart:async';
import 'dart:io';

import 'package:charting/homepage.dart';
import 'package:charting/listcontact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userdetailes extends StatefulWidget {
  @override
  _UserdetailesState createState() => _UserdetailesState();
}

class _UserdetailesState extends State<Userdetailes> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome()
    );
  }
}
class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  File image;
  String name;
   String user;
   List<Contact> list=[];
  //List<String> name=[];
 // List<Contact> names=[];
  // List<String> listdata=["praddepp","prdeep","predffe"];
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
 TextEditingController textEditingController=TextEditingController();
List<DocumentSnapshot> users=[];
 Iterable<Contact> contacts;
CollectionReference collectionReference=Firestore.instance.collection("users");
StreamSubscription streamSubscription;
StreamSubscription subscription;
List<String> contact=[];
List<String> userdata=[];
List<DocumentSnapshot> photo=[];
Future  getimage() async{
   //   var temp=await ImagePicker.pickImage(source:ImageSource.gallery);
      setState(() {
      //  image=temp;
      });
  }
  Future<FirebaseUser> getuser() async
  {
    FirebaseUser   temp=await firebaseAuth.currentUser();
   
    return temp; 
  }
  getcontact() async{
    contacts = await ContactsService.getContacts();
  
   setState(() {
   
     list=contacts.toList();

   });
   
    ContactComparator compare=new ContactComparator(list, users);
   
    setState(() {
       contact=compare.compareresult();
    });
      print("phptpo is ${contact[0].substring(0,13)}");
      print(contact.length);
 for(int i=0;i<contact?.length;i++)
 {
     String a=contact[i].substring(0,13);
     CollectionReference collectionReference1=Firestore.instance.collection("Allusers").document(a).collection(a);
     subscription=collectionReference1.snapshots().listen((onData){
    setState(() {
         photo=onData.documents;
         print(onData.documents);
    });
   
      
     });
     setState(() {
        String temp="person,${contact[i]},${photo[i].data['img']}";
         print(temp);
          userdata.add(temp);
     });
 }
  
  print(photo);
 
  }
  @override
  void initState() {
     getcontact();   
    // TODO: implement initState
    super.initState();
      
  
    print("enter");
    getuser().then((curentuser){
      print("user is ${curentuser.phoneNumber}");
     setState(() {
       user=curentuser.phoneNumber;
     });
    
   
    });
     streamSubscription=collectionReference.snapshots().listen((data){
         setState(() {
             users=data.documents;
         });
    });
  
  }
 update() async{
   
  
    
     if(user!=null)
     {
       Map<String,String> data=<String,String>{
         "phonenumber":user
       };
   Firestore.instance.collection("users").add(data);
   Firestore.instance.runTransaction((Transaction trans)async{
    CollectionReference collectionReference=await Firestore.instance.collection("Allusers").document(user).collection(user);
    collectionReference.add({
      "name":"praveen",
      
      "contact":userdata
    });
   });
    
    
     }
 }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Column(
          children: <Widget>[
           Row(
             children: <Widget>[
                Container(
              height:300,// MediaQuery.of(context).size.height/3,
              width: 300,//MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:image==null? NetworkImage("https://images.pexels.com/photos/257360/pexels-photo-257360.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"):FileImage(image)
                  ,
                  fit: BoxFit.cover
                ),
              ),
            ),
            FloatingActionButton(child: Icon(Icons.camera_alt,),
            onPressed: (){
             getimage();
            },
            )
             ],
           ),
           TextField(
            textInputAction: TextInputAction.done, 
            decoration: InputDecoration(hintText: "Your Name"),
            controller: textEditingController,
            onSubmitted: (temp){
               setState(() {
                 name=temp;
                 print(name);
               });
            },
           ),
           RaisedButton(
             child: Text("Next"),
             onPressed: (){
               print("pre");
             update();
       
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Botomnavigation()));
           
            
        
             },
           )
          ],
        ),
      );
  }
}