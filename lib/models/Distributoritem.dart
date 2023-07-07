class Distributoritem {
  String? itemid;
  String? boxes;

  Distributoritem(this.itemid, this.boxes);

  Map toJson() => {
    'itemId': itemid,
    'totalPieces': boxes,
  };

  
}