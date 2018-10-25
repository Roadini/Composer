import 'package:flutter/material.dart';
import 'package:roadini/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:roadini/util/person_header.dart';


class UploadPage extends StatefulWidget{

  _UploadPage createState() => _UploadPage();

}
class _UploadPage extends State<UploadPage>{

  File file;
  bool prompted = false;

  @override
  void initState() {
    /*if(prompted == false){
      _dialogOptions();
      setState(() {
        prompted = true;
      });

    }*/
    super.initState();
  }
  _dialogOptions() async {
    prompted = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return new SimpleDialog(
            title: const Text("Post and Track"),
            children: <Widget>[
              new SimpleDialogOption(
                child: const Text("Add Post"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    file = imageFile;
                  });
                },

              ),
              new SimpleDialogOption(
                child: const Text("Discover Place"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    file = imageFile;
                  });
                },

              )
            ],
          );


        }

    );


  }

  @override
  Widget build(BuildContext context) {
    if(file == null && prompted == false) {
      Future.delayed(Duration.zero, ()=> _dialogOptions());
    }
    return file == null
        ? new Column(children: <Widget>[
      new PersonHeader(),
      new IconButton(icon: new Icon(Icons.file_upload), onPressed: _dialogOptions),

    ],)
        : new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new ListView(children: <Widget>[
        new Card(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PersonHeader(),
              Divider(),
              new Center(
                child : new Container(
                  height: 300.0,
                  width: 250.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: FileImage(file))
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Center(
                      child: new Text('Photo Title',
                        style: TextStyle(fontSize: 20.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: new Text('Situado na Praia da Barra, o O Barba Azul apresenta um ambiente jovem, luminoso e descontraído, na avenida em frente ao farol da Barra. Fundado em 2015.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,) ,
                    ),
                  ],
                ),
              ),


            ],),)
      ],),
    );
  }
}

