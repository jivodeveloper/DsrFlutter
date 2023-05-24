class Category {
    int id;
    String typeName;

    Category({required this.id, required this.typeName});

    factory Category.fromJson(Map<String, dynamic> json) {
        return Category(
            id: json['id'], 
            typeName: json['typeName'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['typeName'] = this.typeName;
        return data;
    }
}