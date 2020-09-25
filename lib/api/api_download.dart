import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jeju_wifi_map/api/api_keys.dart';
import 'package:jeju_wifi_map/model/data_model.dart';
import 'package:jeju_wifi_map/model/wifi_model.dart';

class APIService {
  int dataNum = 1;
  List<Data> _detailDataList = new List<Data>();

  // get data from api server
  Future<List<Data>> downloadApiData(BuildContext context) async {
    print('downloadApiData start');

    final uri = APIKeys.baseUrl;
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      WifiModel _model = WifiModel.fromJson(data);
      _detailDataList = _model.data;
    }

    print('downloadApiData finish');

    return _detailDataList;
  }
}
