class logindetails {

  logindetails({
    required this.personId,
    required this.personType,
    required this.personName,
    required this.userName,
    required this.group,
    required this.target,
    required this.targetBoxes,
    required this.distanceAllowed,
    required this.attStatus,
  });

  int personId=0;
  String? personType;
  String? personName;
  String? userName;
  String? group;
  int? target;
  int? targetBoxes;
  int? assignedshops;
  int? coveredshops;
  int? productiveshops;
  int? distanceAllowed;
  String? attStatus;

  logindetails.fromJson(Map<String, dynamic> json) {
    personId = json['personID'];
    personType = json['personType'];
    personName = json['personName'];
    userName = json['userName'];
    group = json['group'];
    target = json['target'];
    targetBoxes = json['targetBoxes'];
    assignedshops = json['AssignedShops'];
    coveredshops = json['shopsCovered'];
    productiveshops = json['shopsProductive'];
    distanceAllowed = json['distanceAllowed'];
    attStatus=json['attStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personID'] = this.personId;
    data['personType'] = this.personType;
    data['personName'] = this.personName;
    data['userName'] = this.userName;
    data['group'] = this.group;
    data['target'] = this.target;
    data['targetBoxes'] = this.targetBoxes;
    data['AssignedShops'] = this.assignedshops;
    data['shopsCovered'] = this.coveredshops;
    data['shopsProductive'] = this.productiveshops;
    data['distanceAllowed'] = this.distanceAllowed;
    data['attStatus']=this.attStatus;
    return data;
  }

}