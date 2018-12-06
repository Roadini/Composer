import 'package:flutter/material.dart';
import 'package:roadini/models/app_location.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roadini/models/user_app.dart';

class Local extends StatefulWidget{


  const Local(
      { this.id,
        this.name,
        this.address,
        this.googleId,
        this.lat,
        this.lng,
        this.primaryType,
        this.secondaryType
      });

  final int id;
  final String name;
  final String address;
  final String googleId;
  final double lat;
  final double lng;
  final String primaryType;
  final String secondaryType;

  factory Local.fromJSON(Map parsedJson){
    return new Local(
      id: parsedJson['id'],
      name: parsedJson['name'],
      address : parsedJson['address'],
      googleId : parsedJson['google_place_id'],
      lat : parsedJson['lat'],
      lng : parsedJson['lng'],
      primaryType : parsedJson['primary_type'],
      secondaryType : parsedJson['secondary_type'],
    );
  }

  _Local createState() => new _Local(
      id:this.id,
      name:this.name,
      address:this.address,
      googleId:this.googleId,
      lat:this.lat,
      lng:this.lng,
      primaryType:this.primaryType,
      secondaryType:this.secondaryType
  );

}
class _Local extends State<Local>{

 final int id;
 final String name;
 final String address;
 final String googleId;
 final double lat;
 final double lng;
 final String primaryType;
 final String secondaryType;

 TextEditingController _review;

  _Local(
      { this.id,
        this.name,
        this.address,
        this.googleId,
        this.lat,
        this.lng,
        this.primaryType,
        this.secondaryType
      });


 @override
 initState(){
   _review = new TextEditingController();
   super.initState();
 }

  TextStyle boldStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

 _dialogOptions(){
   return showDialog(
       context: context,
       barrierDismissible: true,
       builder: (BuildContext context) {
         return new SimpleDialog(
           children: <Widget>[
             new SimpleDialogOption(
                 child: const Text("Add Place to personal lists"),
                 onPressed: () async {
                   await _getLists(context);
                 }

             ),
             new SimpleDialogOption(
               child: const Text("Marker this place"),
               onPressed: () {
                 final container = AppLocationContainer.of(context);
                 container.addMarker(this.lng, this.lat, this.name);
                 Navigator.pop(context);
               },

             ),
           ],
         );
       }

   );
 }
 _getLists(context) async{

   String result;
   Map<int,String> lists = new Map();
   try {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final container = AppUserContainer.of(context);

     String url = "http://engserv1-aulas.ws.atnog.av.it.pt/roadini/listName/" + container.getUser().userId.toString();
     http.Response response = await http.get(url);
     if (response.statusCode == HttpStatus.ok) {
       var jsonResponse = jsonDecode(response.body);
       print(jsonResponse["result"]);
       for(var j in jsonResponse["result"]){
         lists[j["listId"]]=j["listName"];
       }
     } else {
       result =
       'Error getting a feed:\nHttp status ${response.statusCode}';
     }
   } catch (exception) {
     result = 'Failed invoking the getFeed function. Exception: $exception';
   }
   Navigator.pop(context);
   _dialogOptionsList(lists);
 }
 _addItemToList(int key, String value, context2) async{
   String result;

   try {
     final container = AppUserContainer.of(context);
     var data = {'listId': key.toString(), 'userId':container.getUser().userId.toString(), 'itemId':this.id.toString(), 'review':_review.text, 'listName':value};
     _review.text = "";
     http.Response response = await http.post("http://engserv1-aulas.ws.atnog.av.it.pt/roadini/addItem", body:data);
     print(response);
     var json_response = jsonDecode(response.body);
     if (response.statusCode == HttpStatus.ok) {
       if(json_response["status"] == false){
         print("erro, try again");
         //TODO do alert of fail
       }else{
         //TODO do alert of add

       }
     } else {
       result =
       'Error getting a feed:\nHttp status ${response.statusCode}';
     }
   } catch (exception) {
     result = 'Failed invoking the function. Exception: $exception';
   }
   Navigator.pop(context2);
 }
 _options(lists, context2){
   List<Widget> options = new List();
   print(lists.length);
   for(var l in lists.entries){
     print(l);
     options.add( new SimpleDialogOption(
         child: Text(l.value),
         onPressed: () {_addItemToList(l.key, l.value, context2);}
     ));
   }
   print(options);
   return options;

 }
 _dialogOptionsList(Map<int, String>lists){
   return showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context2) {
         return new SimpleDialog(
           children: <Widget>[
             new ListTile(
               title: new Text("Review:", style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
             ),
             new ListTile(
               leading: const Icon(Icons.message, size: 15,),
               title: new TextField(
                 decoration: new InputDecoration(
                   hintText: 'eg. I really liked this restaurant',
                   //enabledBorder: InputBorder.none,

                 ),
                 controller: _review,
                 style: new TextStyle(fontSize: 15, color: Colors.black),
               ),
             ),
             new ListTile(
               title:new Text("Select on of your lists:",
               style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
             ),
             new Column(
               children: _options(lists, context2),
               )
           ],
         );
       }
   );

 }
  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new GestureDetector(
            onTap: (){_dialogOptions();},
            child: new Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(90, 113, 113, 1.0)),
                  child:
                  new ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.0, color: Colors.white24))),
                      child: buildIcon(primaryType),
                    ),
                    title: Text(
                      this.name,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    Text("$address", style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)
                    ,)
                //trailing: buildIcon(primaryType))
              ),
            ),
          ),
          ]
    );}
    buildIcon(type){
    if(type == "restaurant")
      return Icon(Icons.restaurant, color: Colors.white, size: 20.0);
    else if(type == "point_of_interest")
      return Icon(Icons.location_searching, color: Colors.white, size: 20.0);
    else if(type == "locality")
      return Icon(Icons.time_to_leave, color: Colors.white, size: 20.0);
    else
      return Icon(Icons.location_on, color: Colors.white, size: 20.0);
    }
}
