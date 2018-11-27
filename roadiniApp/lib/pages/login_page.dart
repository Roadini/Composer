import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:roadini/models/user_app.dart';

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
            final container = AppUserContainer.of(context);
            container.create("tiago", 1, "tiago@ua.pt", cookie);
            this.onLogin();

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


  @override
  Widget build(BuildContext context) {
    String loginUrl = "http://engserv-1-aulas.ws.atnog.av.it.pt/login";
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
