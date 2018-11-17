import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class CardFeedRoutes extends StatefulWidget{

  const CardFeedRoutes({this.userId});
  final int userId;
  _CardFeedRoutes createState() => new _CardFeedRoutes(this.userId);
}
class _CardFeedRoutes extends State<CardFeedRoutes>{

  final int id;
  _CardFeedRoutes(this.id);

  _getOwnFeed() async{
    String result;
    List<FeedRoutes> feed;

    try {
      /*String jsonString = await _loadJsonAsset('assets/personalTrips.json');
      var jsonResponse = jsonDecode(jsonString);

      feed = _generateFeedRoutes(jsonResponse);*/

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/personalTrips"));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["trips"]);
        feed = _generateFeedRoutes(jsonResponse["trips"]);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    return feed;

  }
  _clickedItem(context, element){
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Center(
          child: new Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Center(child: Text(element.location))),
              body:new ListView(
                  children: <Widget>[
                    /*new Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                              child: Text(element.location,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(43, 65, 65, 1.0)
                                ) ,
                              )
                          )],
                      ),),*/
                    new Container(
                        child: Image.network(element.urlImage)
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0),
                      child: new Text(element.description),
                    ),
                    new Row(
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: new Text(
                            element.stars.toString() + " stars",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(43, 65, 65, 1.0),
                            ),

                          ),
                        )
                      ],
                    ),


                  ]
              )
          )
      );
    })
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: _getOwnFeed(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());

          List<Widget> list = new List<Widget>();
          for (var i = 0; i < snapshot.data.length; i++) {

            list.add(
                new Card(
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
                                      child: new Text(snapshot.data[i].location,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(43, 65, 65, 1.0),
                                        ),
                                      ),
                                      height: 40.0,
                                    ),
                                    new Container(
                                      child: new Text(snapshot.data[i].description,
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
                                  padding: new EdgeInsets.fromLTRB(
                                      160.0, 80.0, 0.0, 80.0),
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        image: new NetworkImage(snapshot.data[i].urlImage),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Align(
                            alignment: Alignment.centerLeft,
                            child: new Container(
                              child : new Row(
                                children: <Widget>[
                                  new Padding(
                                      padding: EdgeInsets.only(left: 0.0),
                                      child: new GestureDetector(
                                        child: const Icon(
                                          Icons.remove_red_eye,
                                          size: 25.0,
                                          color: Color.fromRGBO(43, 65, 65, 1.0),
                                        ),
                                        onTap: () => _clickedItem(context, snapshot.data[i]),

                                      )
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: new Text(
                                      snapshot.data[i].stars.toString() + " stars",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(43, 65, 65, 1.0),
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    )
                )
            );
          }
          return new Column(children: list);
        }
    );
  }

  List<FeedRoutes> _generateFeedRoutes(List feedJson){
    List<FeedRoutes> listRoutes = [];
    for(var postData in feedJson){
      listRoutes.add(new FeedRoutes.fromJSON(postData));
    }
    return listRoutes;

  }

  Future<String> _loadJsonAsset(jsonLoad) async{
    return await rootBundle.loadString(jsonLoad);
  }

}

class FeedRoutes{

  const FeedRoutes(
      { this.name,
        this.location,
        this.description,
        this.postId,
        this.ownerId,
        this.urlImage,
        this.stars
      });

  final String name;
  final String location;
  final String description;
  final int postId;
  final int ownerId;
  final String urlImage;
  final int stars;

  factory FeedRoutes.fromJSON(Map parsedJson){
    return new FeedRoutes(
      name: parsedJson['name'],
      location: parsedJson['location'],
      postId: parsedJson['postId'],
      ownerId: parsedJson['ownerId'],
      description: parsedJson['description'],
      urlImage : parsedJson['urlImage'],
      stars: parsedJson['stars'],
    );
  }

}
