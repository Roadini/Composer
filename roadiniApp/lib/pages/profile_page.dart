import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roadini/models/card_feed_routes.dart';
import 'package:roadini/models/personal_lists.dart';
import 'package:roadini/models/profile_fields.dart';
import 'package:roadini/util/profile_column.dart';

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
     String jsonString = await _loadJsonAsset('assets/profile.json');
     var jsonResponse = jsonDecode(jsonString);
     print(jsonResponse);

     user = new ProfileFields.fromJSON(jsonResponse);

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
   return user;
  }
  @override
  Widget build(BuildContext context) {
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
                                    ProfileColumn("countrys", snapshot.data.numberCountries),
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
                          snapshot.data.name,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(43, 65, 65, 1.0)
                          ),

                        )),
                    new Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 1.0),
                      child: new Text(
                        snapshot.data.description,
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
