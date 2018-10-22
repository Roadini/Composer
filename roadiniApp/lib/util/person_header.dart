import 'package:flutter/material.dart';

class PersonHeader extends StatefulWidget{

  _PersonHeader createState() => new _PersonHeader();
  const PersonHeader(
      { this.username,
        this.location,
        this.description,
        this.ownerId,
        this.urlImage});

  final String username;
  final String location;
  final String description;
  final String ownerId;
  final String urlImage;
}
class _PersonHeader extends State<PersonHeader>{

  final String username;
  final String location;
  final String  description;
  final String ownerId;
  final String urlImage;

  _PersonHeader({
    this.username,
    this.location,
    this.description,
    this.ownerId,
    this.urlImage,});

  @override
  Widget build(BuildContext context) {

    return new Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_ImageHeader(),
        Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            child: Text('@ Aveiro',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(43, 65, 65, 1.0)
              ) ,
            )
        )],
      ),);
  }

}
class _ImageHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 40.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/photo.jpg'))
      ),
    );
  }
}
