import 'package:flutter/material.dart';

class CardFeedRoutes extends StatefulWidget{


  const CardFeedRoutes(
      { this.username,
        this.location,
        this.description,
        this.postId,
        this.ownerId,
        this.urlImage

      });

  final String username;
  final String location;
  final String description;
  final String postId;
  final String ownerId;
  final String urlImage;

  _CardFeedRoutes createState() => new _CardFeedRoutes(

    username : this.username,
    location : this.location,
    description : this.description,
    postId : this.postId,
    ownerId : this.ownerId,
    urlImage : this.urlImage,
  );

}
class _CardFeedRoutes extends State<CardFeedRoutes>{

  final String username;
  final String location;
  final String description;
  final String postId;
  final String ownerId;
  final String urlImage;

  _CardFeedRoutes(
      { this.username,
        this.location,
        this.description,
        this.postId,
        this.ownerId,
        this.urlImage});


  @override
  Widget build(BuildContext context) {
    return new Card(
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
                          child: new Text("@ Croacia",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(43, 65, 65, 1.0),
                            ),
                          ),
                          height: 40.0,
                        ),
                        new Container(
                          child: new Text("Description",
                            style: new TextStyle(),
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
                            image: new AssetImage('assets/route.jpeg'),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: new Text(
                      "10 stars",
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
            ],

          )
          ,)
    );
  }

}
