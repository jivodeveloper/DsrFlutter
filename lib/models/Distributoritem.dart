class Distributoritem {
  int itemid=0;
  int boxes=0;

  Distributoritem(this.itemid, this.boxes);

  Map toJson() => {
    'itemId': itemid,
    'totalPieces': boxes,
  };

  
}