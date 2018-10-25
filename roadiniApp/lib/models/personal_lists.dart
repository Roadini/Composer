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
  _toggleSelectItem(String listId){
    if(itemListSelected == false){
      setState(() {
        itemListSelected = true;
      });
      print(listId);

    }else{
      setState(() {
        itemListSelected = false;
      });
    }

  }

  Column _buildView(){
    if(itemListSelected == true){
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
          PlaceImages()
        ],
      );

    }
    else{

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
          new Container(
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
}
class PlaceImages extends StatefulWidget{

  _PlaceImages createState() => new _PlaceImages();

}
class _PlaceImages extends State<PlaceImages>{
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
                  child: Image.network("https://media-cdn.tripadvisor.com/media/photo-s/0a/a5/5a/1c/enchanting-views-of-the.jpg"),
                ),
              ],
            )),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 3,childAspectRatio: 1.0,
      padding: const EdgeInsets.all(0.5),
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network("https://media-cdn.tripadvisor.com/media/photo-s/0a/a5/5a/1c/enchanting-views-of-the.jpg", fit: BoxFit.cover)
        ),

        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network("https://i.pinimg.com/originals/af/a7/69/afa7690e09c86f4ff00cd214d3ef3f5b.jpg", fit: BoxFit.cover)
        ),
        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network("https://media-cdn.tripadvisor.com/media/photo-s/0a/a5/5a/1c/enchanting-views-of-the.jpg", fit: BoxFit.cover)
        ),
        new GestureDetector(
            onTap: () => clickedImage(context),
            child: new Image.network("https://i.pinimg.com/originals/af/a7/69/afa7690e09c86f4ff00cd214d3ef3f5b.jpg", fit: BoxFit.cover)
        ),
      ],
    );
  }

}
