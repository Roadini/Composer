import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:roadini/models/feed_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roadini/models/user_app.dart';


class FeedPage extends StatefulWidget{
  _FeedPage createState() => new _FeedPage();
}

class _FeedPage extends State<FeedPage>{

  List<FeedPost> listFeed;
  @override
  void initState(){
    super.initState();
    _loadFeed();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(child: buildFeed(), onRefresh: _refresh) ,
    );
  }

  Future<Null> _refresh() async{

    await _getFeed() ;

    setState(() {

    });
    return;
  }

  buildFeed(){
    if(listFeed != null) {
      return new ListView(children: <Widget>[
        new AppBar(title: Center(
            child: Text("Feed",
              style: new TextStyle(
                color: Color.fromRGBO(43, 65, 65, 1.0),
              ),)
        ),
          backgroundColor: Colors.white,),          new Column(
          children: listFeed,
        )]);
    }else{
      return new Container(
          alignment: FractionalOffset.center,
          child: new CircularProgressIndicator());
    }

  }

  _loadFeed() async{
    _getFeed();
  }
  _getFeed() async {

    String result;
    List<FeedPost> listPosts;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*String jsonString = await _loadJsonAsset();
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      listPosts = _generateFeed(jsonResponse);*/

      final container = AppUserContainer.of(context);
      int personalId = container.getUser().userId;

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/feed/" + personalId.toString()));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["feed"]);
        listPosts = _generateFeed(jsonResponse["feed"]);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);
    setState(() {
      listFeed = listPosts;

    });
  }
  List<FeedPost> _generateFeed(List feedJson){
    List<FeedPost> listPosts = [];
    for(var postData in feedJson){
      listPosts.add(new FeedPost.fromJSON(postData));
    }
    return listPosts;

  }
}
