import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_flutter/db/model/account_view.dart';
import 'package:hello_flutter/localizations.dart';

import '../detail/main.dart';
import '../../db/database.dart';
import '../widget/pagedlistview.dart';

import 'package:page_transition/page_transition.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> /*with WidgetsBindingObserver*/ {
  final DatabaseHelper _db = DatabaseHelper();

  PagedListAdapter<AccountView> _data;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _data = PagedListAdapter<AccountView>(
      callback: () {
        setState(() {
        });
      },
      pageFuture: (int startPosition, int pageSize) => _db.getAccountView(limit: pageSize, offset: startPosition),
      pageSize: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                title: Text('Item1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(context),
      floatingActionButton: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child:
          FloatingActionButton(
            onPressed: () {
              if(_isVisible) _showDetail(null);
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if(notification is UserScrollNotification) {
          setState(() {
            _isVisible = notification.direction == ScrollDirection.idle;
          });
        }
      },
      child:
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
          itemCount: _data.getCount(),
          itemBuilder: (context, position) {
            return _buildRow(context, _data.getAt(position), position);
          },
        ),
    );
  }

  Widget _buildRow(BuildContext context, AccountView accountView, int position) {
    return Dismissible(
      key: Key(accountView.account.name),
      onDismissed: (direction) {
        bool isRemoved = true;
        setState(() {
          _db.deleteAccount(accountView.account, isLogical: true);
          _data.remove(position);
        });
        final snackBar = SnackBar(
          content: Text(MyLocalizations.of(context).$('message_delete')),
          duration: const Duration(milliseconds: 8000),
          action: SnackBarAction(
            label: MyLocalizations.of(context).$('undo'),
            onPressed: () {
              // Some code to undo the change!
              isRemoved = false;
              setState(() {
                _db.cancelDeleteAccount(accountView.account);
                _data.insert(position, accountView);
              });
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar).closed.then((reason) {
          if(isRemoved) _db.deleteAccount(accountView.account);
          //_db.deleteAccount(account, isLogical: false).then((v) {
            //_data.remove(position);
            //_data.reload();
          //});
          // これで落ちる
          // setState(() {});
          // _db.deleteAccount(account, isLogical: false).then((v){
          //   setState(() {});
          // });
        });
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      child: _buildListTile(accountView),
    );
  }

  Widget _buildListTile(AccountView accountView) {
    return ListTile(
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              accountView.category.name,
              style: const TextStyle(fontSize: 14.0),
            ),
            Text(
              accountView.account.title,
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              accountView.account.name,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      onTap: () async {
        _showDetail(accountView);
      },
    );
  }

  void _showDetail(AccountView accountView) async {
    print("before");
    final result = await Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeftWithFade, child: DetailWidget(accountView: accountView)));
    print("after$result");
  }
}
