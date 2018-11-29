import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polyline.dart';
import 'package:roadini/main.dart';
import 'package:roadini/models/app_location.dart';
import 'package:roadini/models/local.dart';
import 'package:roadini/models/local_image.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';



class UploadPage extends StatefulWidget{

  _UploadPage createState() => _UploadPage();

}
class _UploadPage extends State<UploadPage>{

  bool prompted = false;
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new StaticMapProvider(API_KEY);
  Uri staticMapUri;
  List<Local> listPlaces;
  List<LocalImage> listPlacesImage;
  TextEditingController _review;


  @override
  void initState() {
    super.initState();
    _load();
    _review = new TextEditingController();
    /*if(prompted == false){
      _dialogOptions();
      setState(() {
        prompted = true;
      });

    }*/
  }
  _load() async{

    _getPlacesNear();

  }
  initPlatformState(container){
    cameraPosition = new CameraPosition(container.getStartLocation(), 16.0);
    List<Marker> m = container.getMarkers();
    staticMapUri = staticMapProvider.getStaticUriWithMarkersAndZoom(m,zoomLevel : 16, width : 900,
        height: 400, maptype: StaticMapViewType.roadmap, center: container.getStartLocation());
    setState(() {
    });
  }
  _dialogOptions(context2) async {
    prompted = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return new SimpleDialog(
            title: const Text("Post and Track"),
            children: <Widget>[
              new SimpleDialogOption(
                child: const Text("Add new feed post"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 500, maxWidth: 500, );
                  newPage(imageFile, context2);
                },
              ),
              new SimpleDialogOption(
                child: const Text("Discover Monument"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                },
              )
            ],
          );


        }

    );


  }
  _buttonTracking(container){
    if(!container.getTracking()){
      return new Container(
        child: new Column(
          children: <Widget>[
            new RawMaterialButton(
              onPressed: () {container.toggle();},
              child: new Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 25.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Color.fromRGBO(43, 65, 65, 1.0),
              padding: const EdgeInsets.all(10.0),
            ),
            new Text("Start/Stop Tracking", style:new TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),);}
    else{
      return new Container(
        child: new Column(
          children: <Widget>[
            new RawMaterialButton(
              onPressed: () {container.toggle();},
              child: new Icon(
                Icons.pause_circle_outline,
                color: Colors.white,
                size: 25.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Color.fromRGBO(43, 65, 65, 1.0),
              padding: const EdgeInsets.all(10.0),
            ),
            new Text("Start/Stop Tracking", style:new TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),);
    }

  }
  Future<Null> _refresh() async{

    await _getPlacesNear() ;

    setState(() {

    });
    return;
  }

  getPlacesNear(){
    if(listPlaces != null) {
      return new Column( children: listPlaces);
    }else{
      return new Column(
        children: <Widget>[
          new Text("Searching Places", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          new Container(
              alignment: FractionalOffset.center,
              child: new CircularProgressIndicator())
        ],
      );
    }
  }
  _getPlacesNear() async{

    String result;
    List<Local> listPlacesTmp;
    List<LocalImage> listPlacesTmp2;
    print("_GETPLACES");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*String jsonString = await _loadJsonAsset();
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      listPosts = _generateFeed(jsonResponse);*/

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/nearPlaces"));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["listPlaces"]);
        listPlacesTmp = _generateList(jsonResponse["listPlaces"]);
        listPlacesTmp2 = _generateList2(jsonResponse["listPlaces"]);
      } else {
        result =
        'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the near places function. Exception: $exception';
    }
    print("PASSOU ");
    print(result);
    setState(() {
      listPlacesImage = listPlacesTmp2;
      listPlaces = listPlacesTmp;

    });
  }
  List<Local> _generateList(List feedJson) {
    List<Local> listPosts = [];
    for (var postData in feedJson) {
      listPosts.add(new Local.fromJSON(postData));
    }
    return listPosts;
  }
  List<LocalImage> _generateList2(List feedJson) {
    List<LocalImage> listPosts = [];
    for (var postData in feedJson) {
      listPosts.add(new LocalImage.fromJSON(postData));
    }
    return listPosts;
  }

  @override
  Widget build(BuildContext context){
    final container = AppLocationContainer.of(context);
    initPlatformState(container);
    return new FutureBuilder(
        future: container.getFuture(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());
          return new Scaffold(
            appBar: AppBar(title: Center(
                child: Text("RoadIni",
                  style: new TextStyle(
                    color: Color.fromRGBO(43, 65, 65, 1.0),
                  ),)
              ),
              backgroundColor: Colors.white,),

          body : new ListView(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    child: new Column(
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {_dialogOptions(context);},
                          child: new Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 2.0,
                          fillColor: Color.fromRGBO(43, 65, 65, 1.0),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        new Text("Camera", style:new TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),),
                  _buttonTracking(container),
                  new Container(
                    child: new Column(
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {showMap(container);},
                          child: new Icon(
                            Icons.map,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 2.0,
                          fillColor: Color.fromRGBO(43, 65, 65, 1.0),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        new Text("View Map", style:new TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),),
                ],),
              new RefreshIndicator(child: getPlacesNear(), onRefresh: _refresh),
            ],
          ),
          );

        });
  }

  // ##################################################################################
  //         New View to post image all functions under this comment
  // ##################################################################################

  _dialogOptions2(localImage, contextIndex, file){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new SimpleDialog(
            children: <Widget>[
              new SimpleDialogOption(
                  child: const Text("Add Place to personal lists"),
                  onPressed: () async {
                    await _getLists(localImage, contextIndex, context , file);
                  }

              ),
            ],
          );
        }

    );
  }
  _getLists(localImage, contextIndex, contextDialog, file) async{

    String result;
    Map<int,String> lists = new Map();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int user_id = 1;
      String url = "http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/listName/" + user_id.toString();
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
    Navigator.pop(contextDialog);
    _dialogOptionsList(lists, contextIndex, localImage, file);
  }
  _handleResponse(response, contextDialog, contextIndex){
    if(response.statusCode==200){
      var jsonResponse = jsonDecode(response.data);
      if(jsonResponse["status"]==true){
        Navigator.pop(contextDialog);
        Navigator.pop(contextIndex);
      }
    }

  }
  _addItemToList(int key, String value, contextDialog, contextIndex, localImage, File file) async{
    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add("photos", new UploadFileInfo(file, "fileUpload.jpeg"));
    formdata.add('listId' ,key.toString());
    formdata.add('userId' ,1.toString());
    formdata.add('itemId' ,localImage.id.toString());
    formdata.add('review' ,_review.text);
    dio.post("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/postImage", data: formdata, options: Options(
        method: 'POST',
        responseType: ResponseType.PLAIN // or ResponseType.JSON
    ))
        .then((response) => _handleResponse(response, contextDialog, contextIndex))
        .catchError((error) => print(error));
  }
  _options(lists, contextDialog, contextIndex, localImage, file){
    List<Widget> options = new List();
    print(lists.length);
    for(var l in lists.entries){
      print(l);
      options.add( new SimpleDialogOption(
          child: Text(l.value),
          onPressed: () {_addItemToList(l.key, l.value, contextDialog, contextIndex, localImage, file);}
      ));
    }
    print(options);
    return options;

  }
  _dialogOptionsList(Map<int, String>lists, contextIndex, localImage, file){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextDialog) {
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
                children: _options(lists, contextDialog, contextIndex, localImage, file),
              )
            ],
          );
        }
    );

  }
  _iterateOverListPlacesPhoto(context2, file){
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < listPlacesImage.length; i++){
      list.add(new GestureDetector(
        onTap: (){_dialogOptions2(listPlacesImage[i], context2, file);},
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
                  child: listPlacesImage[i].buildIcon(listPlacesImage[i].primaryType),
                ),
                title: Text(
                  listPlacesImage[i].name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle:
                Text(listPlacesImage[i].address, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)
                ,)
          ),
        ),
      ),
      );

    }
    return list;


  }
  newPage(file, context){
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context2) {
      return new Center(
          child: new Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Center(
                      child: Text("Roadini")
                  )
              ),
              body:new ListView(
                  children: <Widget>[
                    new Container(
                      height: 300.0,
                      //width: 250.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: FileImage(file))
                      ),
                    ),
                    new Column(
                      children: _iterateOverListPlacesPhoto(context2, file),
                    )
                  ]
              )
          )
      );
    })
    );
  }

  showMap(container) {
    var last = container.getLocation();

    Polyline route = new Polyline(
        "route",
        container.getLocations(),
        width: 10.0,
        color: Colors.red);

    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            showCompassButton: true,
            initialCameraPosition: new CameraPosition(last, 16.0),
            hideToolbar: false,
            title: "Your Route"),
        toolbarActions: [new ToolbarAction("Close", 1)]);
    StreamSubscription sub = mapView.onMapReady.listen((_) {
      print("ESTA READY");
      mapView.setMarkers(container.getMarkers());
      mapView.addPolyline(route);
      //mapView.setPolygons(_polygons);
    });
    /*
    compositeSubscription.add(sub);
    sub = mapView.onLocationUpdated.listen((location) {
      cameraPosition = new CameraPosition( new Location(location.latitude, location.longitude), 12.0);
      print("Location updated $location");
    });
    compositeSubscription.add(sub);
    sub = mapView.onTouchAnnotation
        .listen((annotation) => print("annotation ${annotation.id} tapped"));
    compositeSubscription.add(sub);
    */
    sub = mapView.onTouchPolyline
        .listen((polyline) => print("polyline ${polyline.id} tapped"));
    compositeSubscription.add(sub);
    /*
    sub = mapView.onTouchPolygon
        .listen((polygon) => print("polygon ${polygon.id} tapped"));
    compositeSubscription.add(sub);
    sub = mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub);
    //sub = mapView.onMapLongTapped
        //.listen((location) => print("Long tapped location $location"));
    //compositeSubscription.add(sub);
    sub = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    compositeSubscription.add(sub);
    */
    sub = mapView.onToolbarAction.listen((id) {
      print("Toolbar button id = $id");
      if (id == 1) {
        sub.cancel();
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);
    sub = mapView.onInfoWindowTapped.listen((marker) {
      print("Info Window Tapped for ${marker.title}");
    });
    compositeSubscription.add(sub);
    //sub = mapView.onIndoorBuildingActivated.listen(
    //(indoorBuilding) => print("Activated indoor building $indoorBuilding"));
    //compositeSubscription.add(sub);
    //sub = mapView.onIndoorLevelActivated.listen(
    //(indoorLevel) => print("Activated indoor level $indoorLevel"));
    //compositeSubscription.add(sub);
  }
  _handleDismiss() async {
    double zoomLevel = await mapView.zoomLevel;
    Location centerLocation = await mapView.centerLocation;
    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
    List<Polyline> visibleLines = await mapView.visiblePolyLines;
    //List<Polygon> visiblePolygons = await mapView.visiblePolygons;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
    print("Visible Polylines Count: ${visibleLines.length}");
    //print("Visible Polygons Count: ${visiblePolygons.length}");
    var uri = await staticMapProvider.getImageUriFromMap(mapView,
        width: 900, height: 400);
    setState(() => staticMapUri = uri);
    mapView.dismiss();
    compositeSubscription.cancel();
  }
/*
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
  }*/


  //Line
  List<Polyline> _lines = <Polyline>[
    new Polyline(
        "11",
        <Location>[
          new Location(40.6313108, -8.6598865),
          new Location(44.6313200, -8.6598865),
        ],
        width: 15.0,
        color: Colors.red),
  ];
}
class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}
