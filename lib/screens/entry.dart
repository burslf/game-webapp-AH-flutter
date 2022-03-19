import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../widgets/login.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    Amplify.Auth.fetchAuthSession()
        .then((value) => {
              if (value.isSignedIn)
                {Navigator.of(context).pushReplacementNamed('/dashboard')}
            })
        .catchError((err) => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Login(),
      ),
    );
  }
}
