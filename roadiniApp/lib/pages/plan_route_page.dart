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
import 'package:roadini/pages/edit_page.dart';





class PlanRoutePage extends StatefulWidget{
  _PlanRoutePage createState() => _PlanRoutePage();
}
class _PlanRoutePage extends State<PlanRoutePage>{

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


  _getChoices(BuildContext context, element) async{
    editElement = element;

    PlanRoute choice = await Navigator.of(context)
        .push(new MaterialPageRoute<PlanRoute>(builder: (BuildContext context) {
      return new Edit(placeId:editElement.placeId, categoryName: editElement.categoryName,);
    }));
    if(choice != null) {
      listPlan[listPlan.indexOf(editElement)] = choice;
    }

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

  _buildPlan(){
    if(listPlan != null){
      return new ListView(
        children: <Widget>[
          new AppBar(title: Center(
              child: Text("Sugested Route",
                style: new TextStyle(
                  color: Color.fromRGBO(43, 65, 65, 1.0),
                ),)
          ),
            backgroundColor: Colors.white,),
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
        new AppBar(title: Center(
                child: Text("Sugested Route",
                  style: new TextStyle(
                    color: Color.fromRGBO(43, 65, 65, 1.0),
                  ),)
              ),
              backgroundColor: Colors.white,),
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

      container.addMarker(p.lng, p.lat, p.placeName);

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
    await new Future.delayed(const Duration(seconds: 2)); //recommend
    _getPlane();
  }
  _getPlane() async {
    String result ="";
    List<PlanRoute> tmpListPlan;
    final container = AppLocationContainer.of(context);
    String lat = container.getStartLocation().latitude.toString();
    String lng = container.getStartLocation().longitude.toString();

    final container2 = AppUserContainer.of(context);
    String user_id = container2.getUser().userId.toString();
    try {


      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/magicRoute/"+user_id+"/"+lat+"/"+lng ));
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

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(child: _buildPlan(), onRefresh: _refresh),
    );
  }
}
