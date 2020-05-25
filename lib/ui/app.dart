import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utils/utils.dart' as util;

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AppState();
  }
}


//Home Page
class _AppState extends State<App> {
  String _city;

  Future _toSearch(BuildContext context) async {
    Map res = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(
        builder: (BuildContext context) {
          return new _searchScreen();
        }
    )
    );
    setState(() {
      if (res != null && res.containsKey('city')) {
        _city = res['city'];
        print("$_city");
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Weather App'),
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                _toSearch(context);
              }
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/imgbg.png',
              fit: BoxFit.fill,
              height: 700.0,
              width: 400.0,
            ),
          ),
          new Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            child:
            new Text(
              '${_city == null ? util.defC.toUpperCase() : _city.toUpperCase()}',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(25.0, 300.0, 0.0, 0.0),
            child: weatherText("${_city == null ? util.defC : _city}"),
          )
        ],
      ),
    );
  }
}

//Retrieve Data from API
Future<Map> weather(String city) async {
  String url =
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.APIkey}&units=metric';
  http.Response res = await http.get(url);
  return json.decode(res.body);
}

//Future Builder for showing data
Widget weatherText(String city) {
  return new FutureBuilder(
      future: weather(city == null ? util.defC : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snap) {
        if (snap.hasData) {
          Map c = snap.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                    title: new Text(
                      "${c['main']['temp'].toString()}C",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        'Humidity: ${c['main']['humidity'].toString()}\n'
                            'Min: ${c['main']['temp_min'].toString()}C\n'
                            'Max: ${c['main']['temp_max'].toString()}C\n'
                            'Feels like: ${c['main']['feels_like']}C',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                )
              ],
            ),
          );
        } else {
          return new Container();
        }
      }
  );
}


class _searchScreen extends StatelessWidget {
  var _cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.pink.shade200,
          title: new Text('City'),
          centerTitle: true,
        ),
        body: new Stack(children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/imgbg.png',
              fit: BoxFit.fill,
              height: 700.0,
              width: 400.0,
            ),
          ),
          new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              new ListTile(
                  title: new TextField(
                    decoration: new InputDecoration(
                        hintText: 'Enter City',
                        fillColor: Colors.white
                    ),
                    controller: _cityController,
                    keyboardType: TextInputType.text,
                  )),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'city': _cityController.text
                    });
                  },
                  child: new Text('Enter'),
                  color: Colors.pink.shade200,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ]
        )
    );
  }
}
