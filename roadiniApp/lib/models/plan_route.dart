import 'package:flutter/material.dart';

class PlanRoute {
  const PlanRoute(
      { this.categoryName,
        this.placeName,
        this.placeId,
        this.lat,
        this.lng,
        this.placeDescription,
        this.urlImage});

  final String categoryName;
  final String placeName;
  final String placeId;
  final double lat;
  final double lng;
  final String placeDescription;
  final String urlImage;

  factory PlanRoute.fromJSON(Map parsedJson){
    return new PlanRoute(
      categoryName: parsedJson['categoryName'],
      placeName: parsedJson['placeName'],
      placeId: parsedJson['placeId'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
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

