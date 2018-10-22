import 'package:flutter/material.dart';

class FeedPost extends StatefulWidget{


  const FeedPost(
      { this.username,
        this.location,
        this.description,
        this.postId,
        this.ownerId,
        this.urlImage});

  final String username;
  final String location;
  final String description;
  final String postId;
  final String ownerId;
  final String urlImage;

  factory FeedPost.fromJSON(Map parsedJson){
    return new FeedPost(
      username: parsedJson['username'],
      location: parsedJson['location'],
      description : parsedJson['description'],
      postId : parsedJson['postId'],
      ownerId : parsedJson['ownerId'],
      urlImage : parsedJson['urlImage'],
    );
  }

  _FeedPost createState() => new _FeedPost(

    username : this.username,
    location : this.location,
    description : this.description,
    postId : this.postId,
    ownerId : this.ownerId,
    urlImage : this.urlImage,

  );

}
class _FeedPost extends State<FeedPost>{

  final String username;
  final String location;
  final String description;
  final String postId;
  final String ownerId;
  final String urlImage;

  _FeedPost(
      { this.username,
        this.location,
        this.description,
        this.postId,
        this.ownerId,
        this.urlImage});

  bool stared = false;
  int starsCount = 0;

  GestureDetector starIconClick(){
    Color color;
    IconData icon;

    if(stared){
      color = Colors.yellow;
      icon = Icons.star;
    }else{
      color = Color.fromRGBO(43, 65, 65, 1.0);
      icon = Icons.star_border;
    }
    return new GestureDetector(
        child: new Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          //_staredPost(postId);
          _staredPost();
        });

  }
  void _staredPost(){
    setState(() {
      stared = stared ? false:true;
      if(stared == true)
        starsCount++;
    });

  }
  TextStyle boldStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
     return new Column(

        children: <Widget>[
        new Column( children: <Widget> [
          new Divider(),
          //new Divider(color: Color.fromRGBO(58, 66, 86, 1.0),),
          new Row(
            children: <Widget>[
              new Center(
                child : new Container(
                  width: 35.0,
                  height: 30.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('$urlImage'))
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                  child: Column( children: <Widget>[
                    Text('$username',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(43, 65, 65, 1.0),
                      ),
                    ),
                    Text('@ $location',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(43, 65, 65, 1.0),
                      ),
                    )
                  ],)
              )
            ],
          ),
          new Column(children: <Widget>[
            new Container(
              padding: EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text('$description',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,)
                ],
              ),
            ),
            new Container(
              constraints: new BoxConstraints.expand(
                height: 200.0,
              ),
              padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/route.jpeg'),
                    fit: BoxFit.cover
                ),
              ),
              /*child: new Stack(
            children: <Widget>[
              new Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: new Icon(Icons.star_border)

            ],
          ),*/
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
                starIconClick(),
                new Padding(padding: const EdgeInsets.only(right: 20.0)),
                new GestureDetector(
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    size: 25.0,
                    color: Color.fromRGBO(43, 65, 65, 1.0),
                  ),
                  /*onTap: () {
                  goToComments(
                      context: context,
                      postId: postId,
                      ownerId: ownerId,
                      mediaUrl: mediaUrl);
                }*/),
              ],
            ),
            //TODO linha de baixo /comentarios e cor de fundo
            new Row(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: new Text(
                    "$starsCount stars",
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

          ],)
        ]),
        ],);
  }
}
