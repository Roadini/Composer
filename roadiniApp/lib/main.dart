import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:roadini/pages/feed_page.dart';
import 'package:roadini/pages/plan_route_page.dart';
import 'package:roadini/pages/profile_page.dart';
import 'package:roadini/pages/upload_page.dart';
import 'models/app_location.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:roadini/pages/login_page.dart';
import 'package:roadini/models/user_app.dart';

void main(){
  MapView.setApiKey(API_KEY);
  runApp(new AppUserContainer(child: new AppLocationContainer(child:new MyApp())));

}
const API_KEY = ('AIzaSyAKzTjJcIZKZDs2-ZD3B1njQl2mN3Tu5l8');

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final container = AppLocationContainer.of(context);
    container.create();
    container.start();
    return new MaterialApp(
        title: 'RoadIni',
        theme: new ThemeData(          // Add the 3 lines from here...
          primaryColor: Color.fromRGBO(43, 65, 65, 1.0),
          //primaryColor: Colors.redAccent,
          fontFamily: 'Roboto',

        ),
        home: new MainPage()
    );
  }
}
class MainPage extends StatefulWidget{

  @override
  _MainPage createState() => new _MainPage();
}

PageController pageIndex;

class _MainPage extends State<MainPage>{
  int _index = 0;

  @override
  void initState() {
    super.initState();
    pageIndex = new PageController();
  }

  void onLogin() {
    setState(() {
    });
  }
  firstPage(){
    return LoginScreen(onLogin);
  }
  @override
  Widget build(BuildContext context) {
    final container = AppUserContainer.of(context);

    return container.getUser() == null
    ? firstPage() :
    new Scaffold(
      body: new PageView(children: <Widget>[
        FeedPage(),
        PlanRoutePage(),
        UploadPage(),
        ProfilePage(),
      ],
        controller: pageIndex,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new Theme(data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
          canvasColor: Color.fromRGBO(43, 65, 65, 1.0),
          //canvasColor: Color.fromRGBO(58, 66, 86, 1.0),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.yellow,
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: new TextStyle(color: Colors.white))),

        child: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Container()),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.edit_location),
                title: new Container()),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add_circle),
                title: new Container()),
            /*new BottomNavigationBarItem(
                icon: new Icon(Icons.search),
                title: new Container()),*/
            new BottomNavigationBarItem(
                icon: new Icon(Icons.person_outline),
                title: new Container()),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: navBarTapped,
          currentIndex: _index,
        ),),
      appBar: AppBar(title: Center(child: Text("RoadIni"))),
    );
  }
  navBarTapped(int page){
    pageIndex.jumpToPage(page);
  }

  onPageChanged(int page){
    setState(() {
      this._index = page;
    });
  }
  @override
  void dispose() {
    super.dispose();
    pageIndex.dispose();
  }
}
