import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:http/http.dart' as http;

List<String> images = [];

List<Widget> cards = List.generate(
  images.length,
  (int index) {
    return Container(
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 17),
            blurRadius: 23.0,
            spreadRadius: -13.0,
            color: Colors.black54,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          images[index],
          fit: BoxFit.contain,
        ),
      ),
    );
  },
);

class TCardPage extends StatefulWidget {
  @override
  _TCardPageState createState() => _TCardPageState();
}

class _TCardPageState extends State<TCardPage> {
  Future<List<String>> getImages() async {
    const url = 'https://sodere-movies-scrape.vercel.app/';
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    List<String> images = [];
    for (var img in data) {
      images.add(img['image'].toString().trim());
    }
    return images;
  }

  void getData() async {
    images = await getImages();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  TCardController _controller = TCardController();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: images.length == 0
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  SizedBox(height: 100),
                  TCard(
                    size: Size(640, 360),
                    cards: cards,
                    controller: _controller,
                    onForward: (index, info) {
                      _index = index;
                      print(info.direction);
                      setState(() {});
                    },
                    onBack: (index) {
                      _index = index;
                      setState(() {});
                    },
                    onEnd: () {
                      print('end');
                    },
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      OutlineButton(
                        onPressed: () {
                          _controller.back();
                        },
                        child: Text('Back'),
                      ),
                      OutlineButton(
                        onPressed: () {
                          _controller.forward();
                        },
                        child: Text('Forward'),
                      ),
                      OutlineButton(
                        onPressed: () {
                          _controller.reset();
                        },
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text(_index.toString()),
      ),
    );
  }
}
