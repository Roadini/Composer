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
          appBar: AppBar(title: Center(child: Text("RoadIni"))),
          body: new RefreshIndicator(child: clickedImage(), onRefresh: _refresh2),
        ),
      );
    }));

  }
  clickedImage() {
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
  _getListCategory ()async{
    print(editElement.categoryId + " fazer pedido desta categoria");
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
      String jsonString = await _loadJsonAsset('assets/planRoute.json');
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
/*class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}*/
