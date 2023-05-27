class TodayBeat {
    int beatId;
    String beatName;
    int personId;
    int shopCount;

    TodayBeat({required this.beatId, required this.beatName, required this.personId, required this.shopCount});

    factory TodayBeat.fromJson(Map<String, dynamic> json) {
        return TodayBeat(
            beatId: json['beatId'], 
            beatName: json['beatName'], 
            personId: json['personId'], 
            shopCount: json['shopCount'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['beatId'] = this.beatId;
        data['beatName'] = this.beatName;
        data['personId'] = this.personId;
        data['shopCount'] = this.shopCount;

        return data;
    }
}