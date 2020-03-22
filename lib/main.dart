import 'package:car_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cars_detail_screen.dart';
import './screens/cars_overview_screen.dart';
import './screens/user_car_screen.dart';
import './screens/car_edit_screen.dart';
import './models/cars.dart';
import './screens/user_auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Cars>(
          builder: (ctx, auth, previousCars) => Cars(auth.token,
              previousCars == null ? [] : previousCars.cars, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: authData.isAuth
              ? CarOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : UserAuthScreen(),
                ),
          // home: CarOverviewScreen(),
          routes: {
            CarDetailScreen.routeName: (ctx) => CarDetailScreen(),
            UserCarScreen.routeName: (ctx) => UserCarScreen(),
            CarEditScreen.routeName: (ctx) => CarEditScreen(),
          },
        ),
      ),
    );
  }
}
