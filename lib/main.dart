import 'logic/cache/db.dart';
import 'logic/cache/prefs.dart';
import 'ui/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: const Color(0xff1a1a1d),
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: const Color(0xff1a1a1d),
    statusBarIconBrightness: Brightness.light,
  ));

  // Required by the framework
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();

  await DB.init();

  runApp(AmericonictvIvrataMobile());
}

class AmericonictvIvrataMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff4e4e50),
        primaryColor: const Color(0xff1a1a1d),
        accentColor: const Color(0xffff0000), // const Color(0xffB22234),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff1a1a1d),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          titleSpacing: 12,
          centerTitle: false,
          brightness: Brightness.dark,
          color: Color(0xff1a1a1d),
        ),
        splashColor: Colors.transparent,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
      home: MainView(),
    );
  }
}
