import 'package:ivrata_mobile/data/auth/user_data.dart';
import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:ivrata_mobile/ui/elements/eula_agreement_dialog.dart';
import 'package:ivrata_mobile/ui/screens/home/home_screen.dart';
import 'package:ivrata_mobile/ui/shared/custom_app_bar.dart';
import 'package:ivrata_mobile/ui/shared/custom_nav_bar/custom_nav_bar.dart';

import 'bloc/view_controller.dart';
import 'user_auth/auth_screen.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    ViewController.init();
    if (!(Prefs.instance.getBool('eulaAccepted') ?? false))
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Theme.of(context).primaryColor,
          builder: (context) => AgreementDialog(),
        ),
      );
  }

  bool _loggedIn = User.loggedIn;

  void _authSuccessful() => setState(() => _loggedIn = true);

  int _authPage = 1;
  void _showAuthScreen(int page) {
    Navigator.pop(context);
    setState(() {
      _authPage = page;
      _loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loggedIn
          ? Column(
              children: [
                CustomAppBar(_showAuthScreen),
                StreamBuilder(
                  stream: ViewController.stream,
                  initialData: HomeScreen(),
                  builder: (context, view) => Expanded(child: view.data),
                ),
                CustomNavBar(),
              ],
            )
          : AuthScreen(_authPage, authSuccessful: _authSuccessful),
    );
  }

  @override
  void dispose() {
    ViewController.dispose();
    super.dispose();
  }
}
