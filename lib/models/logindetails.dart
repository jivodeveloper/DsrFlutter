class logindetails {

  logindetails({
    required this.personId,
    required this.personType,
    required this.personName,
    required this.userName,
    required this.group,
    required this.beatId,
    required this.beatName,
    required this.target,
    required this.targetBoxes,
  });

  int personId=0;
  String personType="";
  String personName="";
  String userName="";
  String group="";
  String beatId="";
  String beatName="";
  int target=0;
  int targetBoxes=0;
  int assignedshops=0;
  int coveredshops=0;
  int productiveshops=0;

  logindetails.fromJson(Map<String, dynamic> json) {
    personId = json['personID'];
    personType = json['personType'];
    personName = json['personName'];
    userName = json['userName'];
    group = json['group'];
    beatId = json['beatId'];
    beatName = json['beatName'];
    target = json['target'];
    targetBoxes = json['targetBoxes'];
    assignedshops = json['AssignedShops'];
    coveredshops = json['shopsCovered'];
    productiveshops = json['shopsProductive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personID'] = this.personId;
    data['personType'] = this.personType;
    data['personName'] = this.personName;
    data['userName'] = this.userName;
    data['group'] = this.group;
    data['beatId'] = this.beatId;
    data['beatName'] = this.beatName;
    data['target'] = this.target;
    data['targetBoxes'] = this.targetBoxes;
    data['AssignedShops'] = this.assignedshops;
    data['shopsCovered'] = this.coveredshops;
    data['shopsProductive'] = this.productiveshops;
    return data;
  }

}