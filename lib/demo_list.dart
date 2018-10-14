import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class DemoListView extends StatefulWidget {
  final int length = 150;
  final _suggestions = <WordPair>[];

  @override
  State createState() => new _DemoListViewState();
}

class _DemoListViewState extends State<DemoListView> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
//          if (i >= widget.length) {
//            widget.length += 30;
//          }
        final index = i ~/ 2;
        widget._suggestions.add(WordPair.random());
        return _createItem(widget._suggestions[index]);
      },
      itemCount: widget.length,
    );
  }

  Widget _createItem(WordPair wordPair) {
    return new DemoItem(wordPair);
//    return new Text(wordPair.asPascalCase);
  }
}

class DemoItem extends StatefulWidget {
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 20.0);

  WordPair wordPair;

//  bool alreadySaved = false;

  DemoItem(this.wordPair) {
//    _saved.add(this.wordPair);
//    alreadySaved = _saved.contains(this.wordPair);
  }

  @override
  _DemoItemState createState() => new _DemoItemState();
}

class _DemoItemState extends State<DemoItem> {
  @override
  Widget build(BuildContext context) {
    final alreadySaved = widget._saved.contains(widget.wordPair);
    return new ListTile(
        title: new Text(
          widget.wordPair.asPascalCase,
          style: widget._biggerFont,
        ),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              widget._saved.remove(widget.wordPair);
            } else {
              widget._saved.add(widget.wordPair);
            }
          });
        });
//    return new Text(
//      widget.index.toString() + " - " + WordPair.random().asPascalCase,
//      style: _biggerFont,
//    );
  }
}
