import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db/model/account.dart';
import '../detail/main.dart';
import '../../transitions.dart';
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

  PagedListAdapter<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = PagedListAdapter<Map<String, dynamic>>(
      callback: () {
        setState(() {
          print(_data.getCount());
        });
      },
      pageFuture: (int startPosition, int pageSize) => _db.query('account', limit: pageSize, offset: startPosition),
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
        child: Drawer(),
      ),
      //drawer: Drawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
  Widget _buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      itemCount: _data.getCount(),
      itemBuilder: (context, position) {
        return _buildRow(Account.fromMap(_data.getAt(position)));
      },
    );
  }

  Widget _buildRow(Account account) {
    return ListTile(
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              account.title,
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              account.name,
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
        print("before");
        final result = await Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeftWithFade, child: DetailWidget(account: account)));
        print("after$result");
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
}
