import 'package:ivrata_mobile/data/auth/user_data.dart';
import 'package:ivrata_mobile/ui/screens/profile/profile_screen.dart';
import 'package:ivrata_mobile/ui/screens/search/search_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Function(int) showAuthScreen;

  CustomAppBar(this.showAuthScreen);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: kElevationToShadow[2],
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.person,
                      color: Colors.white), //const Color(0xff3C3B6E)),
                  onPressed: () => User.loggedIn
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProfilePage(logoutSuccesful: showAuthScreen)))
                      : showModalBottomSheet(
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) => DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: kBottomNavigationBarHeight,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 56,
                                          child: Center(
                                            child: Text(
                                              'REGISTER',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () => showAuthScreen(0),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 56,
                                          child: Center(
                                            child: Text(
                                              'LOGIN',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () => showAuthScreen(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset('assets/images/ivrata_logo.png'),
                ),
                IconButton(
                  icon: Icon(Icons.search,
                      color: Colors.white), //const Color(0xff3C3B6E)),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SearchScreen())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
