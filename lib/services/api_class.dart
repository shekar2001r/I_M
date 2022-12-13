class APIClass{
  final barcode;
  final name;
  final cost;

  APIClass({this.barcode,this.name,this.cost});

  factory APIClass.fromJson(final jsondata){
    return APIClass(
      barcode: jsondata["barcode"],
      name: jsondata["name"],
      cost: jsondata["cost"]
    );
  }

}