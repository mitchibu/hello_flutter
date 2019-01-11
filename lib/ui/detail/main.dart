import 'package:flutter/material.dart';

import '../../db/model/account.dart';

class DetailWidget extends StatefulWidget {
  final Account account;

  DetailWidget({Key key, @required this.account}) : super(key: key);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  final List<Account> accounts = <Account>[];

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.account.title,
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              widget.account.name,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
      ),
    );
  }
}
