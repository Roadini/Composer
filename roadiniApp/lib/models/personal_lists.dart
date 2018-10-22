import 'package:flutter/material.dart';

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

  _PersonalLists({ this.listName,
    this.description,
    this.listId});


  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.all(10.0),
        child : new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ButtonTheme(
              minWidth: 200.0,
              child :Expanded(
                child: new RaisedButton(
                    splashColor: Colors.yellow,
                    color: Color.fromRGBO(90, 113, 113, 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Restaurantes in Croacia",
                          style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        Icon(Icons.arrow_right, color: Colors.yellow,)
                      ],
                    ),
                    onPressed: () {}
                ),
              ),
            ),
          ],
        ),
    );
  }
}
