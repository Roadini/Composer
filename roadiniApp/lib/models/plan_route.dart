import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget{
  const PlanRoute(
      { this.categoryName,
        this.categoryId,
        this.placeName,
        this.placeId,
        this.placeDescription,
        this.urlImage});

  final String categoryName;
  final String categoryId;
  final String placeName;
  final String placeId;
  final String placeDescription;
  final String urlImage;

  factory PlanRoute.fromJSON(Map parsedJson){
    return new PlanRoute(
      categoryName: parsedJson['categoriaName'],
      categoryId: parsedJson['categoryId'],
      placeName: parsedJson['placeName'],
      placeId: parsedJson['placeId'],
      placeDescription: parsedJson['placeDescription'],
      urlImage : parsedJson['urlImage'],
    );
  }

  _PlanRoute createState() => _PlanRoute(
    categoryName : this.categoryName,
    categoryId : this.categoryId,
    placeName: this.placeName,
    placeId: this.placeId,
    placeDescription: this.placeDescription,
    urlImage: this.urlImage,
  );
}
class _PlanRoute extends State<PlanRoute>{

  final String categoryName;
  final String categoryId;
  final String placeName;
  final String placeId;
  final String placeDescription;
  final String urlImage;

  _PlanRoute(
      { this.categoryName,
        this.categoryId,
        this.placeName,
        this.placeId,
        this.placeDescription,
        this.urlImage});

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Align(
                  alignment: Alignment.centerLeft,
                  child: new Padding(padding: new EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                    child : new Text("Categoria name",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize:20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(90, 113, 113, 1.0),
                      ),
                    ),
                  )),
              new Align(
                alignment: Alignment.centerRight,
                child : new Container(
                  child: Row(children: <Widget>[
                    new Padding(padding: new EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 0.0),
                      child: new GestureDetector(
                        child: const Icon(
                          Icons.edit,
                          size: 25.0,
                          color: Color.fromRGBO(90, 113, 113, 1.0),
                        ),),
                    ),
                    new Padding(padding: new EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 0.0),
                      child : new GestureDetector(
                        child: const Icon(
                          Icons.delete_forever,
                          size: 25.0,
                          color: Color.fromRGBO(90, 113, 113, 1.0),
                        ),),)

                  ],),
                ),
              ),
            ],),
          Divider(),
          new Text("Barba Azul",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize:20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(90, 113, 113, 1.0),
            ),
          ),
          _ImageCard(),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text('Situado na Praia da Barra, o O Barba Azul apresenta um ambiente jovem, luminoso e descontraído, na avenida em frente ao farol da Barra. Fundado em 2015.',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: new TextStyle(
                    color: Colors.black87
                  ),
                )
              ],
            ),
          ),


        ],),);

  }



}

class _ImageCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Center(
      child : new Container(
        width: 250.0,
        height: 200.0,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('http://bebespontocomes.pt/wp-content/uploads/2016/08/quadrada-mesa-restaurante-sushi-barba-azul-praia-barra-aveiro-bebespontocomes.jpg'))
        ),
      ),
    );

  }

}
