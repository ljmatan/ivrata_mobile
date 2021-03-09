import 'dart:convert';

import 'package:ivrata_mobile/data/auth/user_data.dart';
import 'package:ivrata_mobile/logic/api/auth.dart';
import 'package:ivrata_mobile/logic/api/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RegisterPage extends StatefulWidget {
  final Function(int) goToPage;
  final Function authSuccessful;

  RegisterPage({@required this.goToPage, @required this.authSuccessful});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _verifying = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    enabled: !_verifying,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      enabled: !_verifying,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    enabled: !_verifying,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      obscureText: true,
                      enabled: !_verifying,
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      obscureText: true,
                      enabled: !_verifying,
                      controller: _repeatPasswordController,
                      decoration: InputDecoration(labelText: 'Repeat Password'),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 16,
                          height: 48,
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: _verifying ? null : () => widget.goToPage(1),
                    ),
                    GestureDetector(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 16,
                          height: 48,
                          child: Center(
                            child: _verifying
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'REGISTER',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      onTap: _verifying
                          ? null
                          : () async {
                              if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(_emailController.text) &&
                                  _nameController.text.isNotEmpty &&
                                  _usernameController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty &&
                                  _repeatPasswordController.text.isNotEmpty &&
                                  _passwordController.text ==
                                      _repeatPasswordController.text) {
                                setState(() => _verifying = true);
                                try {
                                  final response = await Auth.register(
                                    _usernameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _nameController.text,
                                  );
                                  final decoded = jsonDecode(response.body);
                                  if (decoded['error'] == null) {
                                    final int id = int.parse(decoded['status']);
                                    final userInfoResponse =
                                        await Auth.getUserInfo(id);
                                    final decodedUserInfo =
                                        jsonDecode(userInfoResponse.body);
                                    if (decodedUserInfo['error'] == true)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'User created but couldn\'t fetch data. Please try logging in.')));
                                    else {
                                      print(userInfoResponse.body);
                                      final userData = UserData.fromJson(
                                          decodedUserInfo['response']['user']);
                                      await User.setInstance(userData, true);
                                      widget.authSuccessful();
                                    }
                                  } else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(decoded['error'])));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$e')));
                                }
                                if (mounted) setState(() => _verifying = false);
                              } else
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(_passwordController
                                                    .text !=
                                                _repeatPasswordController.text
                                            ? 'Passwords don\'t match'
                                            : 'Email invalid')));
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
