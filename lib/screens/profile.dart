import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class ProfileScreen extends StatefulWidget {
  var user;
  ProfileScreen({@required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _profileUrl;
  String _emailField;
  String _firstNameField;
  String _lastNameField;
  String _nicknameField;
  Widget _profilePicWidget;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: "email"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      initialValue: _emailField,
      onSaved: (String value) {
        _emailField = value;
      },
    );
  }

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "first name"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      initialValue: _firstNameField,
      onSaved: (String value) {
        _firstNameField = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "last name"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      initialValue: _lastNameField,
      onSaved: (String value) {
        _lastNameField = value;
      },
    );
  }

  Widget _buildNickname() {
    return TextFormField(
      decoration: InputDecoration(labelText: "nickname"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      initialValue: _nicknameField,
      onSaved: (String value) {
        _nicknameField = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailField = widget.user['email'];
      _firstNameField = widget.user['firstName'];
      _lastNameField = widget.user['lastName'];
      _nicknameField = widget.user['nickname'];
      _profileUrl =
          widget.user['profilePic'] != null ? widget.user['profilePic'] : '';
    });
    _profilePicWidget = CircleAvatar(
      backgroundImage: NetworkImage(_profileUrl),
      minRadius: 45,
    );
    Amplify.Auth.getCurrentUser().then((user) {
      if (user.userId == widget.user['id']) {
        setState(() {
          _profilePicWidget = GestureDetector(
            onTap: () async {
              await uploadPicture();
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(_profileUrl),
              minRadius: 45,
            ),
          );
        });
      }
    }).catchError((error) {
      print((error as AuthException).message);
    });

    // }
  }

  uploadPicture() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token");
    FilePickerResult result = await FilePicker.platform
        .pickFiles(withReadStream: true, withData: true);
    if (result != null) {
      var filePath = result.files.first;
      var base64File = base64Encode(filePath.bytes);
      await post(
          Uri.parse(
              'https://jgpd7yrm48.execute-api.eu-central-1.amazonaws.com/prod/userProfilePic'),
          headers: {'Authorization': token},
          body: json.encode({'file': 'data:image/png;base64,$base64File'}));
      setState(() {
        _profileUrl = null;
      });
      Navigator.of(context)
          .pushReplacementNamed('/profile', arguments: widget.user);
    } else {
      print("USER CANCELED FILE UPOADING");
    }
  }

  uploadNewData() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token");
    var response = await post(
        Uri.parse(
            'https://jgpd7yrm48.execute-api.eu-central-1.amazonaws.com/prod/registerUser'),
        headers: {'Authorization': token},
        body: json.encode({
          "firstName": _firstNameField,
          "lastName": _lastNameField,
          "nickname": _nicknameField
        }));
    var decodedResponse = Map<String, dynamic>.from(json.decode(response.body));
    print(decodedResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                {Navigator.of(context).pushReplacementNamed('/dashboard')},
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Container(
            // height: 35,
            padding: EdgeInsets.only(top: 25, bottom: 35),
            child: Text(
              "Information about the user",
              style: TextStyle(fontSize: 20),
            ),
          ),
          if (_profileUrl != null) _profilePicWidget,
          _buildEmail(),
          _buildFirstName(),
          _buildLastName(),
          _buildNickname(),
          SizedBox(height: 80),
          ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                uploadNewData().then((r) {
                  print(r);
                });
              },
              child: Text("Submit")),
        ]),
      ),
    );
  }
}
