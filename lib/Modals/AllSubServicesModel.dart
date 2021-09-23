class AllSubServicesModel{
  int id;
  String name;
  int price;
  String service_type;
  String image;
  String description;

  AllSubServicesModel(
      {this.id,
        this.name,
        this.image,
        this.price,
        this.description,});

  AllSubServicesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];

    price = json['price'];

    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}