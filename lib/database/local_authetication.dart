import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import '../homepage.dart';
class LocalAuth extends StatefulWidget {
  @override
  _LocalAuthState createState() => _LocalAuthState();
}

class _LocalAuthState extends State<LocalAuth> {
  bool authent=false;
  LocalAuthentication auth=LocalAuthentication();
 
  checkauth()async

  {

    bool check=await auth.canCheckBiometrics;
print("biomateric is $check");
List<BiometricType> list=await auth.getAvailableBiometrics();
print("auth is $list");
  }
autherize()async{
  try{
   authent= await auth.authenticateWithBiometrics(localizedReason: "please touch fingerprint");
setState(() {
  
});
  }
  catch(e){
    print(e);
  }
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }


Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        //_isAuthenticating = true;
        //_authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
      //  _isAuthenticating = false;
       // _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      //_authorized = message;
      authent=true;
    });
  }
navigator(){
return Builder(builder: (context){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Botomnavigation()));
  });
}
  @override
  Widget build(BuildContext context) {
    checkauth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          home: Scaffold(
                      body: Container(
        color:authent? Colors.green:Colors.red,
        child: Builder(builder: (context){
          return Center(child: FlatButton(onPressed: (){
            _authenticate().whenComplete((){
            print("object");
            authent?Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Botomnavigation())):Offstage();
            });
         
        }, child: Text("touch me")));
        })
      ),
          ),
    );
  }
}