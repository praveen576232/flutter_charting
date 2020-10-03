import 'dart:io';

import 'package:charting/database/database.dart';
import 'package:charting/database/databasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ChartUploder {
  String users;
  String myphno;
  String selected;
  bool group;
  String type;
  DocumentSnapshot groupdata;
  ChartUploder(this.group,this.users, this.myphno, this.selected, this.type,[this.groupdata]);

 Future<bool> upload() async {
   String url;
   var filename;
    if (users != null) {
      print(users);
      if (selected != null) {
       if(!(type=="location" || type=="contact"))
       {
          File file = File(selected);
         filename = basename(file.path);
         print("filenme is $filename");
        StorageReference storageReference;      
 storageReference = FirebaseStorage.instance
              .ref()
              .child("Allusers/$users/Media/$type/$filename");
        StorageUploadTask storageUploadTask =
            storageReference.putFile(File(selected));
        StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

        url = await storageReference.getDownloadURL();
        print("url is $url");
       }
        var date = DateFormat.yMd().format(DateTime.now());
        var time = DateFormat.jm().format(DateTime.now());
        Firestore.instance
            .runTransaction((Transaction transactionHandler) async {
         if(group){
         List<String> allusers=groupdata.data['normal_user'].cast<String>().toList();
         if(allusers!=null && allusers?.length!=0){
           for(int i=0;i<allusers?.length;i++){
              CollectionReference collectionReference = await Firestore.instance
              .collection("Allusers")
              .document(allusers[i].split(",")[0])
              .collection("messages");
          collectionReference.add({
            "msgtype": "image",
            "message": null,
            "recived": null,
            "time": time,
            "date": date,
            "toorfrom": "to",
            "imgpath": type == "image" ? url : null,
            "vediopath": type == "vedio" ? url : null,
            "pdfpath": type == "pdf" ? url : null,
            "audiopath": type == "audio" ? url : null,
            "location": type == "location" ? selected : null,
            "contact": type == "contact" ? selected : null,
            "from": myphno,
            "filename":filename.toString()
          });
           }
         }
         }else{
            CollectionReference collectionReference = await Firestore.instance
              .collection("Allusers")
              .document(users)
              .collection("messages");
          collectionReference.add({
            "msgtype": "image",
            "message": null,
            "recived": null,
            "time": time,
            "date": date,
            "toorfrom": "to",
            "imgpath": type == "image" ? url : null,
            "vediopath": type == "vedio" ? url : null,
            "pdfpath": type == "pdf" ? url : null,
            "audiopath": type == "audio" ? url : null,
            "location": type == "location" ? selected : null,
            "contact": type == "contact" ? selected : null,
            "from": myphno,
            "filename":filename.toString()
          });
         }
        }).whenComplete(() {
          if (url != null) {
            return true;
          }
          return false;
        });
      }
    } else {
      print(users);
      print("users is null");
      getuser();
    }
    if (url != null) {
            return true;
          }
          return false;
  }

  getuser() async {
    var user = await FirebaseAuth.instance.currentUser();

    users = user.phoneNumber;
  }
}
