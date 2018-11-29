import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:roadini/models/user_app.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {

  var onLogin;
  LoginScreen(onLogin){
    this.onLogin = onLogin;
  }

  @override
  _LoginScreenState createState() => new _LoginScreenState(onLogin);
}

class _LoginScreenState extends State<LoginScreen> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  var context;
  var onLogin;
  _LoginScreenState(onLogin){
    this.onLogin = onLogin;
  }

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String token;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    print("DISPOSE all");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) async{
          print("onStateChanged: ${state.type} ${state.url}");
          final cookiesString = await flutterWebViewPlugin.evalJavascript("document.cookie");
          print("COOKIE");
          print(cookiesString.runtimeType);
          var cookie = jsonDecode(cookiesString);
          print(cookie.runtimeType);

          if(cookie != "null" && cookie != "" && cookie != null){
            print(cookie);
            await getInfo(cookie);

          }
        });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url)  async{
      if (mounted) {
        setState(() {
          print("URL changed: $url");
            //saveToken(token);
            //Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
        });
      }
    });
  }

  getInfo(cookie) async{

    Dio dio = new Dio();

    FormData formData = new FormData(); // just like JS
    formData.add('cookie' ,cookie);
    dio.post("http://engserv-1-aulas.ws.atnog.av.it.pt/roadini/createUser", data: formData, options: Options(
        method: 'POST',
        responseType: ResponseType.PLAIN // or ResponseType.JSON
    ))
        .then((response) => _handleResponse(response, cookie))
        .catchError((error) => print(error));
    return null;
  }
  _handleResponse(response, String cookie){
    if(response.statusCode==200){
      var jsonResponse = jsonDecode(response.data);
      if(jsonResponse["status"]==true){
        final container = AppUserContainer.of(context);
        print("ON LOGIN");
        print(jsonResponse);
        container.create(jsonResponse["name"], jsonResponse["id"], jsonResponse["email"], jsonResponse["age"], jsonResponse["description"], jsonResponse["gender"], cookie.substring(4,cookie.length));
        this.onLogin();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    String loginUrl = "http://engserv-1-aulas.ws.atnog.av.it.pt/lobin";
    this.context = context;

    return new WebviewScaffold(
      url: loginUrl,
      appBar: new AppBar(
        title: new Text("Login Page"),
      ),
      withJavascript: true,
      withLocalStorage: true,
      withZoom: false,

    );
  }
}
