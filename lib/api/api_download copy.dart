import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jeju_wifi_map/api/api_key.dart';
import 'package:jeju_wifi_map/model/data_model.dart';

import 'package:http/http.dart' as http;
import 'package:jeju_wifi_map/model/wifi_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class APIService {
  int numPage = 1;
  List<Data> _detailDataList = new List<Data>();

  // get data from api server
  Future<List<Data>> downloadApiData(BuildContext context) async {
    print('downloadApiData start');

    //while (true) {
    //final uri = "${APIKeys.baseUrl}/${APIKeys.serviceKey}?number=$numPage";
    final uri = APIKeys.baseUrl;
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      WifiModel _model = WifiModel.fromJson(data);

      _model.data.forEach((element) {
        _detailDataList.add(element);
      });

      numPage++;
      Toast.show(
        "${numPage}0/${_model.totCnt} complete",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
      //if (_model.hasMore == false || numPage == 400) break;
    }
    //}
    print('downloadApiData finish');

    return _detailDataList;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // 파일 쓰기
    return file.writeAsString('$counter');
  }
}
