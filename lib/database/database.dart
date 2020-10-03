//import 'dart:io';

import 'dart:io';
import 'dart:async';
import 'package:charting/database/databasehelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class Databasehelper {
  Database database;
  String tablename;
 
  Databasehelper(this.tablename);

  Future<Database> get database1 async {
   
      print("datase is $database");
      if (database == null) {
        database = await createdatabase();
      } 
    return database;
  }
  Future<Database> createdatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
   String path = directory.path + "/${this.tablename}.db";
    print("path $path");
    var data =await openDatabase(path, version: 1,
        onCreate: create).whenComplete((){
          print("completed");
        });
    return data;  
  }


  create(Database db, int version) async {
   print("in create table");
      await db.execute(
          "CREATE TABLE $tablename (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,toorfrom TEXT, msgtype TEXT,msg TEXT,date TEXT,time TEXT,imgpath TEXT,vediopath TEXT,pdfpath TEXT,audiopath TEXT,location TEXT,contact TEXT)");   
  }

  Future<List<Map<String, dynamic>>> getallresult(String table) async {

    Database db = await this.database1;
    var result = await db.query(table);
   print(result);
    return result;
  }

  Future<int> insertion(Message message, String table) async {

    Database db = await this.database1;
    var result = await db.insert(table, message.map());
  print(result);
    return result;
  }
  Future<int> delete(int  id, String table) async {

    Database db = await this.database1;
    var result=db.rawDelete("DELETE FROM $table WHERE id=$id");
    return result;
  }
    Future<void> deletetable(String path) async {

    Database db = await this.database1;
    var result=deleteDatabase(path);
    print(result);
   //
    return result;
  }
  Future<int> getlength(String table)async
  {
    Database db=await this.database1;
    var x = await db.rawQuery('SELECT COUNT (*) FROM $table');
 
    int count=Sqflite.firstIntValue(x);
    print(count);
    return count;

      }
      Future<void> updatedata(String table,Message updaterow,int id)async
      {
        Database db=await this.database1;
   // var x = await db.rawUpdate('UPDATE $table SET $filename=$filepath WHERE id=$id');
    var y=await db.update(table, updaterow.map(),where:'id=?',whereArgs: [id]);
   print("update is done $y");
      }
Future<String> currentdata(int id,String table)async
  {
    String type;
    Database db=await this.database1;
    var x = await db.rawQuery('SELECT * FROM $table WHERE id=$id');
 
   print("last data is $x");
    print(x[0]['msgtype']);
switch(x[0]['msgtype'])
{
case "msg":return x[0]['msg'];
case "image":return "image";
case "video":return "video";
case "audio":return "audio";
case "location":return "location";
case "pdf":return "Document";

}

      }
}


