import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../amplifyconfiguration.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List _users;

  @override
  void initState() {
    super.initState();
    Amplify.Auth.fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: true))
        .then((session) {
      var token = (session as CognitoAuthSession).userPoolTokens.idToken;
      SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
        prefs.setString("token", token);
      });
    });
    _usersList(context).then((u) {
      setState(() {
        _users = u;
      });
    });
  }

  _usersList(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token");
    var response = await get(Uri.parse('${dotenv.env['BASE_URI']}users'),
        headers: {'Authorization': token});

    var decodedResponse = Map<String, dynamic>.from(json.decode(response.body));
    var usersResponse = List<dynamic>.from(decodedResponse['Items']);
    print(decodedResponse);
    var users = [];
    for (var i = 0; i < usersResponse.length; i++) {
      users.add(ListTile(
          onTap: () => {
                Navigator.of(context).pushReplacementNamed('/profile',
                    arguments: usersResponse[i])
              },
          title: Center(
            child: Column(children: [
              Text(
                usersResponse[i]['email'],
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                usersResponse[i]['id'],
                style: TextStyle(fontSize: 18.0),
              ),
            ]),
          )));
    }

    return users;
  }

  final title = [
    Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
          child: Text(
        "List of users",
        style: TextStyle(fontSize: 23),
      )),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            MaterialButton(
              onPressed: () {
                Amplify.Auth.signOut().then((_) {
                  Navigator.pushReplacementNamed(context, '/');
                });
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(children: [...title, if (_users != null) ..._users]));
  }
}
