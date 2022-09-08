// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:raw/screens/home.dart';
enum Mobile_v_up{
  SHOW_STATEup,
  SHOW_OTPup,
}

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}
class _signupState extends State<signup> {
  Mobile_v_up currentState= Mobile_v_up.SHOW_STATEup;//first form for user
  final PC = TextEditingController();
  final TC = TextEditingController();
  final namec = TextEditingController();
  final emilc = TextEditingController();
  final psc = TextEditingController();
  FirebaseAuth _auth =  FirebaseAuth.instance;

  late String verificationId;
  bool showloding=false;

  void singupwithphoneauth(PhoneAuthCredential phoneAuthCredential) async{
    setState(() {
      showloding = true;
    });
    try {
      final authCredential = await
      _auth.signInWithCredential(phoneAuthCredential);
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


  getmobilrformwup(context){
    return Column (
      children: [
        Spacer(),
        TextField(
          controller: namec,
          decoration: InputDecoration(
            hintText: "Name",
          ),
        ),
        TextField(
          controller: PC,
          decoration: InputDecoration(
            hintText: "Phone Number",
          ),
        ),
        TextField(
          controller: emilc,
          decoration: InputDecoration(
            hintText: "Eimal",
          ),
        ),
        TextField(
          controller: psc,
          decoration: InputDecoration(
            hintText: "password",
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
                  ScaffoldMessenger.of(context).
                  showSnackBar(SnackBar(content: Text(" ")));
                },
                codeSent: (verificationId, resendingToken) async{
                  setState(() {
                    showloding = false;
                    currentState = Mobile_v_up.SHOW_OTPup;
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
  getotpformwup(context){
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
            singupwithphoneauth(phoneAuthCredential);


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
  final GlobalKey<ScaffoldMessengerState>
  scaffoldMessengerKeyup = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key:scaffoldMessengerKeyup,
        body: Container (
          child: showloding ? Center( child: CircularProgressIndicator(),):
          currentState == Mobile_v_up.SHOW_STATEup
              ? getmobilrformwup(context)
              : getotpformwup(context),
          padding: const EdgeInsets.all(16),

        )
    );
  }
}


