import 'package:flutter/material.dart';
import 'package:omdb_app/UI/Screens/homePage.dart';
import 'package:omdb_app/Utils/dark_theme_provider.dart';
import 'package:omdb_app/Utils/styles.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeProvider = new DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            title: 'OMDB Search App',
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeProvider.darkTheme, context),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
