import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roadini/models/card_feed_routes.dart';
import 'package:roadini/models/personal_lists.dart';
import 'package:roadini/models/profile_fields.dart';
import 'package:roadini/util/profile_column.dart';
import 'package:roadini/models/user_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget{

  const ProfilePage({this.userId});
  final int userId;
  _ProfilePage createState() => new _ProfilePage(this.userId);

}
class _ProfilePage extends State<ProfilePage> {
  final int id;
  _ProfilePage(this.id);

  String view ="routes"; //default is routes or change to places
  List<CardFeedRoutes> cardFeedRoutes;
  List<PersonalLists> personalListPlaces;



  _getUser() async{
   String result;
   ProfileFields user;
   try {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final container = AppUserContainer.of(context);
     int id = container.getUser().userId;

     var httpClient = new HttpClient();
     var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/ownLists/" + id.toString()));
     var response = await request.close();
     if (response.statusCode == HttpStatus.ok) {
       String json = await response.transform(utf8.decoder).join();
       var jsonResponse = jsonDecode(json);
       print(jsonResponse);
       user = ProfileFields.fromVars(container.getUser().name, 0, id, 0, id, container.getUser().description, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx-RKT_MyU2F4V6i3z2TIZ2Y_VNP3u7tkrPJvpQH5kFuj5-7XEiQ");
     } else {
       result =
       'Error getting a feed:\nHttp status ${response.statusCode}';
     }
   } catch (exception) {
     result = 'Failed invoking the getFeed function. Exception: $exception';
   }


   print(result);
   return user;
  }
  @override
  Widget build(BuildContext context) {
    final container = AppUserContainer.of(context);
    return new FutureBuilder(
        future: _getUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());

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
                          backgroundImage: new NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx-RKT_MyU2F4V6i3z2TIZ2Y_VNP3u7tkrPJvpQH5kFuj5-7XEiQ"),
                        ),
                        new Expanded(
                            flex:1,
                            child: new Column(
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    ProfileColumn("countrys", container.getUser().userId),
                                    ProfileColumn("followers", snapshot.data.followers),
                                    ProfileColumn("following", snapshot.data.following),

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
                          container.getUser().name,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(43, 65, 65, 1.0)
                          ),

                        )),
                    new Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 1.0),
                      child: new Text(
                        container.getUser().description,
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
          );});
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
          PersonalLists(),
        ],
      );
    }


  }

  Future<String> _loadJsonAsset(jsonLoad) async{
    return await rootBundle.loadString(jsonLoad);
  }
}
void openProfile(BuildContext context, int userId){
  Navigator.of(context)
      .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
    return new ProfilePage(userId: userId);
  }));
}
