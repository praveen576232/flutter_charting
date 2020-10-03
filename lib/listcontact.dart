import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
class ContactComparator
{
  List<Contact> contacts=[];
  List<DocumentSnapshot> users=[];
 ContactComparator(this.contacts,this.users);

  List<String> names=[];
 
List<String> profile=[];
  compareresult()
  {
     names.clear();
   try
   {
      for(int i=0;i<users?.length;i++)
  {
       for (int j=0;j<contacts?.length;j++)
       {
            if(contacts[j].phones.toList().isNotEmpty)
            {
         
              if(contacts[j].phones.toList().first.value!=null)
              {
                 if(users[i].data['phonenumber']==contacts[j].phones.toList().first.value)
            {
            print(contacts[j].phones.toList().first.value);
            print(contacts[j].givenName);
            //    getprofile(contacts[j].phones.toList().first.value);
             String a=contacts[j].phones.toList().first.value;
             String b=contacts[j].displayName;
             print("$a,$b");
             String temp="$a,$b";
             print("temp is $temp");
              names.add(temp);
           
            }
              }
            }
       }
  }
   print("all users is $names");
  return names;
   }
   catch(e)
   {
      print("all users is3 $names");
     return names;
   }
   return names;
  }
  
}