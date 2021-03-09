import 'dart:async';

import 'register/register_page.dart';
import 'login/login_page.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final int page;
  final Function authSuccessful;

  AuthScreen(this.page, {@required this.authSuccessful});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  PageController _pageController;

  final StreamController _titleController = StreamController.broadcast();

  int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.page);
    _currentPage = widget.page;
    _pageController.addListener(() {
      if (_currentPage != _pageController.page.round()) {
        _currentPage = _pageController.page.round();
        _titleController.add(_currentPage);
      }
    });
  }

  void _animateToPage(int page) {
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: kElevationToShadow[2],
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: kToolbarHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: StreamBuilder(
                      stream: _titleController.stream,
                      initialData: widget.page,
                      builder: (context, page) => Text(
                        page.data == 0
                            ? 'Register'
                            : page.data == 1
                                ? 'Login'
                                : 'Forgot password',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey.shade100),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RegisterPage(
                      goToPage: _animateToPage,
                      authSuccessful: widget.authSuccessful,
                    ),
                    LoginPage(
                      goToPage: _animateToPage,
                      authSuccessful: widget.authSuccessful,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.close();
    super.dispose();
  }
}
