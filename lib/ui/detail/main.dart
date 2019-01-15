import 'package:hello_flutter/db/model/account.dart';
import 'package:hello_flutter/db/model/account_view.dart';
import 'package:hello_flutter/db/model/category.dart';
import 'package:flutter/material.dart';

class DetailWidget extends StatefulWidget {
  final AccountView accountView;
  Account _account;
  Category _category;

  DetailWidget({Key key, this.accountView}) : super(key: key) {
    _account = accountView == null ? Account(title: '', name: '',) : accountView.account;
    _category = accountView == null ? Category(name: '',) : accountView.category;
  }

  @override
  _DetailWidgetState createState() => _DetailWidgetState(accountView);
}

class _DetailWidgetState extends State<DetailWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool visiblePassword = false;

  _DetailWidgetState(AccountView accountView) {
    _titleController.text = accountView.account.title;
    _nameController.text = accountView.account.name;
    _passwordController.text = accountView.account.password;
  }

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              //widget._account.title,
              //style: const TextStyle(fontSize: 18.0),
              controller: _titleController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'title',
              ),
            ),
            TextFormField(
              //widget._account.title,
              //style: const TextStyle(fontSize: 18.0),
              controller: _nameController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'name',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !visiblePassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'password',
                suffixIcon: IconButton(
                  icon: Icon(visiblePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      visiblePassword = !visiblePassword;
                    });
                  },
                )
              ),
            ),
          ],
      ),
    );
  }
}
