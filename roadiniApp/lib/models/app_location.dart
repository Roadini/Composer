import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as l;
import 'package:map_view/map_view.dart';
//import 'package:permission_handler/permission_handler.dart';

class AppLocation{
  bool tracking;
  l.Location _location;
  StreamSubscription<Map<String, double>> _locationSubscription;
  List<Location> locations;
  List<Marker> markers;
  var _future;
  Map<String, double> _currentLocation;
  Map<String, double> _startLocation;

  AppLocation() {
    _location = new l.Location();
    locations = new List();
    markers = new List();
    tracking = false;
    _currentLocation = new Map();
    _startLocation = new Map();
  }


}

class AppLocationContainer extends StatefulWidget {
  // Your apps state is managed by the container
  final AppLocation state;
  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppLocationContainer({
    @required this.child,
    this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppLocationContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedLocationContainer)
            as _InheritedLocationContainer)
        .data;
  }

  @override
  _AppLocationContainerState createState() => new _AppLocationContainerState();
}

class _AppLocationContainerState extends State<AppLocationContainer> {
  // Just padding the state through so we don't have to
  // manipulate it with widget.state.
  AppLocation state;

  getPermission(_location) async{
    /*Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location, PermissionGroup.locationWhenInUse, PermissionGroup.locationAlways]);
    permissions.forEach((k,v) => (){
      print(k);
      print(v);

    });*/


  }

  void create(){
    if(state == null) {
      print("MERDA");
      state = new AppLocation();
    }
  }
  void toggle(){
    setState(() {
      state.tracking = !state.tracking;
    });
  }
  List<Location> getLocations(){
    return state.locations;
  }

  List<Marker> getMarkers(){
    print(state.markers);
    return state.markers;
  }

  Location getLocation(){
    return state.locations.last;
  }

  bool getTracking(){
    return state.tracking;
  }

  getFuture() async{
    return state._future;
  }

  Location getStartLocation(){
    return new Location(state._startLocation["latitude"], state._startLocation["longitude"]);
  }

  Marker getFirstMark(){
    return state.markers.first;
  }

  addMarker(double lng, double lat, String name){
    Marker m = new Marker("0", name, lng, lat);
    state.markers.add(m);
    print(state.markers.length);
    setState(() {
    });
  }

  start() async{
    print("ENTROU NO START");
    if(state._future == null) {
      state._future = await initPlatformState();
      await startStream();
    }
  }


  initPlatformState() async {
    var permission = await getPermission(this.state._location);
    print(permission);

    Map<String, double> location;

    String error;
    bool _permission = false;
    try {
      _permission = await state._location.hasPermission();
      location = await state._location.getLocation();


      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    state._startLocation = location;
    state.locations.add(new Location(state._startLocation["latitude"], state._startLocation["longitude"]));
    //cameraPosition = new CameraPosition(new Location(_startLocation["latitude"], _startLocation["longitude"]), 16.0);
    Marker m = new Marker("0", "Starting Point", state._startLocation["latitude"],state._startLocation["longitude"]);
    state.markers.add(m);
    print("INIT");
    return location;
  }
  startStream() async{
    state._locationSubscription =
        state._location.onLocationChanged().listen((Map<String,double> result) {
          if(state.tracking) {
            print(result);
            state._currentLocation = result;
            state.locations.add(new Location(state._currentLocation["latitude"], state._currentLocation["longitude"]));
            print(state.locations.length);
            if (state.locations.length == 20) {
              print("new POST to server and save trancking");
            }
          }
          else{
            print("is paused");
          }
        });
  }


  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedLocationContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedLocationContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppLocationContainerState data;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  _InheritedLocationContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a better way to do this, which you'll see later.
  // But basically, Flutter automatically calls this method when any data
  // in this widget is changed.
  // You can use this method to make sure that flutter actually should
  // repaint the tree, or do nothing.
  // It helps with performance.
  @override
  bool updateShouldNotify(_InheritedLocationContainer old) => true;
}
