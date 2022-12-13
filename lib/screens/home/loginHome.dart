import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_management/barcode/barcode_home.dart';
import 'package:inventory_management/screens/authentication/googleprovider.dart';
import 'package:inventory_management/screens/authentication/signIn.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/main.dart';
import 'package:inventory_management/test.dart';

Future <void> Getdata() async{
  FirebaseFirestore.instance.collection('store').doc(FirebaseAuth.instance.currentUser!.displayName).get().then((DocumentSnapshot documentSnapshot) {
    if(documentSnapshot.exists){
      // print('---------------------------');
      // print(documentSnapshot.data());
      Map <String, dynamic> x =documentSnapshot.data()!;
      // print(x['codes']);
      codes=x['codes'];
      // print(codes);
    }
    else{
      codes=[];
    }
  },);
}

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  var x=0;

  Widget BuildLoading() => Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
              // print(snapshot.hasData);
              // if(snapshot.hasData) {
              //   // print('change');
              //   x=1;
              // }
              // else{
              //   x=0;
              // }
              // print(provider.isSigningIn);
            if(provider.isSigningIn){
              // print('a');
              return CircularProgressIndicator();
            }
            else if(snapshot.hasData){
              // print('b,$x');

              // name= FirebaseAuth.instance.currentUser!.displayName;
              // print('killl');


              // final FirebaseAuth auth=FirebaseAuth.instance;
              // final User usr = auth.currentUser!;
              // String uid = usr.uid;
              // String name=usr.displayName!;
              // print('$name---${FirebaseAuth.instance.currentUser!.displayName}');
              // Getdata();
              // FirebaseFirestore.instance.collection('store').doc(FirebaseAuth.instance.currentUser!.displayName).get().then((DocumentSnapshot documentSnapshot) async {
              //   if(await documentSnapshot.exists){
              //     print('---------------------------');
              //     print(documentSnapshot.data());
              //     Map <String, dynamic> x =await documentSnapshot.data()!;
              //     print(x['codes']);
              //     codes=await x['codes'];
              //     print(codes);
              //   }
              //   else{
              //     codes=[];
              //   }
              // },);
              // print('---\n---\n---\n');
              // print(codes);
              return Barcode_home();
            }
            else {
              // print('c');
              return SignIn();
            }
            }),
      )
    );
  }
}
