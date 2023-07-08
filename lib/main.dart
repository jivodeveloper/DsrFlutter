import 'package:flutter/material.dart';
import 'package:promoterapp/provider/DropdownProvider.dart';
import 'package:promoterapp/screens/SplashScreen.dart';
import 'package:promoterapp/provider/DistributorProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'location_service/logic/location_controller/location_controller_cubit.dart';
import 'location_service/repository/location_service_repository.dart';
import 'notification/notification.dart';

// final notificationService = NotificationService(FlutterLocalNotificationsPlugin());

void main() {

  // WidgetsFlutterBinding.ensureInitialized();
  // Workmanager().initialize(callbackDispatcher);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[

        // BlocProvider(
        //   create: (context) => LocationControllerCubit(
        //     locationServiceRepository: LocationServiceRepository(),
        //   ),
        // ),

        ChangeNotifierProvider<DropdownProvider>(
            create: (_)=> DropdownProvider()
        ),

        ChangeNotifierProvider<DistributorProvider>(
          create: (_)=> DistributorProvider(),
        )

      ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }

}

// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider.value(
//         value : notificationService,
//         child:MultiBlocProvider(
//             providers:[
//
//               BlocProvider(
//                 create: (context) => LocationControllerCubit(
//                   locationServiceRepository: LocationServiceRepository(),
//                 ),
//               ),
//
//               ChangeNotifierProvider<DropdownProvider>(
//                   create: (_)=> DropdownProvider()
//               ),
//
//               ChangeNotifierProvider<DistributorProvider>(
//                 create: (_)=> DistributorProvider(),
//               )
//
//             ],
//           child:MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: SplashScreen(),
//          ),
//         ),
//
//     );
//   }
//
// }


