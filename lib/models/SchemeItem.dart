class SchemeItem {

  int itemId=0,quantity=0;
  String? schemename;

  SchemeItem(this.itemId, this.schemename, this.quantity);

  Map toJson() => {
    'itemId': itemId,
    'schemename': schemename,
    'quantity': quantity,
  };


}