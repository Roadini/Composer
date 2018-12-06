import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:roadini/models/profile_fields.dart';
import 'package:roadini/models/user_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roadini/pages/profile_page.dart';

class SearchPage extends StatefulWidget {
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  //Future<QuerySnapshot> userDocs;
  List<ProfileFields>userDocs ;

  @override
  initState(){
    super.initState();
  }

  buildSearchField() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Form(
        child: new TextFormField(
          decoration: new InputDecoration(labelText: 'Search for a user...'),
          onFieldSubmitted: submit,
        ),
      ),
    );
  }

  ListView buildSearchResults(userDocs) {
    List<UserSearchItem> userSearchItems = [];

    userDocs.forEach((ProfileFields userX) {
      UserSearch user = new UserSearch(userX.name, userX.id, userX.description, userX.urlImage);
      UserSearchItem searchItem = new UserSearchItem(user);
      userSearchItems.add(searchItem);
    });

    return new ListView(
      children: userSearchItems,
    );
  }

  void submit(String searchValue) async {
    String result;
    ProfileFields user;
    List<ProfileFields> list = new List();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final container = AppUserContainer.of(context);
      int id = container.getUser().userId;

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/search/" + id.toString() + "/" + searchValue));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse);
        for(var x in jsonResponse["allUsers"]){
          List<int> followers = new List();
          List<int> following = new List();
          for(var l in x["followers"]){
            followers.add(l["id"]);
          }
          for(var l in x["following"]){
            following.add(l["id"]);
          }
          user = ProfileFields.fromVars(x["name"], followers, x["id"], following, x["id"], x["description"], x["image"]);
          print(user.toString());
          list.add(user);

        }
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }


    print("RESULT");
    print(result);
    print(list.length);

    setState(() {
      userDocs = list;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: buildSearchField(),
        body: userDocs == null
            ? new Text("")
            : buildSearchResults(userDocs)
    );
  }
}

class UserSearchItem extends StatelessWidget {
  final UserSearch user;

  const UserSearchItem(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return new GestureDetector(
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundImage: new NetworkImage(user.urlImage),
            backgroundColor: Colors.grey,
          ),
          title: new Text(user.name, style: boldStyle),
          subtitle: new Text(user.description),
        ),
        onTap: () {
          openProfile(context, user.userId);
        });
  }
}
class UserSearch{

  String name;
  int userId;
  String description;
  String urlImage;

  UserSearch(String name, int userId,  String description, String urlImage) {
    this.name=name;
    this.userId=userId;
    this.description = description;
    this.urlImage = urlImage;

  }


}