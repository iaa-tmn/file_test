import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


int _counter = 0;
int _counter2 = 0;



void main() {

  runApp(MyApp());
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', storage: CounterStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    _readCont();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter2=value;
      });
    });
  }


  void _readCont()  async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      _counter= prefs.getInt('counter') ?? 0;

    });
  }
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      _counter++;
    });
    await prefs.setInt('counter', _counter);
  }

  Future<File> _incrementCounter2() {
    setState(() {
      _counter2++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter2);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton( onPressed: _incrementCounter, icon: Icon(Icons.add)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_counter2',
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton( onPressed: _incrementCounter2, icon: Icon(Icons.add)),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
