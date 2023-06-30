class SalesItem {

  int itemid=0,order=0,stock=0,cost=0;

  SalesItem(this.itemid, this.order, this.stock,this.cost);

  Map toJson() => {
    'itemId': itemid,
    'order': order,
    'stock': stock,
    'cost': cost,
  };


}