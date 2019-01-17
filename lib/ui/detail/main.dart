import 'package:hello_flutter/db/database.dart';
import 'package:hello_flutter/db/model/account.dart';
import 'package:hello_flutter/db/model/account_view.dart';
import 'package:hello_flutter/db/model/category.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/localizations.dart';
import 'package:hello_flutter/ui/widget/pagedlistview.dart';

class DetailWidget extends StatefulWidget {
  final AccountView accountView;

  DetailWidget({Key key, this.accountView}) : super(key: key);

  @override
  _DetailWidgetState createState() => _DetailWidgetState(accountView);
}

class _DetailWidgetState extends State<DetailWidget> {
  final DatabaseHelper _db = DatabaseHelper();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  PagedListAdapter<Category> _data;
  bool visiblePassword = false;

  _DetailWidgetState(AccountView accountView) {
    _titleController.text = accountView.account.title;
    _categoryController.text = accountView.category.name;
    _nameController.text = accountView.account.name;
    _passwordController.text = accountView.account.password;
    _commentController.text = accountView.account.comment;
  }

  @override
  void initState() {
    super.initState();
    _data = PagedListAdapter<Category>(
      callback: () {
        setState(() {
        });
      },
      pageFuture: (int startPosition, int pageSize) => _db.getCategories(limit: pageSize, offset: startPosition),
      pageSize: 10,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: LayoutBuilder(builder: (context, viewportConstraints) => _buildBody(context, viewportConstraints)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BoxConstraints constraints) {
    return ListView(
      children: <Widget>[
        _createEntry(
          MyLocalizations.of(context).$('title'),
          _titleController
        ),
        _createEntry(
          MyLocalizations.of(context).$('category'),
          _categoryController,
          suffixIcon: IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.only(top: 50.0),
                    height: constraints.maxHeight / 3,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                      itemCount: _data.getCount(),
                      itemBuilder: (context, position) {
                        return ListTile(
                          title: Text(_data.getAt(position).name),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _categoryController.text = _data.getAt(position).name;
                              //_categoryController.value = _data.getAt(position);
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
        ),
        _createEntry(
          MyLocalizations.of(context).$('name'),
          _nameController,
        ),
        _createEntry(
          MyLocalizations.of(context).$('password'),
          _passwordController,
          obscureText: !visiblePassword,
          suffixIcon: IconButton(
            icon: Icon(visiblePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                visiblePassword = !visiblePassword;
              });
            },
          )
        ),
        _createEntry(
          MyLocalizations.of(context).$('comment'),
          _commentController,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _createEntry(
    String label,
    TextEditingController controller,
    {
      TextInputType keyboardType,
      bool obscureText = false,
      Widget suffixIcon
    }) {
    return ListTile(
      title: Text(label),
      subtitle: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        maxLines: keyboardType == TextInputType.multiline ? null : 1,
        decoration: InputDecoration(
          fillColor: Colors.cyan,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hasFloatingPlaceholder: false,
          labelText: label,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  void save() {
    // int count = await db.rawQuery("select count(*) FROM category where name = ?") _categoryController.text;
    /*
    if(count == 0) {
      await db.insert('category', categoryDao.toMap(category));
    }
    */
  }
}
