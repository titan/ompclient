import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/store/session.dart';

class LoginPage extends StatefulWidget {
  final String title;
  final Store store;

  LoginPage({Key key, this.title, this.store}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _account, _passwd;
  bool _autovalidate = false;
  bool _formWasEdited = false;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormFieldState<InputValue>> _passwordFieldKey = new GlobalKey<FormFieldState<InputValue>>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }

  void _handleSubmitted(BuildContext context) {
    FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;  // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('account $_account, password $_passwd');
      signIn(config.store, _account, _passwd);
    }
  }

  String _validateAccount(InputValue value) {
    _formWasEdited = true;
    if (value.text.isEmpty)
      return '请填写帐号';
    RegExp nameExp = new RegExp(r'^[A-za-z_0-9]+$');
    if (!nameExp.hasMatch(value.text))
      return '请仅填写英文字母+数字';
    return null;
  }


  String _validatePassword(InputValue value) {
    _formWasEdited = true;
    FormFieldState<InputValue> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.text.isEmpty)
      return '请输入密码';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(config.title),
        ),
        body: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new TextField(
                icon: new Icon(Icons.person),
                hintText: '请输入帐号',
                labelText: '帐号',
                onSaved: (InputValue value) { _account = value.text; },
                validator: _validateAccount,
              ),
              new TextField(
                key: _passwordFieldKey,
                icon: new Icon(Icons.vpn_key),
                hintText: '请输入密码',
                labelText: '密码',
                obscureText: true,
                onSaved: (InputValue value) { _passwd = value.text; },
                validator: _validatePassword,
              ),
              new Container(
                padding: const EdgeInsets.all(20.0),
                alignment: const FractionalOffset(0.5, 0.5),
                child: new RaisedButton(
                  child: new Text('登录'),
                  onPressed: () { _handleSubmitted(context); },
                ),
              ),
            ],
          ),
        ),
      );
  }
}
