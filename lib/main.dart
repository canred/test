// import 'dart:developer';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/my_user.dart';
import 'welcome_page.dart';
import 'package:system_theme/system_theme.dart';
// import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

MyUser? myUser = MyUser();
String? ACCESS_TOKEN;
void main() => runApp(const MyApp());

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAD OAuth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AAD OAuth Home'),
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final Config config = Config(
    tenant: '3e7e3a11-2a69-4cad-9463-ea92f2fed6c0',
    clientId: 'c6dcb0ea-1509-4d4a-9fe1-0df47e8bb707',
    scope: 'openid profile offline_access User.Read',
    //scope: 'User.Read',
    redirectUri: kIsWeb ? "your local host URL" : "msauth://com.vis.test/%2Frn0m6TJIR79gIT%2BHb%2FZVR1V3%2Bc%3D",
    // msauth://com.example/%2Frn0m6TJIR79gIT%2BHb%2FZVR1V3%2Bc%3D

    navigatorKey: navigatorKey,
    //loader: SizedBox(),
    // appBar: AppBar(
    //   title: Text('AAD OAuth Demo'),
    // ),
    // onPageFinished: (String url) {
    //   log('onPageFinished: $url');
    // },
  );
  final AadOAuth oauth = AadOAuth(config);

  Future azureSignInApi(bool redirect) async {
    final AadOAuth oauth = AadOAuth(config);

    config.webUseRedirect = redirect;
    final result = await oauth.login();

    result.fold(
      (l) => showError("Microsoft Authentication Failed!"),
      (r) async {
        final result = await fetchAzureUserDetails(r.accessToken);
      },
    );
  }

  static Future<MyUser?> fetchAzureUserDetails(accessToken) async {
    http.Response response;
    response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me"),
      //Uri.parse("https://graph.microsoft.com/v1.0/User.Read"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    dynamic returnValue = json.decode(response.body);
    // myUser = User.fromJson(returnValue);
    myUser = MyUser.fromJson(returnValue);
    print(returnValue);
    // 回傳的內容如下
    // {
    //   "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
    //   "businessPhones": [],
    //   "displayName": "慧鴻 陳",
    //   "givenName": "慧鴻",
    //   "jobTitle": null,
    //   "mail": null,
    //   "mobilePhone": null,
    //   "officeLocation": null,
    //   "preferredLanguage": "en",
    //   "surname": "陳",
    //   "userPrincipalName": "canred.chen_gmail.com#EXT#@canredchengmail.onmicrosoft.com",
    //   "id": "77754466-d5f2-43bf-8671-dba3426522bf"
    // }
    return myUser;
    // return returnValue;
  }

  static Future<MyUser?> fetchAzureUserDetails2(accessToken) async {
    // accessToken 是一個JWT token，協助我用來取得使用者資訊
    final aaa = JWT.decode(accessToken);
    //aaa.payload.
    myUser = MyUser();
    myUser?.mail = findKeyByValue(aaa.payload, "upn");
    ACCESS_TOKEN = accessToken;
    return myUser;
  }

  static String? findKeyByValue(Map<String, dynamic> map, String value) {
    var retValue = map[value];
    return retValue;
    //return map.keys.firstWhere((k) => map[k] == value, orElse: () => "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'AzureAD OAuth',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ListTile(
            leading: Icon(Icons.launch),
            title: Text('Login${kIsWeb ? ' (web popup)' : ''}'),
            onTap: () {
              login(false);
            },
          ),
          if (kIsWeb)
            ListTile(
              leading: Icon(Icons.launch),
              title: Text('Login (web redirect)'),
              onTap: () {
                login(true);
              },
            ),
          ListTile(
            leading: Icon(Icons.data_array),
            title: Text('HasCachedAccountInformation'),
            onTap: () => hasCachedAccountInformation(),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              logout();
            },
          ),
          Checkbox(value: true, onChanged: (bool? value) {}),
          // FluentUI.ToggleSwitch(
          //   checked: true,
          //   onChanged: (bool value) {
          //     print(value);
          //   },
          // ),
          // ToggleSwitch(checked: true, onChanged: onChanged)
        ],
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login(bool redirect) async {
    config.webUseRedirect = redirect;
    final result = await oauth.login();
    result.fold(
      (l) => showError(l.toString()),
      (r) async => await fetchAzureUserDetails2(r.idToken).then((onValue) => {
            if (myUser != null)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(user: myUser!),
                  ),
                ),
              }
          }),
      //(r) async => showMessage("Microsoft Authentication Success!"),
    );
    var accessToken = await oauth.getAccessToken();
    if (accessToken != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accessToken)));
    }
  }

  void hasCachedAccountInformation() async {
    var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('HasCachedAccountInformation: $hasCachedAccountInformation'),
      ),
    );
  }

  void logout() async {
    await oauth.logout();
    showMessage('Logged out');
  }
}
