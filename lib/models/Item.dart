class Item {
  int? itemID;
  String? itemName;
  String? itemCode;
  num? quantity;
  bool? status;
  int? mrp;
  int? piecesPerCase;
  int? uOMId;
  int? typeNameId;
  bool? visibleToSO;
  bool? visibleToPromoter;
  int? itemTypeId;
  bool? isScheme;
  int? gst;
  String? hsnCode;
  bool? isCashback;

  bool? isVisibleToRetailer;
  bool? isRedeemable;
  num? boxes;

  Item(
      {this.itemID,
        this.itemName,
        this.itemCode,
        this.quantity,

        this.status,
        this.mrp,
        this.piecesPerCase,

        this.uOMId,

        this.typeNameId,

        this.visibleToSO,
        this.visibleToPromoter,
        this.itemTypeId,
        this.isScheme,
        this.gst,
        this.hsnCode,
        this.isCashback,
        this.isVisibleToRetailer,
        this.isRedeemable,
        this.boxes,
     });

  Item.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    itemName = json['itemName'];
    itemCode = json['itemCode'];
    quantity = json['quantity'];
    status = json['status'];
    mrp = json['mrp'];
    piecesPerCase = json['piecesPerCase'];
    uOMId = json['UOMId'];
    typeNameId = json['typeNameId'];
    visibleToSO = json['visibleToSO'];
    visibleToPromoter = json['visibleToPromoter'];
    itemTypeId = json['itemTypeId'];
    isScheme = json['isScheme'];
    gst = json['gst'];
    hsnCode = json['hsnCode'];
    isCashback = json['isCashback'];
    isVisibleToRetailer = json['isVisibleToRetailer'];
    isRedeemable = json['isRedeemable'];
    isRedeemable = json['Boxes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['itemName'] = this.itemName;
    data['itemCode'] = this.itemCode;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['mrp'] = this.mrp;
    data['piecesPerCase'] = this.piecesPerCase;
    data['UOMId'] = this.uOMId;
    data['typeNameId'] = this.typeNameId;
    data['visibleToSO'] = this.visibleToSO;
    data['visibleToPromoter'] = this.visibleToPromoter;
    data['itemTypeId'] = this.itemTypeId;
    data['isScheme'] = this.isScheme;
    data['gst'] = this.gst;
    data['hsnCode'] = this.hsnCode;
    data['isCashback'] = this.isCashback;
    data['isVisibleToRetailer'] = this.isVisibleToRetailer;
    data['isRedeemable'] = this.isRedeemable;
    data['Boxes'] = this.boxes;
    return data;
  }
}