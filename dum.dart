import 'dart:convert';

import 'package:http/http.dart' as http;

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

void main() async {
  var images = await getImages();
  print(images);
}
