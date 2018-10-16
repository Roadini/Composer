import 'package:flutter/material.dart';
import 'package:roadini/util/person_header.dart';
import 'package:roadini/models/plan_route.dart';

class PlanRoutePage extends StatefulWidget{
  _PlanRoutePage createState() => _PlanRoutePage();
}
class _PlanRoutePage extends State<PlanRoutePage>{
  List<PlanRoute> listPlan;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        body: new ListView(children: <Widget>[
          PersonHeader(),
          PlanRoute(),
          PlanRoute(),
          new Column(children: <Widget>[
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
          ],),
        ],)
    );
  }

}

