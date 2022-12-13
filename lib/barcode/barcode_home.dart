import 'dart:convert';
// import 'dart:js';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:inventory_management/barcode/Info.dart';
import 'package:inventory_management/barcode/search.dart';
import 'package:inventory_management/fonts/my_flutter_app_icons.dart';
import 'package:inventory_management/item.dart';
import 'package:inventory_management/screens/home/home.dart';
import 'package:inventory_management/screens/authentication/googleprovider.dart';
import 'package:inventory_management/services/api_class.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../main.dart';
import 'package:flutter/services.dart' show rootBundle;

List<Item> goods=[];
// List<Map> goodsNames=[];


class Barcode_home extends StatefulWidget {

  @override
  _Barcode_homeState createState() => _Barcode_homeState();
}

class _Barcode_homeState extends State<Barcode_home> {
  static const IconData account_circle_outlined = IconData(0xe010, fontFamily: 'MaterialIcons');
  static const IconData userIcon= IconData(0xe009, fontFamily: 'MaterialIcons');
  static const IconData user=MyFlutterApp.user;
  var result='kya hein ye ';
  var isSelected=false;
  var mycolor=Colors.white;

  // Calldata();

  // Map <String, String> x ={'hi':'hello'};
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





  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      codes.add(barcodeScanRes);
      // goods.add(Item(bcode: barcodeScanRes));
      code_names.add(getData(barcodeScanRes));
      goods.add(Item(bcode: barcodeScanRes));
      print(codes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      result = barcodeScanRes;
    });
  }




  Future<void> adddata(codes) async{
    FirebaseFirestore.instance.collection('store').add(codes);
  }
  Future <String> Getdata() async{
    await FirebaseFirestore.instance.collection('store').doc(FirebaseAuth.instance.currentUser!.displayName).get().then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.exists){
        print('---------------------------');
        print(documentSnapshot.data());
        Map <String, dynamic> x =documentSnapshot.data()!;
        print(x['codes']);
        codes=x['codes'];
        print(x['goods'].runtimeType);
        print(goodsNames);
        goodsNames=x['goods'];
        print('hello');
        print(goodsNames);
        print(codes);
      }
      else{
        codes=[];
      }
    },);
    return 'hai';
  }



  Widget Fill(BuildContext){
    int l=goods.length-1;
    var nc;
    var cc;
    print(decoded);
    print(goods.length);
    print(goods[l].bcode);
    print(codes[codes.length-1]);
    var key=codes[codes.length-1];
    if(decoded.containsKey('$key')){
      print('neneeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      nc=decoded['$key']['name'];
      cc=decoded['$key']['cost'];
    }
    else{
      print('manaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      nc=null;
      cc=null;
    }
    final GlobalKey<FormState> _key= GlobalKey<FormState>();
    final nameControl =TextEditingController(text: nc);
    final costControl =TextEditingController(text: cc);
    final quantityControl=TextEditingController();
    return Material(
      child: Form(
        key: _key,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: nameControl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    // border: OutlineInputBorder(),
                    labelText: 'Item Name*',
                      // fillColor: Colors.amber,
                      // focusColor: Colors.cyan

                  ),
                ),
                TextFormField(
                  controller: costControl,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: 'Cost(₹)',
                  ),
                  keyboardType: TextInputType.number ,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                TextFormField(
                  controller: quantityControl,
                  // cursorColor: Theme.of(context).cursorColor,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    labelText: 'Quantity',


                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: logocolor,
                    ),
                    onPressed: (){
                    print(nameControl.text);
                    print(codes.length);
                    print(goods.length);

                    goods[l].id=nameControl.text;
                    goods[l].cost=int.parse(costControl.text);
                    goods[l].quantity=int.parse(quantityControl.text);
                    Navigator.pop(context);}, child: Text('submit'),),
                ),
              ],
            ),
          )),
    );
  }
  List selected=[];
  Widget Ourlist(BuildContext context)  {
    // await Getdata();
    print('ourlist');
    print(selected);
    print(goodsNames.length);
    // print('$codes,------${goods.length},${goods[0].id}');
    print(goodsNames.length);
    if(codes.length==0){
      return Center(child: Text('Add item',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),));
    }
    else{
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(12, 10, 15, 12),
        itemCount: goodsNames.length,
        itemBuilder: (context,int index){
          // print('$index,${selected.contains(index)}');
          // if(selected.contains(index)){isSelected=true;}
          // else{isSelected=false;}
          if(selected.contains(index)){
            mycolor=Colors.grey;
          }
          else{
            mycolor=Colors.white;
          }
          // print(isSelected);
          return ListTile(
            tileColor: mycolor,
            selected: isSelected,
            leading: Icon(Icons.list),
            title: Text('${goodsNames[index]['id']}'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> Info(index)),).then((value)=>setState((){}));

          },
            //
            onLongPress: (){
              showMenu(
                items: <PopupMenuEntry>[
                  PopupMenuItem(
                    value: index,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: logocolor,
                      ),
                        icon: Icon(Icons.delete),
                        label: Text('Delete'),
                        onPressed: () async {
                          print(index);
                          goodsNames.removeAt(index);
                          codes.removeAt(index);
                          await FirebaseFirestore.instance.collection('store').doc(inputData()).update({'codes': codes,'goods': goodsNames });
                          setState(() {
                          });
                        }
                    ),
                  )
                ],
                context: context, position: new RelativeRect.fromLTRB(0,0,0,0),
              );
              // if(selected.contains(index)){
              //   selected.remove(index);
              // }
              //   else{
              //     selected.add(index);
              // }
              // setState(() {  });
            },

          );
        }
        );
  }
    }


  Widget OurChecklist(BuildContext context)  {
    if(codes.length==0){
      return Center(child: Text('Add item',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),));
    }
    else{
      return ListView.builder(
          padding: EdgeInsets.fromLTRB(12, 10, 15, 12),
          itemCount: goodsNames.length,
          itemBuilder: (context,int index){
            return CheckboxListTile(
              tileColor: mycolor,
              selected: isSelected,

              value: timeDilation != 1.0,
              secondary: Icon(Icons.list),
              title: Text('${goodsNames[index]['id']}'),
              onChanged: (bool ?value){
                setState(() {
                  timeDilation = value! ? 10.0 : 1.0;
                });
                print(isSelected);
              },

            );
          }
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    // var goods=new List<Item>;

    // goods.add(Item(bcode: 'sdfgsf'));
    // FirebaseFirestore.instance.collection('store').doc(FirebaseAuth.instance.currentUser!.displayName).get().then((DocumentSnapshot documentSnapshot) async{
    //   if(documentSnapshot.exists){
    //     print('---------------------------');
    //     print(documentSnapshot.data());
    //     Map <String, dynamic> x =documentSnapshot.data()!;
    //     print(x['codes']);
    //     codes=x['codes'];
    //     print(codes);
    //   }
    //   else{
    //     codes=[];
    //   }
    // },);
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
// ncSnapshot<T> is simply a representation of that data/error state. This is actually a useful API!

    return Scaffold(
      // drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: logocolordark,
        title: Text('My List'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(onPressed: (){
            final searchControl=TextEditingController();
            showMenu(context: context,

                position: new RelativeRect.fromLTRB(0, 0, 0, 0),
                items: <PopupMenuEntry>[
                  PopupMenuItem(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              width:1300,
                              child: TextFormField(
                                controller: searchControl,
                                  decoration: InputDecoration(
                                    labelText: 'Search',
                                  ),
                  ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Search(searchControl.text)));
                            }, icon:Icon(Icons.search) ),
                          ),
                        ],
                      ))
                ],);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
          }, icon: Icon(Icons.search)),
          IconButton(
            tooltip: 'Profile',
          onPressed: () async{
                    // final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return Home();
                      }
                      )
                    ,);
                    },

              icon: Icon(
                user,
                size: 17,
              ),
          ),
        ],
      ),
      // body: Ourlist(context),

      body: FutureBuilder<String>(
          future: Getdata(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Ourlist(context);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
      floatingActionButton: Container(
        child: FloatingActionButton.extended(
          backgroundColor: logocolor,
          icon: Icon(Icons.camera_enhance),
          label: Text('Scan'),
          onPressed: () async {
            await scanBarcodeNormal();
            // goods.add(Item(bcode: codes[codes.length-1]));
            // Map details ={'bcode':0,'id':'0','cost':0,'qauntity':0,'star':false};
            FirebaseFirestore.instance.collection('store').doc(inputData()).set({'${inputData()}': '${inputData(1)}','codes': codes,'goods': goodsNames});
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>Fill(context)));

            int ll=goods.length-1;
            Map details ={'bcode':0,'id':'0','cost':0,'qauntity':0,'star':false};


            details['bcode']=int.parse(goods[ll].bcode);details['id']=goods[ll].id;details['cost']=goods[ll].cost;
            details['quantity']=goods[ll].quantity;details['star']=goods[ll].star;
            goodsNames.add(details);

            // for (int i=0;i<goods.length;i++){
            //   details['bcode']=int.parse(goods[i].bcode);details['id']=goods[i].id;details['cost']=goods[i].cost;details['quantity']=goods[i].quantity;
            //   details['star']=goods[i].star;
            //   goodsNames.add(details);
            // }
            // for (int i=0;i<goods.length;i++){
            //   print(goodsNames[i]['id']);
            // }
            // // print('next*****************************');
            // for (int i=0;i<goods.length;i++){
            //   print(goods[i].id);
            // }
          await FirebaseFirestore.instance.collection('store').doc(inputData()).update({'${inputData()}': '${inputData(1)}','goods': goodsNames });
            setState(() {  });
            // Calldata();
          },
        ),
      ),
      drawer: Drawer(
        // elevation: 15,
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          children: <Widget>[
            // Container(
            //   padding: EdgeInsets.all(0),
            //   margin: EdgeInsets.all(0),
            //   height: 100,
            //   child: DrawerHeader(
            //     child: Center(child: Text('IM')),
            //     margin: EdgeInsets.all(0),
            //     padding: EdgeInsets.all(0),
            //   ),
            // ),
            Image(image: AssetImage('assets/IM-logos.jpeg'),),
            ListTile(
              // selectedTileColor: Colors.amber,
              title: Text('Clear list',style: TextStyle(fontSize: 18),),
              onTap: (){print('hello');
              codes.clear();
              goods.clear();
              goodsNames.clear();
              FirebaseFirestore.instance.collection('store').doc(inputData()).set({'${inputData()}': '${inputData(1)}','codes': codes ,'goods': goods});
              setState(() {});
              print(codes.length);
              },
            ),
            Divider(height: 2,thickness: 1,indent: 7,endIndent: 5,),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              // selectedTileColor: Colors.blue,
              // leading: Icon(user,size: 15,),
              // title: Text('Profile'),
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.body1,
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 9,0),
                        // padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(user,size: 18,),
                      ),
                    ),
                    // SizedBox(width: 5,),
                    TextSpan(text: 'Profile',style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              // minLeadingWidth: 5,
              onTap: () async{
                final provider= Provider.of<GoogleSignInProvider>(context,listen: false);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()),);
              },
            )
          ],
        ),

      ),
    );
  }
}

// import 'dart:async' show Future;





Future<APIClass> getData(code) async{
  //making request
  http.Response response = await http.get(Uri.parse('/home/rarvis/AndroidStudioProjects/inventory_management/assets=$code.html'));
  final data = jsonDecode(response.body);

  return APIClass.fromJson(data);

}