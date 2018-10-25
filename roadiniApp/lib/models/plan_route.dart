import 'package:flutter/material.dart';

class PlanRoute {
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
      categoryName: parsedJson['categoryName'],
      categoryId: parsedJson['categoryId'],
      placeName: parsedJson['placeName'],
      placeId: parsedJson['placeId'],
      placeDescription: parsedJson['placeDescription'],
      urlImage : parsedJson['urlImage'],
    );
  }

  imageCard(){
    return new Center(
      child : new Container(
        width: 250.0,
        height: 200.0,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(this.urlImage))
        ),
      ),
    );
  }
}

