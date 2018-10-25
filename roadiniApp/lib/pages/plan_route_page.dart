import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roadini/models/plan_route.dart';
import 'package:roadini/util/person_header.dart';

class PlanRoutePage extends StatefulWidget{
  _PlanRoutePage createState() => _PlanRoutePage();
}
class _PlanRoutePage extends State<PlanRoutePage>{
  List<PlanRoute> listPlan;
  @override
  void initState() {
    super.initState();
    _loadPlane();
  }

  Future<Null> _refresh() async{

    await _getPlane() ;

    setState(() {

    });
    return;
  }
  _iterateOverList(){
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < listPlan.length; i++){
      list.add(
          new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Align(
                        alignment: Alignment.centerLeft,
                        child: new Padding(padding: new EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                          child : new Text(listPlan[i].categoryName,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(90, 113, 113, 1.0),
                            ),
                          ),
                        )),
                    new Align(
                      alignment: Alignment.centerRight,
                      child : new Container(
                        child: Row(children: <Widget>[
                          new Padding(padding: new EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 0.0),
                            child: new GestureDetector(
                              child: const Icon(
                                Icons.edit,
                                size: 25.0,
                                color: Color.fromRGBO(90, 113, 113, 1.0),
                              ),
                              onTap: () => _changeCategory(listPlan[i]),
                            ),
                          ),
                          new Padding(padding: new EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 0.0),
                            child : new GestureDetector(
                              child: const Icon(
                                Icons.delete_forever,
                                size: 25.0,
                                color: Color.fromRGBO(90, 113, 113, 1.0),
                              ),
                              onTap: () => _deleteCategory(listPlan[i]),
                            ),
                          )
                        ],),
                      ),
                    ),
                  ],),
                Divider(),
                new Text(listPlan[i].placeName,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize:20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(90, 113, 113, 1.0),
                  ),
                ),
                listPlan[i].imageCard(),
                new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(listPlan[i].placeDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: new TextStyle(
                            color: Colors.black87
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
    return list;
  }
  _deleteCategory(element){
    print("del element");
    listPlan.remove(element);
    setState(() {

    });
  }
  _changeCategory(element){
    int idx = listPlan.indexOf(element);
    print(idx);
    print(element.categoryId);

  }
  _buildPlan(){
    if(listPlan != null){
      return new ListView(
        children: <Widget>[
          PersonHeader(),
          new Column(children: _iterateOverList()),
          new Column(
            children: <Widget>[
              ButtonTheme(
                minWidth: 100.0,
                child : new RaisedButton(
                  splashColor: Colors.yellow,
                  color: Color.fromRGBO(90, 113, 113, 1.0),
                  child: new Text(
                    "Save Route",
                    style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      );

    }else{
      return new ListView(children: <Widget>[
        PersonHeader(),
        new Container(
            alignment: FractionalOffset.center,
            child: new CircularProgressIndicator()
        )
      ],);
    }


  }

  _loadPlane() async {
    _getPlane();
  }
  _getPlane() async {
    String result ="";
    List<PlanRoute> tmpListPlan;
    try {
      String jsonString = await _loadJsonAsset();
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      tmpListPlan = _generatePlan(jsonResponse);

      /*var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        String json = await response.transform(utf8.decoder).join();
        prefs.setString("feed", json);
        List<Map<String, dynamic>> data =
        jsonDecode(json).cast<Map<String, dynamic>>();
        listOfPosts = _generateFeed(data);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }*/
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);
    setState(() {
      listPlan= tmpListPlan;
    });
  }
  List<PlanRoute> _generatePlan(List planJson){
    List<PlanRoute> listPlans = [];
    for(var planData in planJson){
      listPlans.add(new PlanRoute.fromJSON(planData));
    }
    return listPlans;

  }
  Future<String> _loadJsonAsset() async{
    return await rootBundle.loadString('assets/planRoute.json');
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(child: _buildPlan(), onRefresh: _refresh),
    );
  }
}

