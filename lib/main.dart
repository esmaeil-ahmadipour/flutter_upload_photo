import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final String phpEndPoint = 'https://{ USE LOCAL-HOST OR PERSONAL-HOST }/CerSavePicture.php';
  bool _waitingPageState = false;

  String randomName =(new Random().nextInt(100000).toString());

  File file;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _showWaitingPage(bool isShow) async {
    if (mounted) {
      setState(() {
        _waitingPageState = isShow;
      });
    }
  }

   _upload() async {
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = randomName;

    http.post(phpEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
      print(phpEndPoint);

    }).catchError((err) {
      print(err);
      print(phpEndPoint);

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body:       Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _choose,
                  child: Text('Choose Image'),
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                  onPressed: () async {
                    await _upload();
                  },
                  child: Text('Upload Image'),
                )
              ],
            ),
            file == null
                ? Text('No Image Selected')
                : Image.file(file)
          ],
        ),
    );
  }
}
