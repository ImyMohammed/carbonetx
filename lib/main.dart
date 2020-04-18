import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:flutter/material.dart';
import 'package:carbonetx/screens/launch_screen.dart';
import 'package:carbonetx/screens/login_screen.dart';
import 'package:carbonetx/screens/signup_screen.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:flutter/services.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/loading_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TitleData>(
          create: (_) => TitleData(),
        ),
        ChangeNotifierProvider<CustomerDashboardData>(
          create: (_) => CustomerDashboardData(),
        ),
        ChangeNotifierProvider<CustomerDashboardInfoData>(
            create: (_) => CustomerDashboardInfoData()),
        ChangeNotifierProvider<DashboardSubtitleData>(
            create: (_) => DashboardSubtitleData()),
        ChangeNotifierProvider<LoadingOnOff>(create: (_) => LoadingOnOff())
      ],
      child: MaterialApp(
        color: Colors.black,
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        initialRoute: LaunchScreen.id,
        routes: {
          LaunchScreen.id: (context) => LaunchScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          DashboardScreen.id: (context) => DashboardScreen(),
        },
      ),
    );
  }
}
