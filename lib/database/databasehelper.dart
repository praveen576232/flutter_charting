import 'package:flutter/foundation.dart';

class Message {

  String toorfrom;
  String msgtype;
  String msg;
  String date;
  String time;

  String imgpath;
  String vediopath;
  String pdfpath;
  String audiopath;
  String location;
  String contact;


  Message(
      {
      @required this.toorfrom,
      @required this.msgtype,
      @required this.msg,
      @required this.date,
      @required this.time,
  
      @required this.imgpath,
      @required this.vediopath,
      @required this.pdfpath,
      @required this.audiopath,
      @required this.location,
      @required this.contact,
    
    
      });
  Map<String, dynamic> map() {
    return {
    
      "toorfrom": toorfrom,
      "msgtype": msgtype,
      "msg": msg,
      "date": date,
      "time": time,
      "imgpath": imgpath,
      "vediopath": vediopath,
      "pdfpath": pdfpath,
      "audiopath":audiopath,
      "location":location,
      "contact":contact,
  
    
    };
  }
}
