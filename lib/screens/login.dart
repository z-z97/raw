// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raw/screens/home.dart';
enum Mobile_v_s{
  SHOW_STATE,
  SHOW_OTP,
}
final User user = FirebaseAuth.instance.currentUser;
final uid = user.uid;
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);
  @override
  State<login> createState() => _loginState();
}
class _loginState extends State<login> {
  Mobile_v_s currentState= Mobile_v_s.SHOW_STATE;//first form for user
   final PC = TextEditingController();
  final TC = TextEditingController();
  FirebaseAuth _auth =  FirebaseAuth.instance;

  late String verificationId;
  bool showloding=false;
  void singinwithphoneauth(PhoneAuthCredential phoneAuthCredential) async{
   setState(() {
     showloding = true;
   });
    try {
     final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
     setState(() {
       showloding = false;
     });
     if (authCredential?.user != null)
     {
       Navigator.push(context, MaterialPageRoute(builder: (context)=> home())
     );
     };
   } on  FirebaseAuthException catch (e) {
      setState(() {
        showloding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
   }
  }

  getmobilrformw(context){
  return Column (
    children: [
      Spacer(),
      TextField(
        controller: PC,
        decoration: InputDecoration(
          hintText: "phone Number",
        ),
      ),
      SizedBox (height:16 ,
      ),
      TextButton(
        onPressed: () async {
          setState(() {
            showloding = true;
          });
        await  _auth.verifyPhoneNumber(
              phoneNumber: PC.text,
              verificationCompleted: (phoneAuthCredential) async{
                setState(() {
                  showloding = false;
                });
              },
              verificationFailed: (verificationFailed) async{
                setState(() {
                  showloding = false;
                });
                ScaffoldMessenger.of(context).showSnackBar
                  (SnackBar(content: Text("Login failed")));
              },
              codeSent: (verificationId, resendingToken) async{
              setState(() {
                  showloding = false;
                currentState = Mobile_v_s.SHOW_OTP;
                this.verificationId = verificationId;
               }
               );
              },
              codeAutoRetrievalTimeout: (verificationId) async{
          },


    );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          color: Colors.red,
          child: Text("VERIFY"),
    )
      ),
      Spacer(),
    ],
  );
}
getotpformw(context){
  return Column (
    children: [
      Spacer(),
      TextField(
        controller: TC,
        decoration: InputDecoration(
          hintText: "Enter OTP",
        ),
      ),
      SizedBox (height:16 ,
      ),
      TextButton(
        onPressed: () async{

          final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: TC.text) as PhoneAuthCredential;
          singinwithphoneauth(phoneAuthCredential);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          color: Colors.red,
          child: Text("SEND"),
        ),
      ),
      Spacer(),
    ],
  );
}
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldMessengerKey,
      body: Container (
        child: showloding ? Center( child: CircularProgressIndicator(),):
        currentState == Mobile_v_s.SHOW_STATE
       ? getmobilrformw(context)
          : getotpformw(context),
        padding: const EdgeInsets.all(16),

    )
    );
  }
}


