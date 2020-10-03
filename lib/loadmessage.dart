import 'package:charting/database/database.dart';

class Loadmessage
{
  String databasename;
  Loadmessage(this.databasename);
  
 Stream<List<Map<String,dynamic>>>get allmessage async*
  {
    Databasehelper helper=Databasehelper(this.databasename);
  yield  await helper.getallresult(this.databasename);
//print("loading msg $result");
   //return result;
  }
}