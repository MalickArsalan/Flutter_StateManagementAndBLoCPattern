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

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  bool isTagging = false;
  List<PhotoState> photoStates = List.of(urls.map((url) => PhotoState(url)));

  void toggleTagging(String url) {
    setState(() {
      isTagging = !isTagging;
      photoStates.forEach((element) {
        if (isTagging && element.url == url) {
          element.selected = true;
        } else {
          element.selected = false;
        }
      });
    });
  }

  void onPhotoSelect(String url, bool selected) {
    setState(() {
      photoStates.forEach((element) {
        if (element.url == url) {
          element.selected = selected;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Viewer',
      home: GalleryPage(
        title: 'Image Gallery',
        photoStates: photoStates,
        tagging: isTagging,
        toggleTagging: toggleTagging,
        onPhotoSelect: onPhotoSelect,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PhotoState {
  String url;
  bool selected;

  PhotoState(this.url, {this.selected = false});
}

class GalleryPage extends StatelessWidget {
  final String title;
  final List<PhotoState> photoStates;
  final bool tagging;

  final Function toggleTagging;
  final Function onPhotoSelect;

  GalleryPage({
    this.title,
    this.photoStates,
    this.tagging,
    this.toggleTagging,
    this.onPhotoSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.title)),
      body: GridView.count(
        primary: false,
        crossAxisCount: 2,
        children: List.of(photoStates.map((ps) => Photo(
              state: ps,
              selectable: tagging,
              onLongPress: toggleTagging,
              onSelect: onPhotoSelect,
            ))),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;
  final bool selectable;

  final Function onLongPress;
  final Function onSelect;

  Photo({this.state, this.selectable, this.onLongPress, this.onSelect});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
        child: Image.network(state.url),
        onLongPress: () => onLongPress(state.url),
      ),
    ];

    if (selectable) {
      children.add(Positioned(
          left: 20,
          top: 0,
          child: Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Colors.grey[200]),
            child: Checkbox(
              onChanged: (value) {
                onSelect(state.url, value);
              },
              value: state.selected,
              activeColor: Colors.white,
              checkColor: Colors.black,
            ),
          )));
    }

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Stack(alignment: Alignment.center, children: children),
    );
  }
}
