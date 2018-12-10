import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:roadini/models/plan_route.dart';
import 'package:roadini/models/app_location.dart';

class Edit extends StatefulWidget {
  final String placeId;
  final String categoryName;


  const Edit({Key key, this.placeId, this.categoryName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditState();
  }


}

class EditState extends State<Edit> {
  List<PlanRoute> listChoices;
  bool firstTime;

  @override
  void initState() {
    super.initState();
    print("init state edit");
    firstTime = false;
  }
  @override
  Widget build(BuildContext context) {
    if(firstTime == false){
      _getListCategory();
      firstTime = true;
    }
    return new Center(
      child: new Scaffold(

        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Center (child:new Text(
            "Change Place",
            style: const TextStyle(color: Color.fromRGBO(43, 65, 65, 1.0)),
          ),
          ),
          backgroundColor: Colors.white,
        ),
        body: new RefreshIndicator(child: _clickedElementEdit(), onRefresh: _refresh2),
      ),
    );;
  }
  _clickedElementEdit() {
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
                      child: Text("Select a new " + widget.categoryName,
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
            new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator()
            )
          ]
      );
    }
  }
  _getListCategory ()async{
    print("ENTROU NO CHANGE");
    List<PlanRoute> tmpListCategory;
    String result;

    final container = AppLocationContainer.of(context);
    String lat = container.getLocation().latitude.toString();
    String lng = container.getLocation().longitude.toString();
    try {


      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/changeMagic/"+lat+"/"+lng+"/"+widget.placeId ));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["route"]);
        tmpListCategory = _generatePlan(jsonResponse["route"]);
      } else {
        result =
        'Error getting a :\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the function. Exception: $exception';
    }
    print(result);

    setState(() {
      print("ENTROU");
      print(tmpListCategory[0].urlImage);
      _clickedElementEdit();
      listChoices= tmpListCategory;
    });


  }
  Future<Null> _refresh2() async{

    await _getListCategory() ;

    setState(() {

    });
    return;
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
  _handleChoice(PlanRoute choice){
    Navigator.of(context).pop(choice);
  }
  List<PlanRoute> _generatePlan(List planJson){
    List<PlanRoute> listPlans = [];
    for(var planData in planJson){
      listPlans.add(new PlanRoute.fromJSON(planData));
    }
    return listPlans;

  }

}