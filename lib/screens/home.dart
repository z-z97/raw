import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raw/screens/login.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("home screen"),
      ),
      floatingActionButton: FloatingActionButton( onPressed: ()async{
        await _auth.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> login()));

      },
        child: Icon(Icons.logout),
      ),

    );
  }
}