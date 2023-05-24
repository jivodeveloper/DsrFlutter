class logindetails {

  logindetails({
    required this.personId,
    required this.personType,
    required this.personName,
    required this.userName,
    required this.group,
    required this.beatId,
    required this.beatName,
  });

  int personId=0;
  String personType="";
  String personName="";
  String userName="";
  String group="";
  String beatId="";
  String beatName="";

  logindetails.fromJson(Map<String, dynamic> json) {
    personId = json['personID'];
    personType = json['personType'];
    personName = json['personName'];
    userName = json['userName'];
    group = json['group'];
    beatId = json['beatId'];
    beatName = json['beatName'];
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
    return data;
  }

}