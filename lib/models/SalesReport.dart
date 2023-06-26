class SalesReport {


  SalesReport.fromJson(dynamic json) {
    salesId = json['salesId'];
    personId = json['personId'];
    personName = json['personName'];
    personContact = json['personContact'];
    parentId = json['parentId'];
    parentName = json['parentName'];
    retailerId = json['retailerId'];
    retailerName = json['retailerName'];
    retContact = json['retContact'];
    address = json['address'];
    zone = json['zone'];
    area = json['area'];
    areaId = json['areaId'];
    subArea = json['subArea'];
    state = json['state'];
    date = json['date'];
    pieces = json['pieces'];
    totalQuantity = json['totalQuantity'];
    boxes = json['boxes'];
    personTargetBoxes = json['personTargetBoxes'];
    personTargetLtrs = json['personTargetLtrs'];
    totalPieces = json['totalPieces'];
    schemeQuantity = json['schemeQuantity'];
    products = json['products'];

    productName = json['productName'];
    productQuantity = json['productQuantity'];
    cost = json['cost'];
    totalCost = json['totalCost'];
    stock = json['stock'];
    remarks = json['remarks'];
    deavtivated = json['deavtivated'];
    status = json['status'];
    allowed = json['allowed'];
    retailer = json['retailer'];
    item = json['item'];
    personType = json['personType'];

  }

  int? salesId;
  int? personId;
  String? personName;
  dynamic? personContact;

  SalesReport({
      required this.salesId,
      required this.personId,
      required this.personName,
      this.personContact,
      required this.parentId,
      this.parentName,
      required this.retailerId,
      required this.retailerName,
      this.retContact,
      required this.address,
      required this.zone,
      required this.area,
      required this.areaId,
      required this.subArea,
      required this.state,
      required this.date,
      required this.pieces,
      required this.totalQuantity,
      required this.boxes,
      required this.personTargetBoxes,
      required this.personTargetLtrs,
      required this.totalPieces,
      required this.schemeQuantity,
      required this.products,
      this.productName,
      this.productQuantity,
      required this.cost,
      required this.totalCost,
      this.stock,
      this.remarks,
      this.deavtivated,
      this.status,
      required this.allowed,
      this.retailer,
      this.item,
      this.personType,
});
  int? parentId;
  dynamic? parentName;
  int? retailerId;
  String? retailerName;
  dynamic retContact;
  String? address;
  String? zone;
  String? area;
  int? areaId;
  String? subArea;
  String? state;
  String? date;
  int? pieces;
  num? totalQuantity;
  num? boxes;
  int? personTargetBoxes;
  int? personTargetLtrs;
  int? totalPieces;
  int? schemeQuantity;
  String? products;
  dynamic? productName;
  dynamic? productQuantity;
  int? cost;
  int? totalCost;
  dynamic? stock;
  dynamic? remarks;
  dynamic? deavtivated;
  dynamic? status;
  bool allowed =false;
  dynamic? retailer;
  dynamic? item;

  dynamic? personType;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['salesId'] = salesId;
    map['personId'] = personId;
    map['personName'] = personName;
    map['personContact'] = personContact;
    map['parentId'] = parentId;
    map['parentName'] = parentName;
    map['retailerId'] = retailerId;
    map['retailerName'] = retailerName;
    map['retContact'] = retContact;
    map['address'] = address;
    map['zone'] = zone;
    map['area'] = area;
    map['areaId'] = areaId;
    map['subArea'] = subArea;
    map['state'] = state;
    map['date'] = date;
    map['pieces'] = pieces;
    map['totalQuantity'] = totalQuantity;
    map['boxes'] = boxes;
    map['personTargetBoxes'] = personTargetBoxes;
    map['personTargetLtrs'] = personTargetLtrs;
    map['totalPieces'] = totalPieces;
    map['schemeQuantity'] = schemeQuantity;
    map['products'] = products;
    map['productName'] = productName;
    map['productQuantity'] = productQuantity;
    map['cost'] = cost;
    map['totalCost'] = totalCost;
    map['stock'] = stock;
    map['remarks'] = remarks;
    map['deavtivated'] = deavtivated;
    map['status'] = status;
    map['allowed'] = allowed;
    map['retailer'] = retailer;
    map['item'] = item;

    map['personType'] = personType;

    return map;
  }

}