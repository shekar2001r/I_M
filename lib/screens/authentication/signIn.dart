import 'dart:ui';
import 'package:inventory_management/fonts/my_flutter_app_icons.dart';
import 'package:inventory_management/main.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/screens/home/home.dart';
import 'package:inventory_management/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'googleprovider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
  // dynamic result;
  final Authservice _auth =Authservice();
  static const IconData user=MyFlutterApp.user;
  bool isloading =false;

   Widget build(BuildContext context) {
    //var FF8C1128;
    return Scaffold(
      // backgroundColor: Color.cyanAccent ,
       backgroundColor: Color(0xffE2E2E2) ,
      // appBar: AppBar(
      //   title: Text('login')
      // ),
      body: Container(
        //backgroundColor: Colors.cyan;
        padding: EdgeInsets.fromLTRB(50,100,50,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/greyLogo.jpeg'),
            ),


          //   Expanded(
          //     flex: 1,
          //     child: TextButton(
          //     child: Text('Anon'),
          //     onPressed: () async {
          //       result =await _auth.signInAnon();
          //       if(result==null){
          //         print('error anon sign in');
          //       }
          //       else {
          //         print(result);
          //         Navigator.push(context, MaterialPageRoute(
          //                  builder: (context) => Home()));
          //         print('signedin');
          //         name=result.uid;
          //         print(result.uid);
          //       }
          //       },
          //     )
          // ),
            SizedBox(height: 15,),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: logocolor,
                padding: EdgeInsets.all(20),
                textStyle: TextStyle(
                  fontSize: 19,
                  fontFamily: 'NotoSans',
                )
              ),
                icon: FaIcon(FontAwesomeIcons.google),
                label: Text('Google SignIn'),
                onPressed: (){
                  final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.login();

                }
            ),
            // Expanded(
            //     flex: 1,
            //     child: isloading? Column(
            //       children: <Widget>[
            //         CircularProgressIndicator(),
            //         Divider(
            //           height: 20,
            //           color: Colors.transparent,
            //         ),
            //         Text("Please wait..."),
            //       ],
            //       mainAxisSize: MainAxisSize.min,
            //     )
            //
            //     :
            //     DecoratedBox(
            //       decoration:
            //       ShapeDecoration(shape: Border.symmetric(), color: Colors.white),
            //       child: ElevatedButton.icon(
            //           icon: FaIcon(FontAwesomeIcons.google),
            //           label: Text('Google SignIn'),
            //         onPressed: (){
            //             // ('hi');
            //             // setState(() {
            //             //   isloading = true;
            //             // });
            //             final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
            //
            //             // isloading=true;
            //             // print('startedf-logging');
            //             // print(provider.isSigningIn);
            //             provider.login();
            //             // print('logged');
            //             // setState(() {
            //             //   isloading = false;
            //             // });
            //             // isloading=provider.isSigningIn;
            //             // print('hello');
            //           }
            //       ),
            //     )
            // ),
            Expanded(
                flex: 1,
                child: SizedBox(height: 10,)),
            Text('Welcome',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSans'
            ),),
            SizedBox(height: 75,),

            // logged(context),
        ]
        ),
    ),

    );
  }
}
