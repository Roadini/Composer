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
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatefulWidget{

  const ProfilePage({this.userId});
  final int userId;
  _ProfilePage createState() => new _ProfilePage(this.userId);

}
class _ProfilePage extends State<ProfilePage> {
  final int id;
  _ProfilePage(this.id);
  ProfileFields userProfile;

  String view ="routes"; //default is routes or change to places
  List<CardFeedRoutes> cardFeedRoutes;
  List<PersonalLists> personalListPlaces;

  bool isFollowing = false;
  bool followButtonClicked = false;


  _getUser(id) async{
    String result;
    ProfileFields user;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final container = AppUserContainer.of(context);
      int personalId = container.getUser().userId;

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/userInfo/" +personalId.toString() +"/" +id.toString()));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse);
        List<int> followers = new List();
        List<int> following = new List();
        for(var l in jsonResponse["followers"]){
          followers.add(l["id"]);
        }
        for(var l in jsonResponse["following"]){
          following.add(l["id"]);
        }
        user = ProfileFields.fromVars(jsonResponse["name"], followers, id, following, id, jsonResponse["description"], jsonResponse["urlImage"]);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }


    print("RETURN");
    return user;
  }

  logout() async{

    String result;
    try {

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/logout/" + this.id.toString()));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse);
        if(jsonResponse["status"]==true){
          exit(0);
        }
      } else {
        result = 'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }

  }

  followUser() async {
    print('following user');
    String result;
    final container = AppUserContainer.of(context);
    int personalId = container.getUser().userId;
    try {

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/follow/" +personalId.toString() +"/" +id.toString()));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }

    var message = '{ "Type": "publish", "Data": { "to": "'+id.toString()+'", "text": "follow you" } }';
    container.channel.sink.add(message);
    setState(() {
      this.isFollowing = true;
      this.followButtonClicked = true;
      this.userProfile.followers.add(this.id);
      print(this.userProfile.followers.length);

    });
  }

  unFollowUser() async{
    print('unfollowing user');
    String result;
    try {
      final container = AppUserContainer.of(context);
      int personalId = container.getUser().userId;

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/unfollow/" +personalId.toString() +"/" +id.toString()));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    setState(() {
      this.userProfile.followers.remove(this.id);
      this.isFollowing = false;
      this.followButtonClicked = true;

    });
  }


  @override
  Widget build(BuildContext context) {

    final container = AppUserContainer.of(context);
    int personalId = container.getUser().userId;

    //FOLLOW BUTTON
    Container buildFollowButton(
        {String text,
          Color backGroundColor,
          Color textColor,
          Color borderColor,
          Function function}) {
      return new Container(
        padding: const EdgeInsets.only(top: 2.0),
        child: new FlatButton(
            onPressed: function,
            child: new Container(
              decoration: new BoxDecoration(
                  color: backGroundColor,
                  border: new Border.all(color: borderColor),
                  borderRadius: new BorderRadius.circular(5.0)),
              alignment: Alignment.center,
              child: new Text(text,
                  style: new TextStyle(
                      color: textColor, fontWeight: FontWeight.bold)),
              width: 200.0,
              height: 27.0,
            )),
      );
    }

    //OPTION FOR BUTTON FOLLOW
    Container buildProfileFollowButton(ProfileFields user) {
      // viewing your own profile - should show edit button
      if (user.id == personalId) {
        return buildFollowButton(
          text: "Logout",
          backGroundColor: Colors.grey,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: logout,
        );
      }

      // already following user - should show unfollow button
      if (isFollowing) {
        return buildFollowButton(
          text: "Unfollow",
          backGroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: unFollowUser,
        );
      }

      // does not follow user - should show follow button
      if (!isFollowing) {
        return buildFollowButton(
          text: "Follow",
          backGroundColor: Color.fromRGBO(90, 113, 113, 1.0),
          textColor: Colors.white,
          borderColor: Color.fromRGBO(90, 113, 113, 1.0),
          function: followUser,
        );
      }

      return buildFollowButton(
          text: "loading...",
          backGroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey);
    }
    _handleResponse(response, context){

      if(response.statusCode == 200) {

        Navigator.of(context).pop();
        setState(() {
        });
      }
    }

    _dialogOptions(File file){
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text("Do you wanna update your photo"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    final container = AppUserContainer.of(context);
                    Dio dio = new Dio();
                    FormData formdata = new FormData(); // just like JS
                    formdata.add("photos", new UploadFileInfo(file, "fileUpload.jpeg"));
                    formdata.add('userId' ,container.getUser().userId.toString());
                    dio.post("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/editImage", data: formdata, options: Options(
                        method: 'POST',
                        responseType: ResponseType.PLAIN // or ResponseType.JSON
                    ))
                        .then((response) => _handleResponse(response, context))
                        .catchError((error) => print(error));
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }

      );
    }
    //final container = AppUserContainer.of(context);
    return new FutureBuilder(
        future: _getUser(this.id),
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());
          }
          userProfile = snapshot.data;


          if (userProfile.followers.contains(personalId) &&
              followButtonClicked == false) {
            isFollowing = true;
          }

          return new Scaffold(

              appBar: new AppBar(
                automaticallyImplyLeading: false,
                title: new Center(child: new Text(
                userProfile.name,
                style: const TextStyle(color: Colors.black),
              ),),
                backgroundColor: Colors.white,
              ),


              body:new ListView(
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
                              backgroundImage: new NetworkImage(userProfile.urlImage),
                              child: InkWell(
                                onTap: ()async{
                                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 500, maxWidth: 500, );
                                  _dialogOptions(imageFile);
                                  print("TAPPED");
                                },
                              ),

                            ),
                            new Expanded(
                                flex:1,
                                child: new Column(
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        ProfileColumn("countrys", userProfile.id),
                                        ProfileColumn("followers", userProfile.followers.length),
                                        ProfileColumn("following", userProfile.following.length),

                                      ],
                                    ),
                                    new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          buildProfileFollowButton(userProfile)
                                        ]
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                        new Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 15.0),
                            child: new Text(
                              userProfile.name,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(43, 65, 65, 1.0)
                              ),

                            )),
                        new Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1.0),
                          child: new Text(
                            userProfile.description,
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
                  buildView(userProfile.id),
                ],
              )
          );
        });
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

  Column buildView(userId){

    if(view == "routes") {
      return new Column(
        //children: cardFeedRoutes,
        children: <Widget>[CardFeedRoutes()],
      );
    }else{
      return new Column(
        children: <Widget>[
          PersonalLists(userId:userId),
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

