// import 'dart:js';

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/screens/home/loginHome.dart';
import 'package:inventory_management/services/api_class.dart';
// import 'package:inventory_management/screens/authentication/authenticate.dart';
// import 'package:inventory_management/screens/home/home.dart';

// import 'package:inventory_management/screens/wrapper/wrap.dart';
import 'package:inventory_management/test.dart';
//
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/screens/authentication/googleprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management/barcode/barcode_home.dart';
import 'package:flutter/services.dart' show rootBundle;


 dynamic result;
 dynamic name;
 List codes=[];
List<dynamic> goodsNames=[];
 List<Future<APIClass>> code_names=[];

final FirebaseAuth auth = FirebaseAuth.instance;

String inputData([int a=0]) {
  final User usr = auth.currentUser!;
  String uid = usr.uid;
  String name=usr.displayName!;
  if( a==1){
    return uid;
  }
  else{return name;}
  // here you write the codes to input the data into firestore
}

Map<String,dynamic> decoded={};
const logocolor=Color(0xff66A3BB);
const logocolordark=Color(0xff253A47);

Future Calldata() async {
  print('////////////////////////////////////]]]]]]]]]]]]]');
  String jsonCrossword = await rootBundle.loadString('assets/store_detail.json');
  decoded = jsonDecode(jsonCrossword);
  // decoded=Map<String,dynamic>.from(decoded);
  print(decoded.containsKey('8901725105303'));
  print(jsonCrossword);
  print(decoded.runtimeType);

  print('=====================)))))))))))))');
  // return decoded;
}
Future<void> main() async {
  // print('hello');
  print('hii prends');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Calldata();
  // print('8888888888888888888888888888888');
  print(decoded);
  // FirebaseFirestore.instance.collection('store').doc(inputData()).get().then((DocumentSnapshot documentSnapshot){
  //   if(documentSnapshot.exists){
  //     print('---------------------------');
  //     print(documentSnapshot.data());
  //     Map <String, dynamic> x = documentSnapshot.data()!;
  //     print(x['codes']);
  //     codes= x['codes'];
  //     print(codes);
  //   }
  // },);

  runApp(ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
          print(snapshot.hasData);
            return MyApp();
          }
        ),
  )
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('store').doc(inputData()).get().then((DocumentSnapshot documentSnapshot){
    //   if(documentSnapshot.exists){
    //     print('---------------------------');
    //     print(documentSnapshot.data());
    //     Map <String, dynamic> x = documentSnapshot.data()!;
    //     print(x['codes']);
    //     codes= x['codes'];
    //     print(codes);
    //   }
    // },);
    return MaterialApp(
      home: LoginHome(),
      // Text('V.Good'),
      // Scaffold(
      //       body: Center(
      //           child: Text('hii')),
      //       ),
    );


      // MaterialApp(
      //   home: LoginHome(),
        // Wrapper(),
    // );
  }
}
