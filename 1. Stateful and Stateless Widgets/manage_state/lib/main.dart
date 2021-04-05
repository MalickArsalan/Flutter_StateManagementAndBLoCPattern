import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(App());
}

const List<String> urls = [
  "https://live.staticflickr.com/65535/50489498856_67fbe52703_b.jpg",
  "https://live.staticflickr.com/65535/50488789068_de551f0ba7_b.jpg",
  "https://live.staticflickr.com/65535/50488789118_247cc6c20a.jpg",
  "https://live.staticflickr.com/65535/50488789168_ff9f1f8809.jpg",
];

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Viewer',
      home: GalleryPage(
        title: 'Image Gallery',
        urls: urls,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GalleryPage extends StatelessWidget {
  final String title;
  final List<String> urls;

  GalleryPage({this.title, this.urls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.title)),
      body: GridView.count(
        primary: false,
        crossAxisCount: 2,
        children: List.of(urls.map((url) => Photo(url: url))),
      ),
    );
  }
}

// class Photo extends StatefulWidget {
//   final String url;
//   //final int index;

//   Photo({this.url});

//   @override
//   _PhotoState createState() =>
//       _PhotoState(url: this.url, index: urls.indexOf(this.url));
// }

// class _PhotoState extends State<Photo> {
//   String url;
//   int index;

//   _PhotoState({this.url, this.index});

//   onTap() {
//     print(index);
//     setState(() {
//       index >= urls.length - 1 ? index = 0 : index++;
//     });
//     url = urls[index];
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(index);
//     return Container(
//       padding: EdgeInsets.only(top: 10),
//       child: GestureDetector(
//         child: Image.network(url),
//         onTap: onTap,
//       ),
//     );
//   }
// }

class Photo extends StatelessWidget {
  final String url;

  Photo({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10), child: Image.network(url));
  }
}
