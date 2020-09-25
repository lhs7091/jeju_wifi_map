class Data {
  String baseDate;
  String macAddress;
  String apGroupName;
  String installLocationDetail;
  String category;
  String categoryDetail;
  String addressDong;
  String addressDetail;
  String latitude;
  String longitude;

  Data(
      {this.baseDate,
      this.macAddress,
      this.apGroupName,
      this.installLocationDetail,
      this.category,
      this.categoryDetail,
      this.addressDong,
      this.addressDetail,
      this.latitude,
      this.longitude});

  Data.fromJson(Map<String, dynamic> json) {
    baseDate = json['baseDate'];
    macAddress = json['macAddress'];
    apGroupName = json['apGroupName'];
    installLocationDetail = json['installLocationDetail'];
    category = json['category'];
    categoryDetail = json['categoryDetail'];
    addressDong = json['addressDong'];
    addressDetail = json['addressDetail'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseDate'] = this.baseDate;
    data['macAddress'] = this.macAddress;
    data['apGroupName'] = this.apGroupName;
    data['installLocationDetail'] = this.installLocationDetail;
    data['category'] = this.category;
    data['categoryDetail'] = this.categoryDetail;
    data['addressDong'] = this.addressDong;
    data['addressDetail'] = this.addressDetail;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'baseDate': baseDate,
      'macAddress': macAddress,
      'apGroupName': apGroupName,
      'installLocationDetail': installLocationDetail,
      'category': category,
      'categoryDetail': categoryDetail,
      'addressDong': addressDong,
      'addressDetail': addressDetail,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
