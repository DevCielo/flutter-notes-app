import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Demo', home: FlutterDemo(storage: UserInputStorage()));
  }
}

class UserInputStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/list.txt');
  }

  Future<List<String>> readUserInput() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents.split('\n');
    } catch (error) {
      return [];
    }
  }

  Future<File> writeUserInput(List<String> userInput) async {
    final file = await _localFile;
    return file.writeAsString(userInput.join('\n'));
  }
}

class FlutterDemo extends StatefulWidget {
  FlutterDemo({Key? key, required this.storage}) : super(key: key);

  final UserInputStorage storage;

  @override
  State<StatefulWidget> createState() {
    return _FlutterDemoState();
  }
}

class _FlutterDemoState extends State<FlutterDemo> {
  final TextEditingController _title = TextEditingController();
  List<String> _todos = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readUserInput().then((value) {
      setState(() {
        _todos = value;
      });
    });
  }

  Future<File> _addNote() {
    setState(() {
      if (_title.text.isNotEmpty) {
        _todos.add(_title.text);
        _title.clear();
      }
    });
    return widget.storage.writeUserInput(_todos);
  }

  Future<File> _deleteNote(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    return widget.storage.writeUserInput(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _title,
              decoration: InputDecoration(labelText: 'Enter a note'),
            ),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: Text('Add Note'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* 
void main() {
  runApp(
    MaterialApp(title: 'Demo', home: FlutterDemo(storage: UserInputStorage()))
  );
}

class UserInputStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/input.txt');
  }

  Future<String> readUserInput() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (error) {
      return '';
    }
  }

  Future<File> writeUserInput(String userInput) async {
    final file = await _localFile;
    return file.writeAsString('$userInput');
  }
}


class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key, required this.storage}) : super(key : key);

  final UserInputStorage storage;

  @override
  State<FlutterDemo> createState() {
    return _FlutterDemoState();
  }
}

class _FlutterDemoState extends State<FlutterDemo> {
  final userInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.storage.readUserInput().then((value) {
      setState(() {
        userInputController.text = value;
      });
    });
  }

  Future<File> _saveUserInput() {
    return widget.storage.writeUserInput(userInputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userInputController.text.isEmpty ? 'DEMO' : userInputController.text)),
      body: Center(child: Padding(padding: const EdgeInsets.all(16.0),
       child: TextField(
        controller: userInputController,
        decoration: InputDecoration(labelText: 'Enter Text'),
      ))),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          _saveUserInput();
        });
      }, 
      tooltip: 'Save',
      child: const Icon(Icons.save),
      ),
    );
  }
}
 */

/* 

void main() {
  runApp(MaterialApp(title: 'demo', home: FlutterDemo(storage: CounterStorage())));
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
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (error) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() {
    return _FlutterDemoState();
  }
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;


  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App bar')),
      body: Center(child: Text('Button was tapped: $_counter'),),
      floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, child: const Icon(Icons.add) ,),
    );
  }
} */