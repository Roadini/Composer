import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as l;
import 'package:map_view/map_view.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:simple_permissions/simple_permissions.dart';


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
  bool isPermissionCoarse = false;
  bool isPermissionFine = false;
  bool isPermissionAlways = false;
  bool isPermissionInUse = false;

  getPermission(_location) async{
    String finish = await updatePermission();
    print(finish);

  }
  updatePermission() async {
    Permission permissionCoarse = Permission.AccessCoarseLocation;
    Permission permissionFine = Permission.AccessFineLocation;
    Permission permissionAlways = Permission.AlwaysLocation;
    Permission permissionWhenInUse = Permission.WhenInUseLocation;
    print("ETROU AQUI permission");



    if (await SimplePermissions.checkPermission(permissionFine)) {
      isPermissionFine = true;
      print("Pos a true");
    } else {
      print("REQUEST FINE");
      await SimplePermissions.requestPermission(permissionFine);
      print("Disse que sim");
      if (await SimplePermissions.checkPermission(permissionFine)) {
        isPermissionFine = true;

      } else {
        isPermissionFine = false;
      }
    }

    if (await SimplePermissions.checkPermission(permissionCoarse)) {
      isPermissionCoarse = true;
      print("Pos a true");
    } else {
      print("REQUEST COARSE");
      await SimplePermissions.requestPermission(permissionCoarse);
      print("Disse que sim");
      if (await SimplePermissions.checkPermission(permissionCoarse)) {
        isPermissionCoarse = true;

      } else {
        isPermissionCoarse = false;
      }
    }

    if (await SimplePermissions.checkPermission(permissionAlways)) {
      isPermissionAlways = true;
      print("Pos a true");
    } else {
      if (await SimplePermissions.requestPermission(permissionAlways)==true) {
        isPermissionAlways = true;

      } else {
        isPermissionAlways = false;
      }
    }

    if (await SimplePermissions.checkPermission(permissionWhenInUse)) {
      isPermissionInUse = true;
      print("Pos a true");
    } else {
      if (await SimplePermissions.requestPermission(permissionWhenInUse)==true) {
        isPermissionInUse = true;

      } else {
        isPermissionInUse = false;
      }
    }
    print("Bluetooth coarse location granted???  $isPermissionCoarse");
    print("Bluetooth fine location granted???  $isPermissionFine");
    print("Bluetooth always location granted???  $isPermissionAlways");
    print("Bluetooth in use location granted???  $isPermissionInUse");
    return "finish";
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
    print("ADD MARKER");
    print(lng);
    Marker m = new Marker("0", name, lat, lng);
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
    print("INIT PLATFORM");
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

      print("DENIE PERMISSION????");
      print(e);
      print(e.code);
      print(error);
      print(_permission);

      location = null;
    }

    print("INIT");
    state._startLocation = location;
    if(location != null){

      state.locations.add(new Location(state._startLocation["latitude"], state._startLocation["longitude"]));
      Marker m = new Marker("0", "Starting Point", state._startLocation["latitude"],state._startLocation["longitude"]);
      state.markers.add(m);

    }
    return location;
  }
  startStream() async{
    state._locationSubscription =
        state._location.onLocationChanged().listen((Map<String,double> result) {
          if(state._startLocation == null){
            state._startLocation = result;
            state.locations.add(new Location(state._startLocation["latitude"], state._startLocation["longitude"]));
            Marker m = new Marker("0", "Starting Point", state._startLocation["latitude"],state._startLocation["longitude"]);
            state.markers.add(m);
          }
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
