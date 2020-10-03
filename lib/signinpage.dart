import 'package:charting/username.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charting/homepage.dart';
import 'package:charting/main.dart';
import 'package:charting/secondpage.dart';
void main() => runApp(SignInPage());
class SignInPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInPage();
  }

}
class _SignInPage extends State<SignInPage>{
  final _formkey=GlobalKey<FormState>();
  final formkey=GlobalKey<FormState>();
  bool check=true;
  TextEditingController _textEditingController;
  TextEditingController textEditingController;
  FirebaseAuth _auth =FirebaseAuth.instance;
  String phno;
  String verficationid;
  String smscode;
  bool accept=false;
   Future<bool>smsentybox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("enter a OTP"),
            content: Form(
              key: formkey,
                          child: TextFormField(
                decoration: InputDecoration(labelText: "OTP",border: OutlineInputBorder()),
                controller: textEditingController,
                   keyboardType: TextInputType.number,
                onChanged: (value){
                  
                  this.smscode=value;
                  

                  print(value);
                },
                 validator: (String val){
                   if(val.isEmpty)
                     return "please enter a otp";
                   else if(val.length!=6)
                       return "please enter a currect  otp";
                     else if(val.trim().isEmpty)
                        return "please enter a otp ";
                        
                   
                  },
                  

              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: (){
                  if(formkey.currentState.validate())
                  {
 FirebaseAuth.instance.currentUser().then((user){
                    if(user!=null)
                    {
                      setState(() {
                        check=true; 
                      });
                     
                       Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder:(context)=>Userdetailes()));
                      print("done");
                    }
                    else{
                      Navigator.of(context).pop();
                      sign();
                    }
                  });
                  }
                 
                },
              )
            ],
          );
        });
  }

  sign() async{

    final AuthCredential credential=PhoneAuthProvider.getCredential(verificationId: verficationid, smsCode: smscode);

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    FirebaseUser cutrntuser=await _auth.currentUser();
    assert(user.uid==cutrntuser);
    if(user!=null)
    {
      setState(() {
        check=true; 
      });
      
      Navigator.of(context).push(
        MaterialPageRoute(builder:(context)=>LandingPage()));
      print("sussfull");
    }
    else {
      
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) =>LandingPage()));
              showDialog(
                    context: context,
                    builder: (context)
                    {
                      return AlertDialog(
                      content: Text("Login failed"),
                      title: Text("login failed due to techical error"),
                      );
                    }
              );
    }

  }
  @override
  Widget build(BuildContext context) {
    Future<void> signinwithphno(BuildContext context) async {
       print(phno);
    final PhoneCodeAutoRetrievalTimeout autoretrival = (String verid) {
      this.verficationid = verid;
        
    
    };
    final PhoneCodeSent smscodesent = (String verid, [int forceCodeResend]) {
      this.verficationid = verid;
      smsentybox(context);
    };
    final PhoneVerificationCompleted onCompleted = (AuthCredential authcredicial) {
      _auth.signInWithCredential(authcredicial).whenComplete((){
         
        
      });
  setState(() {
     AuthStatus.Botomnavigation;
       check=true;
  });
    
      print("completed");
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Userdetailes()));
      print("object");
     
                     
    };
    // ignore: non_constant_identifier_names
    final PhoneVerificationFailed verfictionFaile = (AuthException exp) {
      print(exp.message);
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: this.phno,
      timeout:const Duration(seconds: 5),
      verificationCompleted: onCompleted,
      verificationFailed: verfictionFaile,
      codeSent: smscodesent,
      codeAutoRetrievalTimeout: autoretrival,
    );
  }

 
     
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
        home:Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("FEEDIE BHARATH",style: TextStyle(color: Colors.black87
        
        ,fontWeight: FontWeight.bold),),
      ),
      body:  SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         
          children: <Widget>[
               Stack(
                 children: <Widget>[
                    Opacity(
                      opacity: 0.4,
                                        child: Container(
                        padding: EdgeInsets.only(left: 75.0),
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.3),
                    Colors.green.withOpacity(0.4),
                    Colors.orangeAccent.withOpacity(
                      0.5
                    )
                  ]
                )
              ),
                 ),
                    ),
               
               Column(
             mainAxisAlignment: MainAxisAlignment.center,
             
                   children: <Widget>[
                      Container(
                        height: 500.0,
                                            child: check? Stack(
                  children: <Widget>[
                        Form(
                    key: _formkey,
                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        TextFormField(
                            
                            controller: _textEditingController,
                               keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(labelText: 'enter a phone number', 
                                        labelStyle: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.purple), 
                                        
                                         border: OutlineInputBorder(
                                           
                                         ),
                                        
                                          
                              ),

                            onChanged: (value){
                              this.phno="+91"+value;
                            },
                              validator: (String val){
                               if(val.isEmpty)
                                 return "please enter a numbber";
                               else if(val.length!=10)
                                   return "please enter a numbber 10 digite";
                                 else if(val.trim().isEmpty)
                                    return "please enter a numbber ";
                                    else if(int.parse(val.substring(0))<6)
                                        return "please enter a numbber strat with (7-9) digite";
                               
                              },
                             
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                               
                                onChanged: (bool a){
                                 
  
    setState(() {
     accept=a; 
    });
  
                                },
                              value:accept,
                              ),
                              Text("tc")
                            ],
                          ),
                     
                               RaisedButton(
                                child: Text("send otp"),
                                color: Colors.lightBlue,
                                onPressed: ()
                                {
                                     if(_formkey.currentState.validate()){
                                        if(accept)
                                  {
                                     signinwithphno(context);

                                     setState(() {
                                      check=false; 
                                     });
                                  }
                                  
                                  else{
                                    showDialog(
                                    context: context,
                                    builder: (context)
                                    {
                                      return AlertDialog(
                                        content: Text("please accept T&C"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("ok"),
                                            onPressed: (){
                                               Navigator.pop(context);
                                            },

                                          )
                                        ],
                                      )
                                      ;
                                    
                                  }
                                    );
                                  }
                                  
                                     }

                                }
                                
                               

                            ),
                          
                        ],
                    ),
                  ),
                  ],
                     
              ):Center(child:CircularProgressIndicator()),
                      ),
                   ],
               ),
            
                 ],
               )
          ],
               
        ),
      ),
      
        ),
  
    );
  }
}
