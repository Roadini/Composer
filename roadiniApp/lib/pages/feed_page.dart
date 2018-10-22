import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roadini/models/feed_post.dart';
import 'package:roadini/util/person_header.dart';


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
          PersonHeader(),
          new Column(
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
      String jsonString = await _loadJsonAsset();
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      listPosts = _generateFeed(jsonResponse);

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
  Future<String> _loadJsonAsset() async{
    return await rootBundle.loadString('assets/feed.json');
  }


}
