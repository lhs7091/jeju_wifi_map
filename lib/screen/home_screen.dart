import 'package:flutter/material.dart';
import 'package:jeju_wifi_map/api/api_download.dart';
import 'package:jeju_wifi_map/db/db_helper.dart';
import 'package:jeju_wifi_map/model/data_model.dart';
import 'package:jeju_wifi_map/screen/map_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  APIService apiService = APIService();
  DBHelper _dbHelper = DBHelper();
  // ignore: unused_field
  List<Data> _detailDataList = List<Data>();
  bool dbData = false;
  bool apiDownload = false;

  @override
  // ignore: must_call_super
  void initState() {
    _checkDbData();
    //_deleteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5C5E61),
      body: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Container(
            child: Text(
              'Jeju free Wifi Place\n',
              style: TextStyle(
                  color: Color(0xFFE9ECF0),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Please select Get data from Server\nif it's first time",
              style: TextStyle(
                  color: Color(0xFFE9ECF0),
                  fontSize: 20,
                  fontWeight: FontWeight.w100),
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            margin: EdgeInsets.only(right: 15.0),
            alignment: Alignment.centerRight,
            child: Text(
              "updated : #####",
              style: TextStyle(
                color: Color(0xFFE9ECF0),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              print('DownLoading');
              _downloadApiData();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.blue[300], style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.blue,
              ),
              child: apiDownload
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      'Get data from Server',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          GestureDetector(
            onTap: dbData
                ? () {
                    print('go to map');
                    _dbHelper.getCount().then((value) {
                      print(value);
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapScreen()));
                  }
                : () {
                    Toast.show("Please download wifi information", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.blue[300], style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.blue,
              ),
              child: Text(
                'Go to the Map',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Thank you for using this application\n'
                    'It is my first application\n'
                    'If this is useful for your traveling\n'
                    'You can donate to Developer freely',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFFE9ECF0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL();
                  },
                  child: Image.asset("assets/images/default-yellow.png",
                      width: 200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://www.buymeacoffee.com/amfine';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _checkDbData() async {
    int dataCount = await _dbHelper.getCount();
    print(dataCount);

    // there is data in db, get data in db, not api server
    if (dataCount > 0) {
      _detailDataList = await _dbHelper.selectWifi();
      setState(() {
        dbData = true;
        print('DB check complete');
      });
    }
    print('DB is empty');
  }

  _downloadApiData() async {
    setState(() {
      apiDownload = true;
    });

    apiService = new APIService();

    // download data from api servier
    await apiService.downloadApiData(context).then((List<Data> result) {
      print('API download complete');
      _detailDataList = result;
      apiDownload = false;
      _saveApiData();
    });
  }

  _saveApiData() async {
    await _dbHelper.insertWifi(_detailDataList).then((value) {
      setState(() {
        dbData = true;
        print('DB insert complete');
      });
    });
  }

  _deleteData() async {
    await _dbHelper.deleteTable().then((value) {
      print("complete");
      print(_dbHelper.getCount().toString());
    });
  }
}
