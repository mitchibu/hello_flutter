import 'package:flutter/material.dart';

typedef Widget ItemBuilder<T>(BuildContext context, T data, int position);
typedef Future<List> PageFuture(int startPosition, int pageSize);

class PagedListView extends StatefulWidget {
  final ItemBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final PageFuture pageFuture;
  final int pageSize;
  final int distance;

  PagedListView({
    Key key,
    this.padding,
    @required this.itemBuilder,
    @required this.pageSize,
    @required this.pageFuture,
    this.distance = 5,
  }) : super(key: key);

  @override
  _PagedListViewState createState() => _PagedListViewState();
}

class _PagedListViewState extends State<PagedListView> {
  final List<dynamic> entries = [];

  bool _hasNext = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: widget.padding,
      itemCount: entries.length,
      itemBuilder: (context, position) {
        if(_hasNext && position == entries.length - widget.distance) {
          _load();
        }
        return widget.itemBuilder(context, entries[position], position);
      },
    );
  }

  void _load() {
    widget.pageFuture(entries.length, widget.pageSize).then((data) {
      _hasNext = data.isNotEmpty;
      if(!_hasNext) return;
      setState(() {
        entries.addAll(data);
      });
    });
  }
}

class PagedListAdapter<T> {
  final List<T> entries = [];
  final VoidCallback callback;
  final PageFuture pageFuture;
  final int pageSize;
  final int distance;

  bool _hasNext = true;

  PagedListAdapter({
    @required this.callback,
    @required this.pageFuture,
    this.pageSize = 20,
    this.distance = 5,
  }) {
    _load(entries.length, pageSize);
  }

  int getCount() => entries.length;
  
  T getAt(int index) {
    if(_hasNext && index == entries.length - distance) {
      _load(entries.length, pageSize);
    }
    return entries[index];
  }

  void reload() {
    entries.clear();
    _load(0, entries.length);
  }

  void _load(int startPosition, int pageSize) async {
    List<T> data = await pageFuture(startPosition, pageSize);
    _hasNext = data.isNotEmpty;
    if(!_hasNext) return;
    entries.addAll(data);
    callback();
  }
}
