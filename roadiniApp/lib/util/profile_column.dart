import 'package:flutter/material.dart';

class ProfileColumn extends StatefulWidget{
  const ProfileColumn(this.label, this.number);
  final String label;
  final int number;

  _ProfileColumn createState() => new _ProfileColumn(this.label, this.number);


}
class _ProfileColumn extends State<ProfileColumn>{
  final String label;
  final int number;
  _ProfileColumn(this.label, this.number);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          number.toString(),
          style: new TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(43, 65, 65, 1.0),
          ),
        ),
        new Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: new Text(
              label,
              style: new TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
            ))
      ],
    );
  }
}

