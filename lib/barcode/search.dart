import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/barcode/Info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:inventory_management/barcode/barcode_home.dart';

import '../main.dart';

class Search extends StatefulWidget {
  final searchControl=TextEditingController();
  var text;
  // const Search({Key key}) : super(key: key);
  Search(this.text);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  // AnimationController controller = AnimationController(
  //           vsync: this,
  //           duration: Duration(milliseconds: 200),
  // );
  //
  // CurvedAnimation myAnimation = CurvedAnimation(
  // curve: Curves.linear,
  // parent: controller,
  // );


  Widget searchlist(BuildContext context)  {
    var isSelected=false;
    var mycolor=Colors.white;
    int x=0,y=0;
    print('ourlist');
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
          itemBuilder: (context,int index) {
            y=y+1;
            if (widget.text == goodsNames[index]['id']) {
              x=1;
              return ListTile(
                tileColor: mycolor,
                selected: isSelected,
                leading: Icon(Icons.list),
                title: Text('${goodsNames[index]['id']}'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Info(index);
                      }
                  )
                    ,);
                },
                onLongPress: () {
                  showMenu(
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        value: index,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: logocolor,
                            ),
                            icon: Icon(Icons.delete_forever),
                            label: Text('Delete'),
                            onPressed: () async {
                              print(index);
                              goodsNames.removeAt(index);
                              codes.removeAt(index);
                              await FirebaseFirestore.instance.collection(
                                  'store').doc(inputData()).update(
                                  {'codes': codes, 'goods': goodsNames});
                              setState(() {});
                            }
                        ),
                      )
                    ],
                    context: context,
                    position: new RelativeRect.fromLTRB(0, 0, 0, 0),
                  );
                },
              );
            }

            if(x==0 && y==goodsNames.length){
              return Center(child: Text('Not found'));
            }
            else{
              return SizedBox(height: 0,);
            }
          },
      );

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: logocolordark,
        title: Center(child: Text(widget.text)),

      ),
      body: searchlist(context),
    );
  }
}