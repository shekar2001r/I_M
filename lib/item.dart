

class Item{
  String bcode;
  String id;
  int cost;
  int quantity;
  bool star;
  // Person({this.id = "defaultName", this.cost = "defaultAge",this.bcode = "defaultName",this.quantity = "defaultName",this.star = false});
  Item({this.bcode='-1', this.id: '000', this.cost: 0, this.quantity: 0, this.star: false});
}

// class GList {
//   List<Item> listSVList;
//
//   GList() {
//     this.listSVList = new List<Item>;
//   }
// }

// main(){
//   // List cycle;
//   // cycle.add(1);
//   List<Item> goods =[] ;
//   goods.add(Item(bcode: 'sfgfd'));
// }
// List<Item> ?goods;