import 'package:jeju_wifi_map/model/data_model.dart';

class WifiModel {
  int totCnt;
  bool hasMore;
  List<Data> data;

  WifiModel({this.totCnt, this.hasMore, this.data});

  WifiModel.fromJson(Map<String, dynamic> json) {
    totCnt = json['totCnt'];
    hasMore = json['hasMore'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totCnt'] = this.totCnt;
    data['hasMore'] = this.hasMore;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
