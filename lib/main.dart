import 'package:flutter/material.dart';
import 'package:promoterapp/provider/DropdownProvider.dart';
import 'package:promoterapp/screens/SplashScreen.dart';
import 'package:promoterapp/provider/DistributorProvider.dart';
import 'package:promoterapp/util/locationbackground.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  // Workmanager().initialize(callbackDispatcher);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [

          ChangeNotifierProvider<DropdownProvider>(
              create: (_)=> DropdownProvider()),

          ChangeNotifierProvider<DistributorProvider>(
            create: (_)=> DistributorProvider(),)

        ],

        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        )

    );
  }

}


