import 'package:flutter/material.dart';
import 'package:roadini/util/profile_column.dart';
import 'package:roadini/models/card_feed_routes.dart';
import 'package:roadini/models/personal_lists.dart';

class ProfilePage extends StatefulWidget{

  const ProfilePage({this.userId});
  final String userId;
  _ProfilePage createState() => new _ProfilePage(this.userId);

}
class _ProfilePage extends State<ProfilePage> {
  final String id;
  String view ="routes"; //default is routes or change to places
  List<CardFeedRoutes> cardFeedRoutes;
  List<PersonalLists> personalListPlaces;
  _ProfilePage(this.id);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new CircleAvatar(
                    radius:40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: new NetworkImage("https://scontent.flis1-1.fna.fbcdn.net/v/t1.0-9/20258438_1893652067570862_4019107659665964412_n.jpg?_nc_cat=111&oh=b69b337a86923445d87ed7b445acd224&oe=5C4F4156"),
                  ),
                  new Expanded(
                      flex:1,
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ProfileColumn("countrys", 5),
                              ProfileColumn("followers", 10),
                              ProfileColumn("following", 12),

                            ],
                          )
                        ],
                      )
                  )
                ],
              ),
              new Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15.0),
                  child: new Text(
                    "Tiago Ramalho",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(43, 65, 65, 1.0)
                    ),

                  )),
              new Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 1.0),
                child: new Text(
                  "Last Visited Country was Croacia, Tiago is from Portugal",
                  style: new TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        buildOptionButtonBar(),
        new Divider(),
        buildView(),
      ],
    ) ;
  }

  Row buildOptionButtonBar(){
    Color isSelectedButton(String viewName){
      if(viewName == view){
        return Colors.yellow;

      }else{
        return Colors.white;


      }
    }
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: <Widget>[
        new RaisedButton(onPressed: (){changeView("routes");},
          splashColor: Colors.yellow,
          color: Color.fromRGBO(90, 113, 113, 1.0),
          child: new Text("Routes",
            style: new TextStyle(
              color: isSelectedButton("routes")
            ),
          ),
        ),
        new ButtonTheme(
          child : new RaisedButton(onPressed: () {changeView("Places");},
            splashColor: Colors.yellow,
            color: Color.fromRGBO(90, 113, 113, 1.0),
            child: new Text("Places",
              style: new TextStyle(
                color: isSelectedButton("Places"),
              ),
            ),
          ),
        )
      ],);
  }
  changeView(String viewName){
    setState(() {
      view = viewName;
    });

  }

  Column buildView(){

    if(view == "routes") {
      return new Column(
        //children: cardFeedRoutes,
        children: <Widget>[CardFeedRoutes()],
      );
    }else{
      return new Column(
        children: <Widget>[
          
          new Center(
              child: new Text("Your list of places:",
                  style: new TextStyle(
                      color: Color.fromRGBO(43, 65, 65, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                  )
              ),
          )
          ,PersonalLists()],
        //children: personalListsPlaces,
      );
    }


  }

}
