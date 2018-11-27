import 'package:flutter/material.dart';

class AppUser{
  String name;
  int userId;
  String email;
  String jwt;

  AppUser(String name, int userId, String email, String jwt) {
    this.name=name;
    this.userId=userId;
    this.email = email;
    this.jwt = jwt;
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

  void create(name, id, mail, jwt){
    if(user == null) {
      print("MERDA");
      user = new AppUser(name, id, mail, jwt);
    }
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
