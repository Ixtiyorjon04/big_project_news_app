import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'news_mdoel.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

void main() {
  runApp(MyApp());
}

class _HomePageState extends State<HomePage> {
  static List<News> _news = <News>[];
  static List<News> _newsInApp = <News>[];

  Future<List<News>> comingNews() async {
    var url = 'http://www.mocky.io/v2/5ecfddf13200006600e3d6d0';
    var responce = await http.get(Uri.parse(url));
    var news = <News>[];
    if (responce.statusCode == 200) {
      var notesJson = json.decode(responce.body);
      for (var noteJson in notesJson) {
        news.add(News.fromJson(noteJson));
      }
    }
    return news;
  }

  @override
  void initState() {
    comingNews().then((value) {
      setState(() {
        _news.addAll(value);
        _newsInApp = _news;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.white))),
              child: AppBar(
                backgroundColor: Colors.white70,
                title: const Text(
                  'News',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30),
                ),
                // centerTitle: true,
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _listItem(index);
        },
        itemCount: _newsInApp.length,
      ),
    );
  }

  _listItem(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left:10, right: 5),
            child:
            Container(
              height: 90,
              width: 90,

              child: Image.network(
                _newsInApp[index].image,
                fit: BoxFit.cover,
              ),
            ),
            ),
            Expanded(
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 5, top: 5),
                    child: Text(
                      _newsInApp[index].title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 5),
                  child: Text(

                    _newsInApp[index].publisher,textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 17),

                  ),
                ),
              ]),
            ),
            Container(
              color: Colors.white70,
              height: 80,
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                    iconSize: 19,
                    color: Colors.black,

                    onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          String writer = _newsInApp[index].author;
                          String dat = _newsInApp[index].date;
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            home: Scaffold(
                              appBar: AppBar(
                                centerTitle: true,
                                backgroundColor: Colors.white,
                                leading: IconButton(
                                  iconSize: 20,
                                  color: Colors.blue,
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                title: Text(
                                  _newsInApp[index].title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              body: SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 220,
                                        width: 400,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Image.network(
                                          _newsInApp[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      ListTile(
                                        title: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _newsInApp[index].title,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                textAlign: TextAlign.left,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                _newsInApp[index].publisher,
                                                style: const TextStyle(
                                                  color: Colors.black26,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                _newsInApp[index].text,
                                                textAlign: TextAlign.justify,
                                                style:
                                                    TextStyle(wordSpacing: 2),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text('Author:$writer'),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text('Date:$dat'),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text('Full story at:'),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  if (await canLaunch(
                                                      _newsInApp[index].url)) {
                                                    await launch(
                                                        _newsInApp[index].url);
                                                  }
                                                },
                                                child: Text(
                                                  _newsInApp[index].url,
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                    icon: Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 0),
          child: Divider(
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
