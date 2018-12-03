import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:roadini/models/user_app.dart';

class PersonalLists extends StatefulWidget{
  final int userId;
  const PersonalLists({this.userId});


  _PersonalLists createState() => new _PersonalLists(this.userId);

}
class _PersonalLists extends State<PersonalLists> {
  final int userId;
  _PersonalLists(this.userId);

  List<ListFields> listShow;
  var _listShow;
  TextEditingController _listName;
  List<int>itemSelected = [];

  @override
  initState(){
    _listName = new TextEditingController();
    listShow = new List();
    _listShow = _getOwnLists();
    super.initState();
  }

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
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/ownLists/" + this.userId.toString()));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["result"]);
        feed = _generateListFields(jsonResponse["result"]);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    listShow.addAll(feed);
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
            future: _listShow,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return new Container(
                    alignment: FractionalOffset.center,
                    child: new CircularProgressIndicator());

              List<Widget> list = new List<Widget>();
              for (var i = 0; i < listShow.length; i++) {
                if(itemSelected.indexOf(listShow[i].listId)!= -1){
                  list.add(
                      new Column(children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.all(2.0),
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
                                          Text(listShow[i].listName,
                                            style: new TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold),),
                                          Icon(Icons.arrow_drop_down, color: Colors.yellow,)
                                        ],
                                      ),
                                      onPressed: () {
                                        _toggleSelectItem(listShow[i].listId);
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
                            children: _placeImages(listShow[i].listItem)
                        )
                      ],)
                  );
                }
                else{
                  list.add(
                      new Column(children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.all(2.0),
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
                                          Text(listShow[i].listName,
                                            style: new TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold),),
                                          Icon(Icons.arrow_right, color: Colors.yellow,)
                                        ],
                                      ),
                                      onPressed: () {
                                        _toggleSelectItem(listShow[i].listId);
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

              final container = AppUserContainer.of(context);
              int id = container.getUser().userId;
              if(this.userId == id) {
                return new Column(children: <Widget>[
                  new Column(
                    children: list,
                  ),
                  new Container(

                    child: new RawMaterialButton(
                      onPressed: () {
                        _dialogOptions();
                      },
                      child: new Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Color.fromRGBO(43, 65, 65, 1.0),
                      padding: const EdgeInsets.all(10.0),
                    ),
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                  )

                ]);
              }else{

                return new Column(children: <Widget>[
                  new Column(
                    children: list,
                  ),
                ]);

              }

            }
        )
      ],
    );
  }

  _dialogOptions() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("New List"),
            content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                    hintText: 'eg. Restaurants in Averio'),
                controller: _listName,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              print(_listName.text);
              _createNewList(_listName.text);
              _listName.text = "";
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
          );
        }

    );
  }
  _createNewList(String name) async{

    String result;
    ListFields newList;

    try {
      var data = {'name': name};
      print(data.toString());
      http.Response response = await http.post("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/createList", body:data);
      print(response);
      var json_response = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        if(json_response["status"] == false){
          print("erro, try again");
        }else{
          var r = json_response["result"];
          newList = ListFields(r["list_name"], null, r["user_id"],r["id"]);
          print("add list");
          listShow.add(newList);
        }
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);
    setState(() {
    });


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
  int userId;
  List<ItemField> listItem;
  bool isSelected = false;

  ListFields(listName, listItem, userId, listId){
    this.listName = listName;
    this.listId = listId;
    this.userId = userId;
    if(listItem != null)
      this.listItem = listItem;
    else
      this.listItem = new List();
    this.isSelected = false;
  }

  factory ListFields.fromJSON(Map parsedJson){
    List<ItemField> tmp = [];
    if(parsedJson['listItem'] == null){
      tmp = new List();
    }
    else {
      for (var postData in parsedJson['listItem']) {
        ItemField tmpItem = new ItemField.fromJSON(postData);
        tmp.add(tmpItem);
      }
    }

    return new ListFields(
      parsedJson['listName'],
      tmp,
      parsedJson['userId'],
      parsedJson['listId'],
    );
  }
}

class ItemField{

  ItemField.empty();

  ItemField(name, location, description, postId, listId, urlImage, stars) {
    this.name = name;
    this.location = location;
    this.description = description;
    this.postId = postId;
    this.listId = listId;
    this.urlImage = urlImage;
    this.stars = stars;
  }

  String name;
  String location;
  String description;
  int postId;
  int listId;
  String urlImage;
  int stars;

  factory ItemField.fromJSON(Map parsedJson){
    String name = parsedJson['name'];
    String location = parsedJson['location'];
    int postId = parsedJson['postId'];
    int listId = parsedJson['listId'];
    String description;
    if(parsedJson['description'] == null){
      description = ".";
    }else{
      description = parsedJson['description'];
    }
    String urlImage = parsedJson['urlImage'];
    print(urlImage);
    int stars = parsedJson['stars'];
    return new ItemField( name, location, description, postId, listId, urlImage, stars);
  }

}
