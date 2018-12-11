import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';


class AppUser{
  String name;
  int userId;
  String email;
  int age;
  String description;
  String gender;

  AppUser(String name, int userId, String email, int age, String description, String male) {
    this.name=name;
    this.userId=userId;
    this.email = email;
    this.age = age;
    this.description = description;
    this.gender = gender;

  }


}

class AppUserContainer extends StatefulWidget {
  // Your apps state is managed by the container
  final AppUser user;
  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppUserContainer({
    @required this.child,
    this.user,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppUserContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedUserContainer)
    as _InheritedUserContainer).data;
  }

  @override
  _AppUserContainerState createState() => new _AppUserContainerState();
}

class _AppUserContainerState extends State<AppUserContainer> {
  // Just padding the state through so we don't have to
  // manipulate it with widget.state.
  AppUser user;
  IOWebSocketChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void create(String name, int userId, String email, int age, String description, String male, String cookie){
    if(user == null) {
      user = new AppUser(name, userId, email, age, description, male);
      try{
        this.channel = new IOWebSocketChannel.connect("ws://engserv1-aulas.ws.atnog.av.it.pt/ws");

        this.channel.stream.listen(
            _onReceptionOfMessageFromServer,
            onError: (error, StackTrace stackTrace){
              print("WS ERROR");
              print(error);
              // error handling
            },
            onDone: (){
              // communication has been closed
              print("WS CLOSE");
              print("FECHOU");
            }
        );
        startWebSocket(cookie);
      } catch(e){
        print("BIG ERRO");
        print(e);

      }
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings( initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    }
  }
  Future onSelectNotification(String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: Text("PayLoad"),
            content: Text("Payload : $payload"),
          );
        },
      );
  }

  Future showNotificationWithDefaultSound(String type, String message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      type,
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  _onReceptionOfMessageFromServer(message){
    var json = jsonDecode(message);


    if(json["Data"]["server"]=="follow you"){
      String msg = json["Data"]["token"] + " started to follow you!";
      showNotificationWithDefaultSound("New Follower", msg);
    }
    else{
      print("MESSAGE DIFFERENT");
      showNotificationWithDefaultSound("Type", "MESSAGE");

    }
    print(message);

  }
  void startWebSocket(String cookie){
    var login = '{ "Type": "login", "Data": { "token": "'+cookie+'", "server": "172.22.0.2" } }';
    channel.sink.add(login);

  }

  AppUser getUser(){
    if(user == null) {
      return null;
    }
    else{
      return this.user;
    }
  }


  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedUserContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedUserContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppUserContainerState data;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  _InheritedUserContainer({
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
  bool updateShouldNotify(_InheritedUserContainer old) => true;
}
