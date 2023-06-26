import 'SalesReport.dart';
import 'Items.dart';

class SaleRep {
  SaleRep({
      this.salesReport, 
      this.items, 
      this.locationData, 
      this.locationType, 
      this.totalQuantity, 
      this.totalPieces, 
      this.totalLocQuantity, 
      this.totalLocPieces, 
      this.person, 
      this.state, 
      this.stateId, 
      this.states, 
      this.zone, 
      this.zoneId, 
      this.zones, 
      this.personId, 
      this.fromDate, 
      this.toDate, 
      this.uom, 
      this.retailerName, 
      this.workSheet,});

  SaleRep.fromJson(dynamic json) {
    if (json['salesReport'] != null) {
      salesReport = [];
      json['salesReport'].forEach((v) {
        salesReport.add(SalesReport.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
    locationData = json['locationData'];
    locationType = json['locationType'];
    totalQuantity = json['totalQuantity'];
    totalPieces = json['totalPieces'];
    totalLocQuantity = json['totalLocQuantity'];
    totalLocPieces = json['totalLocPieces'];
    person = json['person'];
    state = json['state'];
    stateId = json['stateId'];
    states = json['states'];
    zone = json['zone'];
    zoneId = json['zoneId'];
    zones = json['zones'];
    personId = json['personId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    uom = json['UOM'];
    retailerName = json['retailerName'];
    workSheet = json['workSheet'];
  }
  List<SalesReport> salesReport;
  List<Items> items;
  dynamic locationData;
  dynamic locationType;
  double totalQuantity;
  int totalPieces;
  int totalLocQuantity;
  int totalLocPieces;
  String person;
  String state;
  dynamic stateId;
  dynamic states;
  String zone;
  dynamic zoneId;
  dynamic zones;
  int personId;
  String fromDate;
  String toDate;
  dynamic uom;
  dynamic retailerName;
  dynamic workSheet;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (salesReport != null) {
      map['salesReport'] = salesReport.map((v) => v.toJson()).toList();
    }
    if (items != null) {
      map['items'] = items.map((v) => v.toJson()).toList();
    }
    map['locationData'] = locationData;
    map['locationType'] = locationType;
    map['totalQuantity'] = totalQuantity;
    map['totalPieces'] = totalPieces;
    map['totalLocQuantity'] = totalLocQuantity;
    map['totalLocPieces'] = totalLocPieces;
    map['person'] = person;
    map['state'] = state;
    map['stateId'] = stateId;
    map['states'] = states;
    map['zone'] = zone;
    map['zoneId'] = zoneId;
    map['zones'] = zones;
    map['personId'] = personId;
    map['fromDate'] = fromDate;
    map['toDate'] = toDate;
    map['UOM'] = uom;
    map['retailerName'] = retailerName;
    map['workSheet'] = workSheet;
    return map;
  }

}