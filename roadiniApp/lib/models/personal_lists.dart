import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PersonalLists extends StatefulWidget{
  const PersonalLists(
      { this.listName,
        this.listId,
        this.description,

      });

  final String listName;
  final String description;
  final String listId;

  _PersonalLists createState() => new _PersonalLists(

    listName: this.listName,
    listId: this.listId,
    description: this.description,
  );

}
class _PersonalLists extends State<PersonalLists> {

  final String listName;
  final String description;
  final String listId;
  bool itemListSelected = false;

  _PersonalLists({ this.listName,
    this.description,
    this.listId});


  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _buildView(),
    );
  }

  _toggleSelectItem(String listId) {
    if (itemListSelected == false) {
      setState(() {
        itemListSelected = true;
      });
      print(listId);
    } else {
      setState(() {
        itemListSelected = false;
      });
    }
  }

  _getOwnLists() async{
    String result;
    List<ListFields> feed;
    print("GET OWN LIST");

    try {
      String jsonString = await _loadJsonAsset('assets/listFields.json');
      var jsonResponse = jsonDecode(jsonString);

      feed = _generateListFields(jsonResponse);

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
    print("GET OWN LIST 2 2");
    print(feed[0].listItem[0].listId);
    return feed;

  }
  Column _buildView() {
    if (itemListSelected == true) {
      return new Column(

        children: <Widget>[
          new Center(
            child: new Text("Restaurantes in Croacia",
                style: new TextStyle(
                    color: Color.fromRGBO(43, 65, 65, 1.0),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )
            ),
          ),
          new Container(
            margin: const EdgeInsets.all(10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 200.0,
                  child: Expanded(
                    child: new RaisedButton(
                        splashColor: Colors.yellow,
                        color: Color.fromRGBO(90, 113, 113, 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Restaurantes in Croacia",
                              style: new TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold),),
                            Icon(Icons.arrow_drop_down, color: Colors.yellow,)
                          ],
                        ),
                        onPressed: () {
                          _toggleSelectItem("10");
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
          placeImages()
        ],
      );
    }
    else {
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
          ),
          /*new FutureBuilder(
        future: _getOwnLists(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());


          print(snapshot);
        } )
          ,*/
          new Container(
            margin: const EdgeInsets.all(10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 200.0,
                  child: Expanded(
                    child: new RaisedButton(
                        splashColor: Colors.yellow,
                        color: Color.fromRGBO(90, 113, 113, 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Restaurantes in Croacia",
                              style: new TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold),),
                            Icon(Icons.arrow_right, color: Colors.yellow,)
                          ],
                        ),
                        onPressed: () {
                          _toggleSelectItem("10");
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  placeImages() {
    return new GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(0.5),
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network(
                "https://media-cdn.tripadvisor.com/media/photo-s/0a/a5/5a/1c/enchanting-views-of-the.jpg",
                fit: BoxFit.cover)
        ),

        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network(
                "https://i.pinimg.com/originals/af/a7/69/afa7690e09c86f4ff00cd214d3ef3f5b.jpg",
                fit: BoxFit.cover)
        ),
        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network(
                "https://media.timeout.com/images/102323695/380/285/image.jpg",
                fit: BoxFit.cover)
        ),
      ],
    );
  }

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Center(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('Photo',
                  style: new TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
            ),
            body: new ListView(
              children: <Widget>[
                new Container(
                  child: Image.network(
                      "https://media-cdn.tripadvisor.com/media/photo-s/0a/a5/5a/1c/enchanting-views-of-the.jpg"),
                ),
              ],
            )),
      );
    }));
  }

  List<ListFields> _generateListFields(List feedJson){
    List<ListFields> listFields = [];
    for(var postData in feedJson){
      listFields.add(new ListFields.fromJSON(postData));
    }
    return listFields;

  }

  Future<String> _loadJsonAsset(jsonLoad) async{
    return await rootBundle.loadString(jsonLoad);
  }
}
class ListFields {

  final String listName;
  final int listId;
  final String listDescription;
  final List<ItemField> listItem;

  const ListFields({
    this.listName,
    this.listId,
    this.listDescription,
    this.listItem
  });

  factory ListFields.fromJSON(Map parsedJson){
    List<ItemField> tmp;
    for(var postData in parsedJson['listItem']){
      tmp.add(new ItemField.fromJSON(postData));
    }

    return new ListFields(
      listName: parsedJson['listName'],
      listItem: tmp,
      listDescription: parsedJson['listDescription'],
      listId: parsedJson['listId'],
    );
  }
}

class ItemField{

  const ItemField(
      { this.name,
        this.location,
        this.description,
        this.postId,
        this.listId,
        this.urlImage,
        this.stars
      });

  final String name;
  final String location;
  final String description;
  final int postId;
  final int listId;
  final String urlImage;
  final int stars;

  factory ItemField.fromJSON(Map parsedJson){
    return new ItemField(
      name: parsedJson['name'],
      location: parsedJson['location'],
      postId: parsedJson['postId'],
      listId: parsedJson['listId'],
      description: parsedJson['description'],
      urlImage : parsedJson['urlImage'],
      stars: parsedJson['stars'],
    );
  }

}
