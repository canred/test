import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'model/my_user.dart';
import 'echart_page.dart';
import 'money_page.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class WelcomePage extends StatefulWidget {
  final MyUser user;
  const WelcomePage({Key? key, required this.user}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late YoutubePlayerController _controller;
  late String API_IP = 'http://210.68.154.104/api/mobileTest';
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=Q1gg0EIKp0U')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _callApi() async {
    try {
      final response = await http.get(
        Uri.parse(API_IP),
        headers: <String, String>{
          //'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $ACCESS_TOKEN',
        },
      );
      //showMessage('$ACCESS_TOKEN');

      if (response.statusCode == 200) {
        showMessage(response.body);
        // If the server returns a 200 OK response, parse the JSON.
        //print('API call successful: ${response.body}');
      } else {
        showMessage('異常');
        showMessage(response.body);
        // If the server did not return a 200 OK response, throw an exception.
        //throw Exception('Failed to call API');
      }
    } catch (e) {
      showMessage('API呼叫失敗');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Azure Entra Id Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Define the action to be performed when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Echart_page(
                                  title: 'Echart',
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue, // 設定背景顏色為淡藍色
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // 設定圓角半徑為 8.0
                      ),
                    ),
                    child: const Text(
                      'ECharts',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Define the action to be performed when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MoneyPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue, // 設定背景顏色為淡藍色
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // 設定圓角半徑為 8.0
                      ),
                    ),
                    child: const Text(
                      '股價',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              Text(
                '歡迎, ${widget.user.displayName}!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'OData Context: ${widget.user.odataContext}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Business Phones: ${widget.user.businessPhones?.join(', ') ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Given Name: ${widget.user.givenName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Job Title: ${widget.user.jobTitle ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Mail: ${widget.user.mail ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Mobile Phone: ${widget.user.mobilePhone ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Office Location: ${widget.user.officeLocation ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Preferred Language: ${widget.user.preferredLanguage ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Surname: ${widget.user.surname ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'User Principal Name: ${widget.user.userPrincipalName ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'ID: ${widget.user.id ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'ID: ${widget.user.id ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextField(
                controller: TextEditingController(text: ACCESS_TOKEN),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'access token',
                ),
                maxLength: null,
                keyboardType: TextInputType.multiline,
              ),
              TextField(
                controller: TextEditingController(text: API_IP),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'API IP',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 我需要呼叫一個API，並且把access token傳過去
                  _callApi();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // 設定背景顏色為淡藍色
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // 設定圓角半徑為 8.0
                  ),
                ),
                child: const Text(
                  'Call API',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              // 加入一個 表單 物件
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                height: 400.0,
                child: Image.network(
                  'https://media.newyorker.com/photos/5b86ded37b50300447d167eb/master/w_2240,c_limit/StFelix-Michael-Jackson.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
