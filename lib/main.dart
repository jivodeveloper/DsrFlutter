import 'package:flutter/material.dart';
import 'package:promoterapp/screens/SplashScreen.dart';
import 'package:promoterapp/util/DropdownProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (_)=> DropdownProvider(),
        child:  new MyApp())

      );

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


