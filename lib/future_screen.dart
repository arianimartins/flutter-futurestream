import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_playgroung/post.dart';
import 'package:http/http.dart' as http;

class FutureScreen extends StatefulWidget {
  @override
  _FutureScreenState createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  bool _isList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Screen'),
        actions: <Widget>[
          _isList == false
              ? FlatButton(
                  onPressed: () {
                    setState(() {
                      _isList = true;
                    });
                  },
                  child: Text('Lista'))
              : FlatButton(
                  onPressed: () {
                    setState(() {
                      _isList = false;
                    });
                  },
                  child: Text('Single'))
        ],
      ),
      body: Container(
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.data != null
                ? (_isList == true
                    ? ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(snapshot.data[index].body),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: snapshot.data.length)
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Text(snapshot.data.title,
                                style: TextStyle(fontSize: 25.0)),
                            Text(snapshot.data.body)
                          ],
                        ),
                      ))
                : CircularProgressIndicator();
          },
          future: _isList == true ? _getPosts() : _getPost(),
        ),
      ),
    );
  }

  Future<Post> _getPost() async {
    //nosso dado de controle
    var url = 'https://jsonplaceholder.typicode.com/posts/2';

    //aguardando a resposta a requisição assíncrona
    var data = await http.get(url);
    //obtendo os dados da requisição
    var jsonData = json.decode(data.body);

    //passando os dados a objecto
    Post post = Post(jsonData['userId'], jsonData['id'], jsonData['title'],
        jsonData['body']);

    return post;
  }

  Future<List<Post>> _getPosts() async {
    var url = 'https://jsonplaceholder.typicode.com/posts';
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];

    //passando os dados a objectos
    for (var p in jsonData) {
      Post post = Post(p['userId'], p['id'], p['title'], p['body']);
      posts.add(post);
    }
    //print(posts.length);
    return posts;
  }
}
