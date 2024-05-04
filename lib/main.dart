import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' ;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter HTTP CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Emp _data =Emp();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  final dio = Dio();

  Future<void> _fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      // final response = await dio.get('https://jsonplaceholder.typicode.com/posts');

      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body);
Emp emp=Emp.fromJson();
          // _data = response.data;
          print(_data);
          /*
          [{userId: 1, id: 1, title: sunt aut facere repellat provident occaecati excepturi optio reprehenderit, body: quia et suscipit
I/flutter ( 4993): suscipit recusandae consequuntur expedita et cum
I/flutter ( 4993): reprehenderit molestiae ut ut quas totam
I/flutter ( 4993): nostrum rerum est autem sunt rem eveniet architecto}, {userId: 1, id: 2, title: qui est esse, body: est rerum tempore vitae
I/flutter ( 4993): sequi sint nihil reprehenderit dolor beatae ea dolores neque
I/flutter ( 4993): fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis
I/flutter ( 4993): qui aperiam non debitis possimus qui neque nisi nulla}
           */
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _createData() async {
    try {
      final response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'title': 'Flutter HTTP CRUD',
            'body': 'This is a blog post about HTTP CRUD methods in Flutter',
            'userId': 1,
          }));

      if (response.statusCode == 201) {
        _fetchData();
      } else {
        throw Exception('Failed to create data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _updateData(int id) async {
    try {
      final response = await http.put(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{
            'title': 'Flutter HTTP CRUD',
            'body':
            'This is an updated blog post about HTTP CRUD methods in Flutter',
          }));

      if (response.statusCode == 200) {
        _fetchData();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

      if (response.statusCode == 200) {
        _fetchData();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];
          // PostModeL post=PostModeL.fromjson(data);
          return ListTile(
            title: Text(data['title']),
            subtitle: Text(data['body']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateData(data['id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteData(data['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createData,
        tooltip: 'Create',
        child: Icon(Icons.add),
      ),
    );
  }
}