class Items {
  Items({
      required this.itemName,
      required this.pieces,
      required this.quantity,
      required this.boxes,});

  Items.fromJson(dynamic json) {
    itemName = json['itemName'];
    pieces = json['pieces'];
    quantity = json['quantity'];
    boxes = json['boxes'];

  }
  String? itemName;
  int? pieces;
  num? quantity;
  num? boxes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['itemName'] = itemName;
    map['pieces'] = pieces;
    map['quantity'] = quantity;
    map['boxes'] = boxes;

    return map;
  }

}