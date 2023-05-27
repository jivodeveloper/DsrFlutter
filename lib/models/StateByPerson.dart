class StateByPerson {

  int? stateId;
  String? state;
  int? zoneId;
  String? zone;
  int? areaId;
  String? area;
  int? subAreaId;
  String? subArea;

  StateByPerson({
      required this.stateId,
      required this.state,
      required this.zoneId,
      required this.zone,
      required this.areaId,
      required this.area,
      required this.subAreaId,
      required this.subArea,});

  StateByPerson.fromJson(dynamic json) {
    stateId = json['stateId'];
    state = json['state'];
    zoneId = json['zoneId'];
    zone = json['zone'];
    areaId = json['areaId'];
    area = json['area'];
    subAreaId = json['subAreaId'];
    subArea = json['subArea'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['stateId'] = stateId;
    map['state'] = state;
    map['zoneId'] = zoneId;
    map['zone'] = zone;
    map['areaId'] = areaId;
    map['area'] = area;
    map['subAreaId'] = subAreaId;
    map['subArea'] = subArea;
    return map;
  }

}