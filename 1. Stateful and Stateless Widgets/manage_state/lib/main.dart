import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return ScopedModel<AppState>(
      model: AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Viewer',
        home: ScopedModelDescendant<AppState>(builder: (context, child, model) {
          return GalleryPage(
            title: 'Image Gallery',
            model: model,
          );
        }),
      ),
    );
  }
}

class AppState extends Model {
  bool isTagging = false;
  List<PhotoState> photoStates = List.of(urls.map((url) => PhotoState(url)));
  Set<String> tags = {"all", "nature", "cat"};

  static AppState of(BuildContext context) {
    return ScopedModel.of<AppState>(context);
  }

  void selectTag(String tag) {
    if (isTagging) {
      if (tag != "all") {
        photoStates.forEach((element) {
          if (element.selected) {
            element.tags.add(tag);
          }
        });
      }
      toggleTagging(null);
    } else {
      photoStates.forEach((element) {
        element.display = tag == "all" ? true : element.tags.contains(tag);
      });
    }
    notifyListeners();
  }

  void toggleTagging(String url) {
    isTagging = !isTagging;
    photoStates.forEach((element) {
      if (isTagging && element.url == url) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    });
    notifyListeners();
  }

  void onPhotoSelect(String url, bool selected) {
    photoStates.forEach((element) {
      if (element.url == url) {
        element.selected = selected;
      }
    });
    notifyListeners();
  }
}

class PhotoState {
  String url;
  bool selected;
  bool display;
  Set<String> tags = {};

  PhotoState(this.url, {this.selected = false, this.display = true, tags});
}

class GalleryPage extends StatelessWidget {
  final String title;
  final AppState model;

  GalleryPage({this.title, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.title)),
      body: Builder(
        builder: (BuildContext innerContext) {
          return GridView.count(
            primary: false,
            crossAxisCount: 2,
            children:
                List.of(model.photoStates.where((ps) => ps.display ?? true).map(
                      (ps) => Photo(
                        state: ps,
                        model: AppState.of(
                            context), //ScopedModel.of<AppState>(context),
                      ),
                    )),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: List.of(
            model.tags.map((t) => ListTile(
                  title: Text(t),
                  onTap: () {
                    model.selectTag(t);
                    Navigator.of(context).pop();
                  },
                )),
          ),
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;
  final AppState model;

  Photo({this.state, this.model});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
        child: Image.network(state.url),
        onLongPress: () => model.toggleTagging(state.url),
      ),
    ];

    if (model.isTagging) {
      children.add(Positioned(
          left: 20,
          top: 0,
          child: Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Colors.grey[200]),
            child: Checkbox(
              onChanged: (value) {
                model.onPhotoSelect(state.url, value);
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
