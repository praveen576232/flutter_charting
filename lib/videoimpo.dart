import 'dart:async';

import 'package:flutter/cupertino.dart';

class Videoinfo{
int postion=00;
int size=00;
int i=0;
  int p,s;
 Function(int) mypostion;
//StreamController streamController=StreamController<int>();
Videoinfo([mypostion]);

//{

// Timer.periodic(Duration(seconds: 1), (time){
//   p=getvideosize();
//   s=getpostion();
//   if(p!=0)
//  {
// if(!streamController.isClosed){
//   streamController.sink.add(i);
//   i++;

//    print("size $p ,postion $s");
// }

// if(s>=p && p!=0){
//   streamController.close();
//   time.cancel();
//   print("canled");
// }
// }
// if(!streamController.isClosed &&p!=0){
//   print("p $p");
//   streamController.sink.add(i);
//   i++;
//   print(i);
//    print("size $p ,postion $s");
// }
//  if(i>=15){
//   streamController.close();
//   time.cancel();
//   print("canled");
// }
//  });
// }
// setpostion(int po){
//   i=po;
//   if(size!=0)
//   postion=po;
//   print("postion is $postion");
//   if(!streamController.isClosed)
//   {
//     print("added");
//     streamController.sink.add(10.0);
//   }

// if(postion==1.0)
// streamController.close();
//   }
//  if(!streamController.isClosed)
//  {
//     Timer.periodic(Duration(seconds: 1), (t){
//       if(!streamController.isClosed)
//       {
// streamController.sink.add(i);
// i+=1;
// print(i);
// if(i==5){
//   streamController.close();
//   t.cancel();
// }
//       }
// });
//  }
//}
setvideosize(int siz){
 size=siz;
}
setpostion(int po){
  postion=po;
  mypostion(po);
}
 int getvideosize(){
  return size;
//return streamController.stream;
}
int getpostion(){
  
return postion;
}
//Stream get mystream=>streamController.stream;
}