//import 'package:roadini/util/person_header.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_view/figure_joint_type.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polygon.dart';
import 'package:map_view/polyline.dart';
import 'package:roadini/main.dart';
import 'package:roadini/models/app_location.dart';
import 'package:roadini/models/local.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class UploadPage extends StatefulWidget{

  _UploadPage createState() => _UploadPage();

}
class _UploadPage extends State<UploadPage>{

  File file;
  bool prompted = false;
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new StaticMapProvider(API_KEY);
  Uri staticMapUri;
  List<Local> listPlaces;


  @override
  void initState() {
    super.initState();
    _load();
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
  _dialogOptions() async {
    prompted = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return new SimpleDialog(
            title: const Text("Post and Track"),
            children: <Widget>[
              /*new SimpleDialogOption(
                child: const Text("Add Place to personal lists"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    file = imageFile;
                  });
                },

              ),
              new SimpleDialogOption(
                child: const Text("Marker this place"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    file = imageFile;
                  });
                },

              ),*/
              new SimpleDialogOption(
                child: const Text("Add new feed post"),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    file = imageFile;
                  });
                },
              ),
              new SimpleDialogOption(
                child: const Text("Discover Monument"),
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
    print("_GETPLACES");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*String jsonString = await _loadJsonAsset();
      var jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);

      listPosts = _generateFeed(jsonResponse);*/

      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse("http://engserv-1-aulas.ws.atnog.av.it.pt/nearPlaces"));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        var jsonResponse = jsonDecode(json);
        print(jsonResponse["listPlaces"]);
        listPlacesTmp = _generateList(jsonResponse["listPlaces"]);
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
          return new ListView(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /*new Container(
                height: 250.0,
                child: //showMap(),
                new Stack(
                  children: <Widget>[
                    new Center(
                        child:
                        new Container(
                          child: new Text(
                            "You are supposed to see a map here.\n\nAPI Key is not valid.\n\n"
                                "To view maps in the example application set the "
                                "API_KEY variable in example/lib/main.dart. "
                                "\n\nIf you have set an API Key but you still see this text "
                                "make sure you have enabled all of the correct APIs "
                                "in the Google API Console. See README for more detail.",
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.all(20.0),
                        )),
                    new InkWell(
                      child: new Center(
                        child: new Image.network(staticMapUri.toString()),
                      ),
                    )
                  ],
                ),
              ),*/
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    child: new Column(
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {_dialogOptions();},
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
          );

        });
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

//Marker bubble
  /*
  List<Marker> _markers = <Marker>[
    new Marker(
      "1",
      "Something fragile!",
      45.52480841512737,
      -122.66201455146073,
      color: Colors.blue,
      draggable: true, //Allows the user to move the marker.
      markerIcon: new MarkerIcon(
        "images/flower_vase.png",
        width: 112.0,
        height: 75.0,
      ),
    ),
  ];*/

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

  //Drawing
  List<Polygon> _polygons = <Polygon>[
    new Polygon(
        "111",
        <Location>[
          new Location(45.5231233, -122.6733130),
          new Location(45.5231195, -122.6706147),
          new Location(45.5231120, -122.6677823),
          new Location(45.5230894, -122.6670957),
          new Location(45.5230518, -122.6660979),
          new Location(45.5230518, -122.6655185),
          new Location(45.5232849, -122.6652074),
          new Location(45.5230443, -122.6649070),
          new Location(45.5230443, -122.6644135),
          new Location(45.5230518, -122.6639414),
          new Location(45.5231195, -122.6638663),
          new Location(45.5231947, -122.6638770),
          new Location(45.5233074, -122.6639950),
          new Location(45.5232698, -122.6643813),
          new Location(45.5235480, -122.6644349),
          new Location(45.5244349, -122.6645529),
          new Location(45.5245928, -122.6639628),
          new Location(45.5248108, -122.6632762),
          new Location(45.5249385, -122.6626861),
          new Location(45.5249310, -122.6622677),
          new Location(45.5250212, -122.6621926),
          new Location(45.5251490, -122.6621711),
          new Location(45.5251791, -122.6623106),
          new Location(45.5252242, -122.6625681),
          new Location(45.5251791, -122.6632118),
          new Location(45.5249010, -122.6640165),
          new Location(45.5247431, -122.6646388),
          new Location(45.5249611, -122.6646602),
          new Location(45.5253820, -122.6642525),
          new Location(45.5260811, -122.6642525),
          new Location(45.5260435, -122.6637161),
          new Location(45.5261713, -122.6635551),
          new Location(45.5263066, -122.6634800),
          new Location(45.5265471, -122.6635873),
          new Location(45.5269003, -122.6639628),
          new Location(45.5270356, -122.6642632),
          new Location(45.5271484, -122.6646602),
          new Location(45.5274866, -122.6649177),
          new Location(45.5271258, -122.6651645),
          new Location(45.5269605, -122.6653790),
          new Location(45.5267049, -122.6654434),
          new Location(45.5262990, -122.6657224),
          new Location(45.5261337, -122.6666021),
          new Location(45.5256677, -122.6678467),
          new Location(45.5245777, -122.6687801),
          new Location(45.5236908, -122.6690161),
          new Location(45.5233751, -122.6692307),
          new Location(45.5233826, -122.6714945),
          new Location(45.5233337, -122.6729804),
          new Location(45.5233225, -122.6732969),
          new Location(45.5232398, -122.6733506),
          new Location(45.5231233, -122.6733130),
        ],
        jointType: FigureJointType.bevel,
        strokeWidth: 5.0,
        strokeColor: Colors.red,
        fillColor: Color.fromARGB(75, 255, 0, 0)),
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
