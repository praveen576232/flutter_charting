import 'dart:async';

import 'package:charting/listcontact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

class getmyfriend{
Iterable<Contact> contacts;
   List<Contact>list=[];
List<DocumentSnapshot> users=[];
   CollectionReference collectionReference=Firestore.instance.collection("users");
StreamSubscription streamSubscription;
  
 getcontact() async{
   streamSubscription=collectionReference.snapshots().listen((data){
      
             users=data.documents;
        
    });
    contacts = await ContactsService.getContacts();
  
  
   
     list=contacts.toList();


   
    ContactComparator compare=new ContactComparator(list, users);
  return Future.value(compare.compareresult());
  }
}