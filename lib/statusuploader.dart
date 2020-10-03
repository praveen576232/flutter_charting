import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StatusUploder
{
  String users;
  List<String>selected;
  String type;
  StatusUploder(this.users,this.selected,this.type);
   upload() async
  {
    
  if(users!=null)
  {
    print(users);
    if(selected?.length!=0)
    {
        for(int i=0 ;i<selected?.length;i++)
      {
        StorageReference storageReference;
        print("enter $i");
        if(type=="image")
        {
 storageReference= FirebaseStorage.instance.ref().child("Allusers/$users/Status/Status$i");
        }
        else if(type=="vedio")
        {
          storageReference= FirebaseStorage.instance.ref().child("Allusers/$users/Status/vedio/Status$i");
        }
        
 StorageUploadTask storageUploadTask=storageReference.putFile(File(selected[i]));
 StorageTaskSnapshot taskSnapshot=await storageUploadTask.onComplete;
 String url=await storageReference.getDownloadURL();
 print("url is $url");
 Firestore.instance.runTransaction((Transaction transactionHandler)async{
CollectionReference collectionReference=await Firestore.instance.collection("Allusers").document(users).collection("Status");
collectionReference.add({
  "status url":url,
  "type":"$type",
  


                               
});
 });
      }
    }
  }
  else
  {
    print(users);
    print("users is null");
    getuser();
  }

  }
  getuser() async
  {
   var user= await FirebaseAuth.instance.currentUser();
  
     users=user.phoneNumber;
  
  }
 
}






 