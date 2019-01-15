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
  //final MyDatabase _db = MyDatabase();
  final DatabaseHelper _db = DatabaseHelper();
//  final List<Account> accounts = <Account>[];

  PagedListAdapter<AccountView> _data;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _data = PagedListAdapter<AccountView>(
      callback: () {
        setState(() {
//          print(_data.getCount());
        });
      },
      pageFuture: (int startPosition, int pageSize) => _db.getAccountView(limit: pageSize, offset: startPosition),
      pageSize: 10,
    );
//    WidgetsBinding.instance.addObserver(this);
    // _load();
  }

  @override
  void dispose() {
//    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   if(state == AppLifecycleState.resumed) {
  //     // _load();
  //     _data.reload();
  //   }
  // }

  // void _load() {
  //   db.query('account').then((records) {
  //     setState(() {
  //       for(Map<String, dynamic> record in records) {
  //         accounts.add(Account.fromMap(record));
  //       }
  //     });
  //   });
  // }

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

  // Widget _buildBody() {
  //   return PagedListView(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
  //     itemBuilder: (context, data, position) {
  //       return _buildRow(Account.fromMap(data));
  //     },
  //     pageSize: 10,
  //     pageFuture: (int startPosition, int pageSize) => _db.query('account', pageSize, startPosition),
  //   );
  // }
  // Widget _buildBody() {
  //   return ListView.builder(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
  //     itemCount: accounts.length,
  //     itemBuilder: (context, position) {
  //       return _buildRow(accounts[position]);
  //     },
  //   );
  // }
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
        setState(() {
          _db.deleteAccount(accountView.account, isLogical: true);
          _data.remove(position);
        });
        // _db.deleteAccount(account, isLogical: true);
        final snackBar = SnackBar(
          content: Text(MyLocalizations.of(context).$('message_delete')),
          action: SnackBarAction(
            label: MyLocalizations.of(context).$('undo'),
            onPressed: () {
              // Some code to undo the change!
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar).closed.then((reason) {
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
        //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWidget(account: account)));
        //Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailWidget(account: account)));
        //Navigator.push(context, SlideTransitionRoute(builder: (context) => DetailWidget(account: account)));
        //Navigator.of(context).push(SlideLeftRoute2(enterWidget: DetailWidget(account: account), exitWidget: widget));
        _showDetail(accountView);
        /*Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (context, _, __) => DetailWidget(account: account),
          transitionsBuilder: (_, animation, secondaryAnimation, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
            // child: SlideTransition(
            //   position: Tween<Offset>(
            //     begin: Offset.zero,
            //     end: const Offset(-1.0, 0.0),
            //   ).animate(secondaryAnimation),
            //   child: child,
            // ),
          )
        ));*/
      },
    );
  }

  void _showDetail(AccountView accountView) async {
    print("before");
    final result = await Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeftWithFade, child: DetailWidget(accountView: accountView)));
    print("after$result");
  }
}
