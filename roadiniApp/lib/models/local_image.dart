import 'package:flutter/material.dart';

class LocalImage {


  const LocalImage(
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

  factory LocalImage.fromJSON(Map parsedJson){
    return new LocalImage(
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
