import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roadini/models/plan_route.dart';
import 'package:roadini/util/person_header.dart';
import 'package:roadini/models/app_location.dart';
import 'package:roadini/models/user_app.dart';
import 'package:dio/dio.dart';

class PlanRoutePage extends StatefulWidget{
  _PlanRoutePage createState() => _PlanRoutePage();
}
class _PlanRoutePage extends State<PlanRoutePage>{

  List<PlanRoute> listChoices;
  List<PlanRoute> listPlan;
  PlanRoute editElement;
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

  Future<Null> _refresh2() async{

    await _getListCategory() ;

    setState(() {

    });
    return;
  }
  _getChoices(BuildContext context, element){
    editElement = element;
    _getListCategory();

    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Center(
        child: new Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text("RoadIni"))),
          body: new RefreshIndicator(child: _clickedElementEdit(), onRefresh: _refresh2),
        ),
      );
    }));

  }
  _clickedElementEdit() {
    print(editElement);
    if(listChoices != null) {
      return new ListView(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Text("Select a new " + editElement.categoryName,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(43, 65, 65, 1.0)
                        ) ,
                      )
                  )],
              ),),
            new Column(children: _iterateOverChoices()),
          ]
      );

    }
    else{
      return new ListView(
          children: <Widget>[
            PersonHeader(),
            new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator()
            )
          ]
      );
    }
  }
  _iterateOverChoices(){
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < listChoices.length; i++){
      list.add(
          new GestureDetector(
            child: new Card(
                elevation: 1.7,
                child: new Padding(padding: new EdgeInsets.all(10.0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Container(
                                  child: new Text(listChoices[i].placeName,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(43, 65, 65, 1.0),
                                    ),
                                  ),
                                  height: 40.0,
                                ),
                                new Container(
                                  child: new Text(listChoices[i].placeDescription,
                                    style: new TextStyle(),
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  height: 120.0,
                                ),
                              ],
                            ),
                          ),
                          new Expanded(
                            child: new Container(
                              padding: new EdgeInsets.fromLTRB(160.0, 80.0, 0.0, 80.0),
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new NetworkImage(listChoices[i].urlImage),
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  ,)
            ),
            onTap: () => _handleChoice(listChoices[i]),
          )
      );
    }
    return list;
  }
  _handleChoice(choice){
    listPlan[listPlan.indexOf(editElement)] = choice;
    Navigator.of(context).pop();
  }

  _clickedItem(BuildContext context, element){
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Center(
          child: new Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Center(child: Text(element.placeName))),
              body:new ListView(
                  children: <Widget>[
                    /*new Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                              child: Text(element.placeName,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(43, 65, 65, 1.0)
                                ) ,
                              )
                          )],
                      ),),*/
                    new Container(
                        child: Image.network(element.urlImage)
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0),
                      child: new Text(element.placeDescription),
                    )
                  ]
              )
          )
      );
    })
    );

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
                            child : new GestureDetector(
                              child: const Icon(
                                Icons.remove_red_eye,
                                size: 25.0,
                                color: Color.fromRGBO(90, 113, 113, 1.0),
                              ),
                              onTap: () => _clickedItem(context, listPlan[i]),
                            ),
                          ),
                          new Padding(padding: new EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 0.0),
                              child : new GestureDetector(
                                  child: const Icon(
                                    Icons.edit,
                                    size: 25.0,
                                    color: Color.fromRGBO(90, 113, 113, 1.0),
                                  ),
                                  onTap: () => _getChoices(context, listPlan[i])
                              )
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
                new Column(
                  children: <Widget>[
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
                            maxLines: 3,
                            style: new TextStyle(
                                color: Colors.black87
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
  _getListCategory ()async{
    String result ="";
    List<PlanRoute> tmpListCategory;


    try {
      String jsonString = await _loadJsonAsset('assets/categoryRestaurant.json');
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      tmpListCategory = _generatePlan(jsonResponse);

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
      listChoices = tmpListCategory;
    });
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
                  onPressed: () {_addToFeed();},
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
  _addToFeed(){
    print(listPlan);
    final container = AppLocationContainer.of(context);
    print(container.getStartLocation().latitude);
    String url = "https://maps.googleapis.com/maps/api/staticmap?center="+ container.getStartLocation().latitude.toString() + "," + container.getStartLocation().longitude.toString() + "&zoom=12&size=300x150&maptype=roadmap";
    String placesIds = "";
    for(PlanRoute p in listPlan){
      url += "&markers=" + p.lat.toString() + "," + p.lng.toString();
      placesIds += (p.placeId) + ",";
    }
    url += "&key=AIzaSyAKzTjJcIZKZDs2-ZD3B1njQl2mN3Tu5l8";
    final containerU = AppUserContainer.of(context);
    int id = containerU.getUser().userId;
    print(placesIds);

    Dio dio = new Dio();
    FormData formData = new FormData(); // just like JS
    formData.add('urlStatic' ,url);
    formData.add('localsIds' ,placesIds);
    dio.post("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/saveRoute/" + id.toString(), data: formData, options: Options(
        method: 'POST',
        responseType: ResponseType.PLAIN // or ResponseType.JSON
    ))
        .then((response) => _handleResponse(response))
        .catchError((error) => print(error));


  }
  _handleResponse(response){

    if(response.statusCode==200){
      print("OK");
    }

  }

  _loadPlane() async {
    _getPlane();
  }
  _getPlane() async {
    String result ="";
    List<PlanRoute> tmpListPlan;
    try {
      /*String jsonString = await _loadJsonAsset('assets/planRoute.json');
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      tmpListPlan = _generatePlan(jsonResponse);*/

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/magicRoute"));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["route"]);
        tmpListPlan = _generatePlan(jsonResponse["route"]);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the function. Exception: $exception';
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
  Future<String> _loadJsonAsset(jsonLoad) async{
    return await rootBundle.loadString(jsonLoad);
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(child: _buildPlan(), onRefresh: _refresh),
    );
  }
}
