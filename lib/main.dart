import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'screens/entry.dart';
import 'screens/profile.dart';
import 'screens/dashboard.dart';

import 'helpers/configure_amplify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amp Awesome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => DashboardScreen(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
        if (settings.name == '/profile') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ProfileScreen(user: settings.arguments),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}
