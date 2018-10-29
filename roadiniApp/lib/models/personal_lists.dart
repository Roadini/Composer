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

  List<int>itemSelected = [];

  _PersonalLists({ this.listName,
    this.description,
    this.listId});


  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _buildView(),
    );
  }

  _toggleSelectItem(id) {
    if(itemSelected.indexOf(id) == -1){
      itemSelected.add(id);
    }else{
      itemSelected.remove(id);
    }
    setState(() {

    });
  }

  _getOwnLists() async{
    String result;
    List<ListFields> feed;

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
    return feed;

  }
  Column _buildView() {

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
        new FutureBuilder(
            future: _getOwnLists(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return new Container(
                    alignment: FractionalOffset.center,
                    child: new CircularProgressIndicator());

              List<Widget> list = new List<Widget>();
              for (var i = 0; i < snapshot.data.length; i++) {
                if(itemSelected.indexOf(snapshot.data[i].listId)!= -1){
                  list.add(
                      new Column(children: <Widget>[
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
                                          Text(snapshot.data[i].listName,
                                            style: new TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold),),
                                          Icon(Icons.arrow_drop_down, color: Colors.yellow,)
                                        ],
                                      ),
                                      onPressed: () {
                                        _toggleSelectItem(snapshot.data[i].listId);
                                      }
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            padding: const EdgeInsets.all(0.5),
                            mainAxisSpacing: 1.5,
                            crossAxisSpacing: 1.5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _placeImages(snapshot.data[i].listItem)
                        )
                      ],)
                  );
                }
                else{
                  list.add(
                      new Column(children: <Widget>[
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
                                          Text(snapshot.data[i].listName,
                                            style: new TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold),),
                                          Icon(Icons.arrow_right, color: Colors.yellow,)
                                        ],
                                      ),
                                      onPressed: () {
                                        _toggleSelectItem(snapshot.data[i].listId);
                                      }
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],)
                  );

                }
              }
              return new Column(children: list);

            }
        )
      ],
    );
  }

  _placeImages(listItems) {
    List<Widget> listImages = [];
    for(var i = 0; i <listItems.length;  i++){
      listImages.add(
          new GestureDetector(
              onTap: () => _clickedImage(context, listItems[i]),
              child: new Image.network(
                  listItems[i].urlImage,
                  fit: BoxFit.cover)
          )
      );
    }
    return listImages;
  }

  _clickedImage(BuildContext context, item) {
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Center(
        child: new Scaffold(
            appBar: new AppBar(
                automaticallyImplyLeading: false,
                title: Center(child: new Text(item.name))
            ),
            body: new ListView(
              children: <Widget>[
                new Container(
                  child: Image.network(
                      item.urlImage),
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

  String listName;
  int listId;
  String listDescription;
  List<ItemField> listItem;
  bool isSelected = false;

  ListFields(listName, listItem, listDescription, listId){

    this.listName = listName;
    this.listId = listId;
    this.listDescription = listDescription;
    this.listItem = listItem;
    this.isSelected = false;

  }

  factory ListFields.fromJSON(Map parsedJson){
    List<ItemField> tmp = [];
    for(var postData in parsedJson['listItem']){
      ItemField tmpItem = new ItemField.fromJSON(postData);
      tmp.add(tmpItem);
    }

    return new ListFields(
      parsedJson['listName'],
      tmp,
      parsedJson['listDescription'],
      parsedJson['listId'],
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
