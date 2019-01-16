import 'package:hello_flutter/db/database.dart';
import 'package:hello_flutter/db/model/account.dart';
import 'package:hello_flutter/db/model/account_view.dart';
import 'package:hello_flutter/db/model/category.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/ui/widget/pagedlistview.dart';

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
//    WidgetsBinding.instance.addObserver(this);
    // _load();
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
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _createEntry(
          'title',
          _titleController
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: _createEntry(
            'category',
            _categoryController,
            suffixIcon: IconButton(
              icon: Icon(Icons.category),
              onPressed: () {
                showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
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
                // setState(() {
                // });
              },
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: _createEntry(
            'name',
            _nameController,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: _createEntry(
            'password',
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
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: _createEntry(
            'comment',
            _commentController,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ],
    );
  }
  Widget _buildBody3() {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        if(viewportConstraints.hasBoundedHeight) {
          viewportConstraints = viewportConstraints.copyWith(maxHeight: viewportConstraints.maxHeight + MediaQuery.of(context).viewInsets.vertical);
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: viewportConstraints,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  //widget._account.title,
                  //style: const TextStyle(fontSize: 18.0),
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: _createInputBorder(),
                    labelText: 'title',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                ),
                TextFormField(
                  //widget._account.title,
                  //style: const TextStyle(fontSize: 18.0),
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: _createInputBorder(),
                    labelText: 'name',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !visiblePassword,
                  decoration: InputDecoration(
                    border: _createInputBorder(),
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
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                ),
                Expanded(
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _commentController,
                      decoration: InputDecoration(
                        fillColor: Colors.cyan,
                        filled: true,
                        border: _createInputBorder(),
                        labelText: 'comment',
                      ),
                    ),
                  ),
                ),
//                Expanded(
                  /*child:*/ Text('buttom'),
//                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildBody2() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              //widget._account.title,
              //style: const TextStyle(fontSize: 18.0),
              controller: _titleController,
              decoration: InputDecoration(
                border: _createInputBorder(),
                labelText: 'title',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
            ),
            TextFormField(
              //widget._account.title,
              //style: const TextStyle(fontSize: 18.0),
              controller: _nameController,
              decoration: InputDecoration(
                border: _createInputBorder(),
                labelText: 'name',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !visiblePassword,
              decoration: InputDecoration(
                border: _createInputBorder(),
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
            Padding(
              padding: EdgeInsets.only(top: 24.0),
            ),
            Expanded(
              child: Container(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  controller: _commentController,
                  decoration: InputDecoration(
                    fillColor: Colors.cyan,
                    border: _createInputBorder(),
                    labelText: 'comment',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
    const double radius = 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: radius / 2),
          child: Text(label),
        ),
        TextFormField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          maxLines: keyboardType == TextInputType.multiline ? null : 1,
          decoration: InputDecoration(
            fillColor: Colors.cyan,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide.none,
            ),
            hasFloatingPlaceholder: false,
            labelText: label,
            suffixIcon: suffixIcon,
          ),
        ),
      ]
    );
  }
  InputBorder _createInputBorder() {
//    return InputBorder.none;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide.none,
    );
  }
}
