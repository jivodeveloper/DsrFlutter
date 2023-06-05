class Categorylist {

  Categorylist({
      required this.id,
      required this.typeName});

  factory Categorylist.fromJson(Map<String, dynamic> json) {
    return Categorylist(
        id: json['Id'],
        typeName: json['typeName']
    );
  }
  int id=0;
  String typeName="";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['Id'] = id;
    map['typeName'] = typeName;
    return map;
  }

}