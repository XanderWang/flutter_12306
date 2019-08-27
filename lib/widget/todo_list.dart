import 'package:flutter/material.dart';

class ToDoBean {
  String id;
  String title;
  String detail;
  String createAt;
  String completeAt;
  bool hasDone = false;
}

class ToDoListView extends StatefulWidget {
  final int length = 150;
  final List<ToDoBean> todoDatas;
  
  ToDoListView({Key key, this.todoDatas}) : super(key: key);

  @override
  State createState() => new _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // if (i.isOdd) return new Divider();
        // final index = i ~/ 2;
        return _createItem(widget.todoDatas[i]);
      },
      itemCount: widget.todoDatas.length,
    );
  }

  Widget _createItem(ToDoBean todoBean) {
    return new ToDoItemView(todoBean);
//    return new Text(wordPair.asPascalCase);
  }
}

class ToDoItemView extends StatefulWidget {
  final _biggerFont = const TextStyle(fontSize: 20.0);

  final ToDoBean toDoBean;

  ToDoItemView(this.toDoBean);

  @override
  _ToDoItemState createState() => new _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItemView> {
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(
          widget.toDoBean.title,
          style: widget._biggerFont,
        ),
        trailing: new Icon(
          widget.toDoBean.hasDone ? Icons.favorite : Icons.favorite_border,
          color: widget.toDoBean.hasDone ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (widget.toDoBean.hasDone) {
              widget.toDoBean.hasDone = false;
            } else {
              widget.toDoBean.hasDone = true;
            }
          });
        });
  }
}
